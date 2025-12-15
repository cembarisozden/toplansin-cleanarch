import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toplansin_cleanarch/core/router/route_names.dart';
import 'package:toplansin_cleanarch/presentation/pages/auth_test.dart';
import 'package:toplansin_cleanarch/presentation/pages/splash/splash_page.dart';

/// Ana router yapılandırması
class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/', 
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => const _PlaceholderPage(title: 'Home'),
      ),
      GoRoute(
        path: '/auth-test',
        name: 'auth-test',
        builder: (context, state) => const AuthTestPage(),
      ),
    ],
  );
}

/// Placeholder sayfa - gerçek sayfalar oluşturulunca kaldırılacak
class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
