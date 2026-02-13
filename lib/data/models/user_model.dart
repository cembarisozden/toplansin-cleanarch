// lib/data/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoUrl,
    super.phoneNumber,
    super.createdAt,
    super.updatedAt,
    super.lastLoginAt,
    super.isEmailVerified,
    super.isGoogle,
    super.isApple,
  });

  Map<String, dynamic> toMap({bool isUpdate = false}) {
  final map = <String, dynamic>{
    'id': id,
    'email': email,
    'displayName': displayName ?? '',
    'photoUrl': photoUrl ?? '',
    'phoneNumber': phoneNumber ?? '',
    'updatedAt': FieldValue.serverTimestamp(),
    'lastLoginAt': FieldValue.serverTimestamp(),
    'isEmailVerified': isEmailVerified,
    'isGoogle': isGoogle,
    'isApple': isApple,
  };
  
  // Sadece yeni kayıtta createdAt ekle
  if (!isUpdate) {
    map['createdAt'] = FieldValue.serverTimestamp();
  }
  
  return map;
}
// Firebase Auth User → UserModel (auth işlemleri için)
factory UserModel.fromFirebase(firebase.User user) {
  return UserModel(
    id: user.uid,
    email: user.email ?? '',
    displayName: user.displayName,
    photoUrl: user.photoURL,
    phoneNumber: user.phoneNumber,
    createdAt: user.metadata.creationTime,
    updatedAt: null,
    lastLoginAt: user.metadata.lastSignInTime,
    isEmailVerified: user.emailVerified,
    isGoogle: user.providerData.any((provider) => provider.providerId == 'google.com'),
    isApple: user.providerData.any((provider) => provider.providerId == 'apple.com'),
  );
}

// Firestore Document → UserModel (Firestore'dan okuma için)
factory UserModel.fromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  Timestamp? createdAtTimestamp = data['createdAt'] as Timestamp?;
  Timestamp? updatedAtTimestamp = data['updatedAt'] as Timestamp?;
  Timestamp? lastLoginAtTimestamp = data['lastLoginAt'] as Timestamp?;

  return UserModel(
    id: data['id'] ?? doc.id,
    email: data['email'] ?? '',
    displayName: data['displayName'],
    photoUrl: data['photoUrl'],
    phoneNumber: data['phoneNumber'],
    createdAt: createdAtTimestamp?.toDate(),
    updatedAt: updatedAtTimestamp?.toDate(),
    lastLoginAt: lastLoginAtTimestamp?.toDate(),
    isEmailVerified: data['isEmailVerified'] ?? false,
    isGoogle: data['isGoogle'] ?? false,
    isApple: data['isApple'] ?? false,
  );
}

// UserEntity → UserModel (entity'den model'e dönüşüm)
factory UserModel.fromEntity(UserEntity entity) {
  return UserModel(
    id: entity.id,
    email: entity.email,
    displayName: entity.displayName,
    photoUrl: entity.photoUrl,
    phoneNumber: entity.phoneNumber,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
    lastLoginAt: entity.lastLoginAt,
    isEmailVerified: entity.isEmailVerified,
    isGoogle: entity.isGoogle,
    isApple: entity.isApple,
  );
}
}