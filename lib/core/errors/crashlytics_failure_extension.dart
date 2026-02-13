import 'package:toplansin_cleanarch/core/errors/failures.dart';
import 'package:toplansin_cleanarch/core/services/interfaces/crashlytics_service.dart';

/// Failure'ları Crashlytics'e göndermek için extension
/// Manuel olarak çağrılır: failure.reportToCrashlytics(crashlytics)
extension CrashlyticsFailureExtension on Failure {
  /// Failure'ı Crashlytics'e non-fatal error olarak gönderir
  /// 
  /// Kullanım:
  /// ```dart
  /// final result = await useCase();
  /// result.fold(
  ///   (failure) => failure.reportToCrashlytics(crashlytics),
  ///   (success) => ...,
  /// );
  /// ```
  Future<void> reportToCrashlytics(ICrashlyticsService crashlytics) async {
    // Failure tipine göre custom key'ler ekle
    await crashlytics.setCustomKey('failure_type', runtimeType.toString());
    if (code != null) {
      await crashlytics.setCustomKey('failure_code', code);
    }
    
    // AuthFailure için errorType ekle
    if (this is AuthFailure) {
      await crashlytics.setCustomKey(
        'auth_error_type', 
        (this as AuthFailure).errorType.name,
      );
    }

    // Non-fatal error olarak kaydet
    await crashlytics.recordError(
      Exception(message),
      StackTrace.current,
      reason: 'Failure: ${runtimeType.toString()}',
      fatal: false,
    );
  }
}
