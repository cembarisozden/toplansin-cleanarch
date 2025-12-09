import 'package:flutter/material.dart';
import 'package:toplansin_cleanarch/core/config/env_config.dart';
import 'package:toplansin_cleanarch/core/router/app_router.dart';
import 'package:toplansin_cleanarch/core/theme/app_theme.dart';

/// Ana uygulama widget'ı
class ToplansinApp extends StatelessWidget {
  const ToplansinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: EnvConfig.appName,
      debugShowCheckedModeBanner: EnvConfig.isDev,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
