import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:toplansin_cleanarch/core/router/route_names.dart';
import 'package:toplansin_cleanarch/core/services/splash_init_services.dart';
import 'package:toplansin_cleanarch/core/theme/theme.dart';
import 'package:toplansin_cleanarch/injection_container/injection_container.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late SplashInitService _initService;
  bool _servicesReady = false;

  @override
  void initState() {
    super.initState();
    _initService = sl<SplashInitService>();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500), // Toplam süre
    );

    _startAll();
  }

  Future<void> _startAll() async {
    // Servisleri arka planda başlat
    _loadServices();

    // %80'e kadar normal hızda dol
    await _controller.animateTo(
      0.80,
      duration: const Duration(milliseconds: 2000),
      curve: Curves.easeOut,
    );

    // Servisler hazır mı?
    if (_servicesReady) {
      // Hazırsa hızlıca bitir
      await _controller.animateTo(1.0, duration: const Duration(milliseconds: 300));
      _navigateNext();
    } else {
      // Hazır değilse yavaşça %95'e git
      await _controller.animateTo(
        0.95,
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeOutCubic,
      );

      // Hala bekliyoruz
      await _waitForServices();

      // Artık hazır, tamamla
      await _controller.animateTo(1.0, duration: const Duration(milliseconds: 200));
      _navigateNext();
    }
  }

  Future<void> _loadServices() async {
    await for (final _ in _initService.initialize()) {}
    _servicesReady = true;
  }

  Future<void> _waitForServices() async {
    while (!_servicesReady) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  void _navigateNext() {
    if (_initService.isLoggedIn) {
      context.goNamed(RouteNames.home);
    } else {
      context.goNamed('auth-test');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          // Logo - tam ortada
          Center(
            child: Image.asset(
              'assets/images/logo2.png',
              width: 380.w,
              fit: BoxFit.contain,
            ),
          ),
          // Progress Bar - altta
          Positioned(
            left: 90.w,
            right: 90.w,
            bottom: 90.h,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: _controller.value,
                    minHeight: 8.h,
                    backgroundColor: AppColors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
