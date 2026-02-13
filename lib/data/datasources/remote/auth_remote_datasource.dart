// data/datasources/remote/auth_remote_datasource.dart
//
// 📌 AuthRemoteDataSource - Firebase Auth işlemleri
//
// Data Layer'da bulunur.
// Firebase hatalarını AppException'a dönüştürüp fırlatır.
// Repository bu exception'ları yakalar ve Failure'a dönüştürür.

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:injectable/injectable.dart';
import 'package:toplansin_cleanarch/core/config/env_config.dart';
import 'package:toplansin_cleanarch/core/errors/exceptions.dart';
import 'package:toplansin_cleanarch/core/errors/firebase_error_handler.dart';
import 'package:toplansin_cleanarch/core/utils/logger.dart';
import 'package:toplansin_cleanarch/domain/entities/email_check_entity.dart';
import 'package:toplansin_cleanarch/domain/entities/user_entity.dart';
import 'package:toplansin_cleanarch/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Email/şifre ile kayıt
  /// @throws AuthException kayıt başarısız olursa
  Future<UserEntity> signUp(String email, String password, String name);

  /// Email/şifre ile giriş
  /// @throws AuthException giriş başarısız olursa
  Future<UserEntity> signIn(String email, String password);

  /// Google ile giriş
  /// @throws AuthException giriş başarısız olursa
  /// @returns null if user cancelled
  Future<UserEntity?> signInWithGoogle();

  /// Apple ile giriş
  /// @throws AuthException giriş başarısız olursa
  /// @returns null if user cancelled
  Future<UserEntity?> signInWithApple();

  /// Çıkış yap
  /// @throws AuthException çıkış başarısız olursa
  Future<void> signOut();

  /// Kullanıcıyı Firestore'a kaydet
  Future<void> saveUserToFirestore(UserEntity user, {bool isUpdate = false});

  /// Email mevcut mu kontrol et
  Future<EmailCheckEntity> checkEmailMethod(String email);

  /// Kullanıcıyı Firestore'dan getir
  Future<UserEntity?> getUserDocument(String id);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final AppLogger _logger;
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseFunctions _functions;
  AuthRemoteDataSourceImpl(
    this._firebaseAuth,
    this._logger,
    this._firebaseFirestore,
    this._functions,
  );

  @override
