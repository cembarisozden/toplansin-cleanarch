import 'package:intl/intl.dart';

/// DateTime extension'ları
extension DateTimeExtensions on DateTime {
  /// Tarih formatı: 01.01.2024
  String get toDateString => DateFormat('dd.MM.yyyy').format(this);

  /// Saat formatı: 14:30
  String get toTimeString => DateFormat('HH:mm').format(this);

  /// Tam tarih saat: 01.01.2024 14:30
  String get toDateTimeString => DateFormat('dd.MM.yyyy HH:mm').format(this);

  /// Gün adı: Pazartesi
  String get dayName => DateFormat('EEEE', 'tr_TR').format(this);

  /// Kısa gün adı: Pzt
  String get shortDayName => DateFormat('E', 'tr_TR').format(this);

  /// Ay adı: Ocak
  String get monthName => DateFormat('MMMM', 'tr_TR').format(this);

  /// Kısa ay adı: Oca
  String get shortMonthName => DateFormat('MMM', 'tr_TR').format(this);

  /// Bugün mü?
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Yarın mı?
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Dün mü?
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Bu hafta içinde mi?
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Sadece tarih kısmını al (saat 00:00:00)
  DateTime get dateOnly => DateTime(year, month, day);

  /// İki tarih arasındaki gün farkı
  int daysDifference(DateTime other) {
    return dateOnly.difference(other.dateOnly).inDays.abs();
  }

  /// Göreceli zaman: "2 saat önce", "3 gün önce"
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} yıl önce';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} ay önce';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Az önce';
    }
  }
}

