// VenueState - cache'li yaklaşım
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:toplansin_cleanarch/domain/entities/venue_entity.dart';

part 'venue_state.freezed.dart';

@freezed
class VenueState with _$VenueState {
  const VenueState._();
  const factory VenueState({
    @Default([]) List<VenueEntity?> premiumVenues,
    @Default([]) List<VenueEntity?> recentVenues,
    @Default([]) List<VenueEntity?> savedVenues,
    @Default({}) Set<String> savedVenueIds,  // Hızlı lookup için
    @Default(0) int selectedTabIndex,
    
    @Default(false) bool isPremiumLoading,
    @Default(false) bool isRecentLoading,
    @Default(false) bool isSavedLoading,

        // Error states (opsiyonel)
    String? premiumError,
    String? recentError,
    String? savedError,
  }) = _VenueState;

   // Seçili tab'a göre aktif liste
  List<VenueEntity> get currentVenues {
    switch (selectedTabIndex) {
      case 0: return premiumVenues.whereType<VenueEntity>().toList();
      case 1: return recentVenues.whereType<VenueEntity>().toList();
      case 2: return savedVenues.whereType<VenueEntity>().toList();
      default: return [];
    }
  }

  // Seçili tab loading durumu
  bool get isCurrentLoading {
    switch (selectedTabIndex) {
      case 0: return isPremiumLoading;
      case 1: return isRecentLoading;
      case 2: return isSavedLoading;
      default: return false;
    }
  }

  // Seçili tab error
  String? get currentError {
    switch (selectedTabIndex) {
      case 0: return premiumError;
      case 1: return recentError;
      case 2: return savedError;
      default: return null;
    }
  }
}