Future<EmailCheckEntity> checkEmailMethod(String email) async {
  _logger.debug('Checking email method: $email', tag: 'AuthDataSource');
  try {
    final callable = _functions.httpsCallable('checkEmailMethod');
    final result = await callable.call({'email': email});
    final data = result.data as Map<String, dynamic>;
    
    return EmailCheckEntity(
      exists: data['exists'] as bool,
      providers: List<String>.from(data['providers'] as List),
    );
  } catch (e, stackTrace) {
    _logger.error(
      'checkEmailMethod error: $e',
      tag: 'AuthDataSource',
      error: e,
      stackTrace: stackTrace,
    );
    throw _handleException(e);
  }
}

  @override
  Future<void> saveUserToFirestore(
    UserEntity user, {
    bool isUpdate = false,
  }) async {
    _logger.debug(
      'Saving user to Firestore: ${user.id}',
      tag: 'AuthDataSource',
    );
    try {
      final userModel = UserModel.fromEntity(user);

      // Firestore'da doküman var mı kontrol et (otomatik isUpdate belirleme)
      final docRef = _firebaseFirestore.collection('users').doc(user.id);
      final docSnapshot = await docRef.get();
      final isUpdateAuto =
          docSnapshot.exists; // Doküman varsa güncelleme, yoksa yeni kayıt

      await docRef.set(
        userModel.toMap(
          isUpdate: isUpdateAuto,
        ), // Otomatik belirlenen değeri kullan
        SetOptions(merge: true),
      );

      _logger.debug(
        'User ${isUpdateAuto ? 'updated' : 'saved'} to Firestore: ${user.id}',
        tag: 'AuthDataSource',
      );
    } catch (e, stackTrace) {
      _logger.error(
        'Error saving user to Firestore: $e',
        tag: 'AuthDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      throw _handleException(e);
    }
  }

  @override
  Future<UserEntity?> getUserDocument(String id) async {
    _logger.debug('Getting user document: $id', tag: 'AuthDataSource');
    try {
      final result = await _firebaseFirestore.collection('users').doc(id).get();
      return UserModel.fromFirestore(result);
    } catch (e, stackTrace) {
      _logger.error('Error getting user document: $e', tag: 'AuthDataSource', error: e, stackTrace: stackTrace);
      throw _handleException(e);
    }
  }

  Future<UserEntity> signIn(String email, String password) async {
    _logger.debug(
      'Firebase signInWithEmailAndPassword: $email',
      tag: 'AuthDataSource',
    );
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user == null) {
        _logger.warning(
          'Firebase signIn returned null user',
          tag: 'AuthDataSource',
        );
        throw const AuthException(message: 'Giriş işlemi başarısız');
      }

      _logger.debug(
        'Firebase signIn successful: ${result.user!.uid}',
        tag: 'AuthDataSource',
      );
      return UserModel.fromFirebase(result.user!);
    } catch (e, stackTrace) {
      _logger.error(
        'Firebase signIn error: $e',
        tag: 'AuthDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      throw _handleException(e);
    }
  }

  @override
  Future<UserEntity> signUp(String email, String password, String name) async {
    _logger.debug(
      'Firebase createUserWithEmailAndPassword: $email',
      tag: 'AuthDataSource',
    );
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user == null) {
        _logger.warning(
          'Firebase signUp returned null user',
          tag: 'AuthDataSource',
        );
        throw const AuthException(message: 'Kayıt işlemi başarısız');
      }

      // İsmi Firebase Auth profile'ına kaydet
      _logger.debug('Updating displayName: $name', tag: 'AuthDataSource');
      await result.user!.updateDisplayName(name);
      await result.user!.reload();

      _logger.debug(
        'Firebase signUp successful: ${result.user!.uid}',
        tag: 'AuthDataSource',
      );
      return UserModel.fromFirebase(result.user!);
    } catch (e, stackTrace) {
      _logger.error(
        'Firebase signUp error: $e',
        tag: 'AuthDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      throw _handleException(e);
    }
  }

  @override
  Future<UserEntity?> signInWithGoogle() async {
    _logger.debug('Google Sign-In started', tag: 'AuthDataSource');
    try {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        serverClientId: EnvConfig.googleServerClientId,
      );

      // Önce silent auth dene
      GoogleSignInAccount? googleUser = await googleSignIn
          .attemptLightweightAuthentication();

      // Yoksa tam authenticate
      if (googleUser == null && googleSignIn.supportsAuthenticate()) {
        _logger.debug(
          'Attempting full Google authentication',
          tag: 'AuthDataSource',
        );
        googleUser = await googleSignIn.authenticate();
      }

      // Kullanıcı iptal etti
      if (googleUser == null) {
        _logger.warning(
          'Google Sign-In cancelled by user',
          tag: 'AuthDataSource',
        );
        return null;
      }

      // Google'dan authentication bilgilerini al
      final googleAuth = googleUser.authentication;
      if (googleAuth.idToken == null) {
        _logger.warning(
          'Google Sign-In: idToken is null',
          tag: 'AuthDataSource',
        );
        throw const AuthException(message: 'Google kimlik bilgisi alınamadı');
      }

      // Firebase'e credential oluştur
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Firebase Auth ile giriş yap
      final result = await _firebaseAuth.signInWithCredential(credential);
      if (result.user == null) {
        _logger.warning(
          'Firebase signInWithCredential returned null user',
          tag: 'AuthDataSource',
        );
        throw const AuthException(message: 'Google ile giriş başarısız');
      }

      _logger.debug(
        'Google Sign-In successful: ${result.user!.uid}',
        tag: 'AuthDataSource',
      );
      return UserModel.fromFirebase(result.user!);
    } catch (e, stackTrace) {
      // Zaten AuthException ise tekrar wrap etme
      if (e is AuthException) rethrow;

      _logger.error(
        'Google Sign-In error: $e',
        tag: 'AuthDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      throw _handleException(e);
    }
  }

  @override
  Future<UserEntity?> signInWithApple() async {
    _logger.debug('Apple Sign-In started', tag: 'AuthDataSource');
    try {
      // Apple Sign-In credential'ı al
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: Platform.isAndroid
            ? WebAuthenticationOptions(
                clientId: EnvConfig.appleClientId, // Firebase'den alacağız
                redirectUri: Uri.parse(EnvConfig.appleRedirectUri),
              )
            : null,
      );

      // OAuth credential oluştur
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Firebase'e giriş yap
      final result = await _firebaseAuth.signInWithCredential(oauthCredential);
      if (result.user == null) {
        _logger.warning(
          'Firebase signInWithCredential (Apple) returned null user',
          tag: 'AuthDataSource',
        );
        throw const AuthException(message: 'Apple ile giriş başarısız');
      }

      // Apple'dan gelen isim bilgisini kaydet (sadece ilk kayıtta gelir)
      final user = result.user!;
      if (appleCredential.givenName != null ||
          appleCredential.familyName != null) {
        final displayName =
            '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
                .trim();
        if (displayName.isNotEmpty) {
          _logger.debug(
            'Updating displayName from Apple: $displayName',
            tag: 'AuthDataSource',
          );
          await user.updateDisplayName(displayName);
          await user.reload();
        }
      }

      _logger.debug(
        'Apple Sign-In successful: ${user.uid}',
        tag: 'AuthDataSource',
      );
      return UserModel.fromFirebase(user);
    } on SignInWithAppleAuthorizationException catch (e) {
      // Kullanıcı iptal etti
      if (e.code == AuthorizationErrorCode.canceled) {
        _logger.warning(
          'Apple Sign-In cancelled by user',
          tag: 'AuthDataSource',
        );
        return null;
      }
      _logger.error(
        'Apple Sign-In authorization error: $e',
        tag: 'AuthDataSource',
      );
      throw AuthException(message: 'Apple ile giriş başarısız: ${e.message}');
    } catch (e, stackTrace) {
      // Zaten AuthException ise tekrar wrap etme
      if (e is AuthException) rethrow;

      _logger.error(
        'Apple Sign-In error: $e',
        tag: 'AuthDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      throw _handleException(e);
    }
  }

  @override
  Future<void> signOut() async {
    _logger.debug('Firebase signOut called', tag: 'AuthDataSource');
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        GoogleSignIn.instance.signOut(),
      ]);
      _logger.debug('Firebase signOut successful', tag: 'AuthDataSource');
    } catch (e, stackTrace) {
      _logger.error(
        'Firebase signOut error: $e',
        tag: 'AuthDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      throw _handleException(e);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ERROR HANDLING
  // ─────────────────────────────────────────────────────────────────────────

  /// Firebase/platform hatalarını AppException'a dönüştürür
  AppException _handleException(Object error) {
    // Zaten AppException ise aynen döndür
    if (error is AppException) return error;

    // Firebase hatalarını handle et
    return FirebaseErrorHandler.handle(error);
  }
}
