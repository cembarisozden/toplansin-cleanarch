import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:toplansin_cleanarch/domain/entities/venue_entity.dart';

part 'venue_event.freezed.dart';

@freezed
class VenueEvent with _$VenueEvent {
  const factory VenueEvent.loadPremiumVenues() = LoadPremiumVenues;
  const factory VenueEvent.loadRecentVenues() = LoadRecentVenues;
  const factory VenueEvent.loadSavedVenues(String userId) = LoadSavedVenues;
  const factory VenueEvent.toggleSave({
    required String venueId,
    required String userId,
    required VenueEntity? venue,
  }) = ToggleSaveVenue;
  const factory VenueEvent.setSelectedTabIndex({required int index}) = SetSelectedTabIndex;
}