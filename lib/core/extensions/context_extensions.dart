import 'package:flutter/material.dart';

/// BuildContext extension'ları
extension ContextExtensions on BuildContext {
  // ---------------------------------------------------------------------------
  // THEME
  // ---------------------------------------------------------------------------

  /// ThemeData
  ThemeData get theme => Theme.of(this);

  /// TextTheme
  TextTheme get textTheme => theme.textTheme;

  /// ColorScheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Primary color
  Color get primaryColor => colorScheme.primary;

  /// Background color
  Color get backgroundColor => colorScheme.surface;

  /// Is dark mode
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // ---------------------------------------------------------------------------
  // MEDIA QUERY
  // ---------------------------------------------------------------------------

  /// MediaQueryData
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Ekran boyutu
  Size get screenSize => mediaQuery.size;

  /// Ekran genişliği
  double get screenWidth => screenSize.width;

  /// Ekran yüksekliği
  double get screenHeight => screenSize.height;

  /// Status bar yüksekliği
  double get statusBarHeight => mediaQuery.padding.top;

  /// Bottom padding (iPhone notch vs.)
  double get bottomPadding => mediaQuery.padding.bottom;

  /// Keyboard açık mı?
  bool get isKeyboardOpen => mediaQuery.viewInsets.bottom > 0;

  /// Keyboard yüksekliği
  double get keyboardHeight => mediaQuery.viewInsets.bottom;

  // ---------------------------------------------------------------------------
  // NAVIGATION
  // ---------------------------------------------------------------------------

  /// Navigator state
  NavigatorState get navigator => Navigator.of(this);

  /// Geri git
  void pop<T>([T? result]) => navigator.pop(result);

  /// Geri gidebilir mi?
  bool get canPop => navigator.canPop();

  // ---------------------------------------------------------------------------
  // SNACKBAR & DIALOGS
  // ---------------------------------------------------------------------------

  /// SnackBar göster
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message), duration: duration, action: action),
    );
  }

  /// Error SnackBar göster
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Success SnackBar göster
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Focus'u kaldır (keyboard kapat)
  void unfocus() => FocusScope.of(this).unfocus();
}

