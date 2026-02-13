// domain/entities/email_check_entity.dart
//
// 📌 EmailCheckEntity - Email kontrol sonucu
//
// Cloud Functions'dan dönen email kontrol sonucunu temsil eder.
// Equatable ile test edilebilir hale getirilmiştir.

import 'package:equatable/equatable.dart';

class EmailCheckEntity extends Equatable {
  final bool exists;
  final List<String> providers; // ['google.com', 'password'] vb.

  const EmailCheckEntity({
    required this.exists,
    required this.providers,
  });

  @override
  List<Object?> get props => [exists, providers];
}