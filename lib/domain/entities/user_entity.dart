// lib/domain/entities/user_entity.dart
class UserEntity {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLoginAt;
  final bool isEmailVerified;
  final bool isGoogle;
  final bool isApple;



  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
    this.isEmailVerified = false,
    this.isGoogle = false,
    this.isApple = false,
  });
}