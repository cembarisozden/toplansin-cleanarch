import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toplansin_cleanarch/core/router/crashlytics_route_observer.dart';
import 'package:toplansin_cleanarch/core/router/route_names.dart';
import 'package:toplansin_cleanarch/injection_container/injection_container.dart';
import 'package:toplansin_cleanarch/presentation/layout/main_shell_page.dart';
import 'package:toplansin_cleanarch/presentation/pages/auth/continue_sign_up_page.dart';
import 'package:toplansin_cleanarch/presentation/pages/auth/login_page.dart';
import 'package:toplansin_cleanarch/presentation/pages/home/home_page.dart';
import 'package:toplansin_cleanarch/presentation/pages/onboarding/onboarding_page.dart';
import 'package:toplansin_cleanarch/presentation/pages/splash/splash_page.dart';

/// Ana router yapılandırması
class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  /// Crashlytics route observer - sayfa geçişlerini takip eder
  static CrashlyticsRouteObserver get _crashlyticsObserver =>
      sl<CrashlyticsRouteObserver>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    observers: [_crashlyticsObserver],
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: RoutePaths.continueSignUp,
        name: RouteNames.continueSignUp,
        builder: (context, state) => const ContinueSignUpPage(),
      ),
      // Bottom nav bar'lı alan: /main altındaki tüm sayfalar shell içinde
      ShellRoute(
        builder: (context, state, child) => MainShellPage(
          currentPath: state.uri.path,
          child: child,
        ),
        routes: [
          GoRoute(
            path: RoutePaths.mainShell,
            redirect: (context, state) =>
                state.uri.path == '/main' ? RoutePaths.home : null,
            routes: [
              GoRoute(
                path: RoutePaths.home,
                name: RouteNames.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

