import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:toplansin_cleanarch/core/constants/onboarding_content.dart';
import 'package:toplansin_cleanarch/core/extensions/context_extensions.dart';
import 'package:toplansin_cleanarch/core/theme/app_colors.dart';
import 'package:toplansin_cleanarch/core/theme/app_dimensions.dart';
import 'package:toplansin_cleanarch/core/utils/logger.dart';
import 'package:toplansin_cleanarch/injection_container/injection_container.dart';
import 'package:toplansin_cleanarch/presentation/pages/onboarding/widgets/onboarding_item.dart';
import 'package:toplansin_cleanarch/presentation/pages/onboarding/widgets/page_indicator.dart';
import 'package:toplansin_cleanarch/presentation/widgets/primary_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  final _logger = sl<AppLogger>();
  int _currentPage = 0;
  bool _imagesLoaded = false;
  bool _precacheCalled = false;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  
   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_precacheCalled) {
      _precacheCalled = true;
      _precacheImages();
    }
  }

  Future<void> _precacheImages() async {
    // Tüm onboarding görsellerini önceden yükle
    await Future.wait(
      onboardingItems.map(
        (item) => precacheImage(AssetImage(item.imagePath), context),
      ),
    );
    if (mounted) {
      setState(() => _imagesLoaded = true);
    }
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _logger.debug('Onboarding sayfa: $index', tag: 'Onboarding');
  }

  void _nextPage() {
    if (_currentPage < onboardingItems.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    _logger.info('Onboarding tamamlandı', tag: 'Onboarding');

    context.goNamed('login');
  }

  @override
  Widget build(BuildContext context) {
    if (!_imagesLoaded) {
      return Scaffold(
        backgroundColor: AppColors.black,  // Koyu arka plan
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.white),
        ),
      );
    }
    final isLastPage = _currentPage == onboardingItems.length - 1;
    return Scaffold(
      body: Stack(
        children: [
          // 1. Tam ekran PageView (arka planda)
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: onboardingItems.length,
            itemBuilder: (context, index) {
              return OnboardingItem(content: onboardingItems[index]);
            },
          ),

          // 2. Üst bar - Logo + Geç butonu
          Positioned(
            top: context.mediaQuery.padding.top + 16.h,
            left: 16.w,
            right: 16.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sol boşluk (Geç butonu kadar)
                AppDimensions.spacing56.horizontalSpace,
             

                // Sağda Geç butonu
                // Geç butonu yerine:
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.white.withOpacity(0.4),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                  ),
                  child: TextButton(
                    onPressed: _completeOnboarding,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 4.h,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Geç',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Altta Indicator + Button
          Positioned(
            left: 0,
            right: 0,
            bottom: context.mediaQuery.padding.bottom + 24.h,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing24.w,
              ),
              child: Column(
                children: [
                  PageIndicator(
                    count: onboardingItems.length,
                    currentIndex: _currentPage,
                  ),
                  AppDimensions.spacing24.verticalSpace,
                  PrimaryButton(
                    label: isLastPage ? 'Başla' : 'İleri',
                    onPressed: _nextPage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
