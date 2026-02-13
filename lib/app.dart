import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toplansin_cleanarch/core/config/env_config.dart';
import 'package:toplansin_cleanarch/core/router/app_router.dart';
import 'package:toplansin_cleanarch/core/theme/app_theme.dart';
import 'package:toplansin_cleanarch/injection_container/injection_container.dart';
import 'package:toplansin_cleanarch/presentation/blocs/auth/auth_bloc.dart';
import 'package:toplansin_cleanarch/presentation/blocs/venue/venue_bloc.dart';

/// Ana uygulama widget'ı
/// 
/// Global bloc'lar burada provide edilir:
/// - AuthBloc: Kullanıcı oturum yönetimi
class ToplansinApp extends StatelessWidget {
  const ToplansinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // ─────────────────────────────────────────────────────────────
      // 🌐 GLOBAL BLOC'LAR
      // ─────────────────────────────────────────────────────────────
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl.get<AuthBloc>()),
        BlocProvider<VenueBloc>(create: (_) => sl.get<VenueBloc>()),
        // İleride eklenecek diğer global bloc'lar:
        // BlocProvider<UserBloc>(create: (_) => sl<UserBloc>()),
        // BlocProvider<ThemeBloc>(create: (_) => sl<ThemeBloc>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        splitScreenMode: false,
        builder: (context, child) => MaterialApp.router(
          title: EnvConfig.appName,
          debugShowCheckedModeBanner: EnvConfig.isDev,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
