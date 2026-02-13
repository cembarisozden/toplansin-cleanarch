import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toplansin_cleanarch/core/extensions/context_extensions.dart';
import 'package:toplansin_cleanarch/core/theme/app_colors.dart';
import 'package:toplansin_cleanarch/core/theme/app_dimensions.dart';
import 'package:toplansin_cleanarch/domain/entities/venue_entity.dart';
import 'package:toplansin_cleanarch/presentation/blocs/auth/auth_bloc.dart';
import 'package:toplansin_cleanarch/presentation/blocs/auth/auth_state.dart';
import 'package:toplansin_cleanarch/presentation/blocs/venue/venue_bloc.dart';
import 'package:toplansin_cleanarch/presentation/blocs/venue/venue_event.dart';
import 'package:toplansin_cleanarch/presentation/blocs/venue/venue_state.dart';
import 'package:toplansin_cleanarch/presentation/pages/home/widgets/gradient_tab_button.dart';
import 'package:toplansin_cleanarch/presentation/pages/home/widgets/venue_card.dart';

class HomeVenueListSection extends StatefulWidget {
  const HomeVenueListSection({super.key});

  @override
  State<HomeVenueListSection> createState() => _HomeVenueListSectionState();
}

class _HomeVenueListSectionState extends State<HomeVenueListSection> {
  final ScrollController _scrollController = ScrollController();
  bool _canScrollLeft = false;
  bool _canScrollRight = true;

  @override
  void initState() {
    super.initState();
    context.read<VenueBloc>().add(const VenueEvent.loadPremiumVenues());
    _scrollController.addListener(_updateScrollArrows);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onTabChanged(BuildContext context, int index) {
    final venueBloc = context.read<VenueBloc>();
    final state = venueBloc.state;

    venueBloc.add(VenueEvent.setSelectedTabIndex(index: index));

    switch (index) {
      case 0:
        if (state.premiumVenues.isEmpty && !state.isPremiumLoading) {
          venueBloc.add(const VenueEvent.loadPremiumVenues());
        }
      case 1:
        if (state.recentVenues.isEmpty && !state.isRecentLoading) {
          venueBloc.add(const VenueEvent.loadRecentVenues());
        }
      case 2:
        final authState = context.read<AuthBloc>().state;
        if (authState is AuthAuthenticated) {
          final userId = authState.user.id;
          if (state.savedVenues.isEmpty && !state.isSavedLoading) {
            venueBloc.add(VenueEvent.loadSavedVenues(userId));
          }
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTabButtons(),
        AppDimensions.spacing8.verticalSpace,
        BlocSelector<VenueBloc, VenueState, List<VenueEntity>>(
          selector: (state) => state.currentVenues,
          builder: (context, currentVenues) => _buildScrollArrows(currentVenues.length),
        ),
        AppDimensions.spacing8.verticalSpace,
        _buildVenueContent(),
      ],
    );
  }

  Widget _buildTabButtons() {
    return BlocBuilder<VenueBloc, VenueState>(
      buildWhen: (prev, curr) => prev.selectedTabIndex != curr.selectedTabIndex,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientTabButton(
              label: 'En Popüler',
              isSelected: state.selectedTabIndex == 0,
              onTap: () => _onTabChanged(context, 0),
            ),
            SizedBox(width: 8.w),
            GradientTabButton(
              label: 'En Yeniler',
              isSelected: state.selectedTabIndex == 1,
              onTap: () => _onTabChanged(context, 1),
            ),
            SizedBox(width: 8.w),
            GradientTabButton(
              label: 'Kaydedilenler',
              isSelected: state.selectedTabIndex == 2,
              onTap: () => _onTabChanged(context, 2),
            ),
          ],
        );
      },
    );
  }

Widget _buildVenueContent() {
  return BlocBuilder<VenueBloc, VenueState>(
    buildWhen: (prev, curr) =>
        prev.currentVenues != curr.currentVenues ||
        prev.isCurrentLoading != curr.isCurrentLoading ||
        prev.currentError != curr.currentError,
    builder: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final userId = authState is AuthAuthenticated ? authState.user.id : '';

      if (state.isCurrentLoading && state.currentVenues.isEmpty) {
        return _buildLoading();
      }
      if (state.currentError != null) {
        return _buildError(context, state.currentError!);
      }
      if (state.currentVenues.isEmpty) {
        return _buildEmpty(context);
      }
      return _buildVenueList(
        state.currentVenues,
        state.savedVenueIds,
        userId,
        _onSaveTap,
      );
    },
  );
}

  void _onSaveTap(String venueId, String userId, VenueEntity? venue) {
    context.read<VenueBloc>().add(VenueEvent.toggleSave(venueId: venueId, userId: userId, venue: venue));
  }

  Widget _buildLoading() {
    return SizedBox(
      height: 150.h,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.grey600,
        ),
      ),
    );
  }

  void _updateScrollArrows() {
    final position = _scrollController.position;
    final min=position.minScrollExtent;
    final max=position.maxScrollExtent;
    final offset=position.pixels;
    setState(() {
      _canScrollLeft = offset > min;
      _canScrollRight = offset < max;
    });
  }

  Widget _buildError(BuildContext context, String message) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
            size: 48.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
         AppDimensions.spacing32.verticalSpace,
          Icon(
            Icons.location_off_outlined,
            color: AppColors.grey400,
            size: 48.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            'Henüz mekan yok',
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollArrows(int venueLength) {
    
    if (venueLength <= 1) {
      return SizedBox.shrink();
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Row(
              children: [
                Icon(Icons.arrow_left_outlined, color: _canScrollLeft ? context.colorScheme.onSurface : AppColors.grey400),
                SizedBox(width: 0.w),
                Icon(Icons.arrow_right_outlined, color: _canScrollRight ? context.colorScheme.onSurface : AppColors.grey400),
              ],
            ),
          ),
        ],
      );
  }
  

  Widget _buildVenueList(List<VenueEntity> venues, Set<String> savedVenueIds, String userId, Function(String venueId, String userId, VenueEntity? venue) onSaveTap) {
    return SizedBox(
      height: 0.27.sh,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: venues.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) => VenueCard(venue: venues[index], isSaved: savedVenueIds.contains(venues[index].id), userId: userId, onSaveTap: onSaveTap),
      ),
    );
  }
}
