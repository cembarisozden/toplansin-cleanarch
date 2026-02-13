import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:injectable/injectable.dart';
import 'package:toplansin_cleanarch/core/services/interfaces/auth_service.dart';

@LazySingleton(as: IAuthService)
class AuthServiceImpl implements IAuthService {
  final firebase_auth.FirebaseAuth _auth;

  AuthServiceImpl(this._auth);

  @override
  User? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;
    return User(uid: user.uid, email: user.email);
  }

  @override
  bool get isLoggedIn => _auth.currentUser != null;
}
