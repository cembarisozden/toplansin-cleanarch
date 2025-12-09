/// String extension'ları
extension StringExtensions on String {
  /// İlk harfi büyük yapar
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Her kelimenin ilk harfini büyük yapar
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Geçerli email mi kontrol eder
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Geçerli telefon numarası mı kontrol eder (Türkiye formatı)
  bool get isValidPhoneNumber {
    final phoneRegex = RegExp(r'^(\+90|0)?[0-9]{10}$');
    return phoneRegex.hasMatch(replaceAll(' ', '').replaceAll('-', ''));
  }

  /// Null veya boş mu kontrol eder
  bool get isNullOrEmpty => isEmpty;

  /// Null veya boş değil mi kontrol eder
  bool get isNotNullOrEmpty => isNotEmpty;

  /// String'i int'e çevirir, başarısız olursa null döner
  int? toIntOrNull() => int.tryParse(this);

  /// String'i double'a çevirir, başarısız olursa null döner
  double? toDoubleOrNull() => double.tryParse(this);
}

/// Nullable String extension'ları
extension NullableStringExtensions on String? {
  /// Null veya boş mu kontrol eder
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Null veya boş değil mi kontrol eder
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  /// Null ise default değer döner
  String orEmpty() => this ?? '';
}

