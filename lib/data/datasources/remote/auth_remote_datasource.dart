import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:toplansin_cleanarch/domain/entities/user_entity.dart';
import 'package:toplansin_cleanarch/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserEntity?> signIn(String email, String password);
  Future<UserEntity?> signUp(String email, String password);
  Future<void> signOut();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth; // ← DI'dan otomatik gelir

  AuthRemoteDataSourceImpl(this._firebaseAuth);

  @override
  Future<UserEntity?> signIn(String email, String password) async {
    final result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (result.user == null) return null;
    return UserModel.fromFirebase(result.user!); // ← Model kullan
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();

  @override
  Future<UserEntity?> signUp(String email, String password) async {
    final result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (result.user == null) return null;
    return UserModel.fromFirebase(result.user!);
  }
}
