/// Auth servisi için interface
abstract class IAuthService {
  /// Mevcut kullanıcıyı döner (null olabilir)
  User? get currentUser;
  
  /// Kullanıcı giriş yapmış mı?
  bool get isLoggedIn;
}

/// User - Firebase'den gelen tip
class User {
  final String uid;
  final String? email;

  User({required this.uid, this.email});
}
