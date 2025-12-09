import 'package:flutter/material.dart';

/// Num (int & double) extension'ları
extension NumExtensions on num {
  /// Yatay boşluk widget'ı
  SizedBox get horizontalSpace => SizedBox(width: toDouble());

  /// Dikey boşluk widget'ı
  SizedBox get verticalSpace => SizedBox(height: toDouble());

  /// Duration - milisaniye
  Duration get milliseconds => Duration(milliseconds: toInt());

  /// Duration - saniye
  Duration get seconds => Duration(seconds: toInt());

  /// Duration - dakika
  Duration get minutes => Duration(minutes: toInt());

  /// Duration - saat
  Duration get hours => Duration(hours: toInt());

  /// Duration - gün
  Duration get days => Duration(days: toInt());

  /// Radius
  Radius get radius => Radius.circular(toDouble());

  /// BorderRadius
  BorderRadius get borderRadius => BorderRadius.circular(toDouble());

  /// EdgeInsets - tüm yönler
  EdgeInsets get padding => EdgeInsets.all(toDouble());

  /// EdgeInsets - yatay
  EdgeInsets get paddingHorizontal =>
      EdgeInsets.symmetric(horizontal: toDouble());

  /// EdgeInsets - dikey
  EdgeInsets get paddingVertical => EdgeInsets.symmetric(vertical: toDouble());
}

/// Int extension'ları
extension IntExtensions on int {
  /// Sıfır mı?
  bool get isZero => this == 0;

  /// Pozitif mi?
  bool get isPositive => this > 0;

  /// Negatif mi?
  bool get isNegative => this < 0;

  /// Çift mi?
  bool get isEven => this % 2 == 0;

  /// Tek mi?
  bool get isOdd => this % 2 != 0;

  /// Belirtilen aralıkta mı?
  bool isBetween(int min, int max) => this >= min && this <= max;
}

/// Double extension'ları
extension DoubleExtensions on double {
  /// Para formatı: 1234.56 -> "1.234,56"
  String get toCurrency {
    final parts = toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
    return '$intPart,${parts[1]}';
  }

  /// TL formatı: 1234.56 -> "₺1.234,56"
  String get toTL => '₺$toCurrency';
}

