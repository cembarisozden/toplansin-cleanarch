import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:toplansin_cleanarch/core/usecases/usecase.dart';
import 'package:toplansin_cleanarch/core/utils/logger.dart';
import 'package:toplansin_cleanarch/domain/entities/venue_entity.dart';
import 'package:toplansin_cleanarch/domain/usecases/venue/get_premium_venues_usecase.dart';
import 'package:toplansin_cleanarch/domain/usecases/venue/get_recent_venues_usecase.dart';
import 'package:toplansin_cleanarch/domain/usecases/venue/get_saved_venues_usecase.dart';
import 'package:toplansin_cleanarch/domain/usecases/venue/toggle_save_venue_usecase.dart';
import 'package:toplansin_cleanarch/presentation/blocs/venue/venue_event.dart';
import 'package:toplansin_cleanarch/presentation/blocs/venue/venue_state.dart';

@injectable
class VenueBloc extends Bloc<VenueEvent, VenueState> {
  final GetPremiumVenuesUseCase _getPremiumVenuesUseCase;
  final GetRecentVenuesUseCase _getRecentVenuesUseCase;
  final GetSavedVenuesUseCase _getSavedVenuesUseCase;
  final ToggleSaveVenueUseCase _toggleSaveVenueUseCase;
  final AppLogger _logger;

  VenueBloc(
    this._getPremiumVenuesUseCase,
    this._getRecentVenuesUseCase,
    this._getSavedVenuesUseCase,
    this._toggleSaveVenueUseCase,
    this._logger,
  ) : super(const VenueState()) {
    on<LoadPremiumVenues>(_onLoadPremiumVenues,transformer: droppable());
    on<LoadRecentVenues>(_onLoadRecentVenues,transformer: droppable());
    on<LoadSavedVenues>(_onLoadSavedVenues,transformer: droppable());
    on<ToggleSaveVenue>(_onToggleSaveVenue);
    on<SetSelectedTabIndex>(_onSetSelectedTabIndex);
  }

  // ─────────────────────────────────────────────────────────────
  // PREMIUM VENUES
  // ─────────────────────────────────────────────────────────────
  
  Future<void> _onLoadPremiumVenues(
    LoadPremiumVenues event,
    Emitter<VenueState> emit,
  ) async {
    _logger.debug('Loading premium venues', tag: 'VenueBloc');
    
    // Sadece premium loading'i true yap, diğerleri korunsun
    emit(state.copyWith(isPremiumLoading: true, premiumError: null));

    final result = await _getPremiumVenuesUseCase(const NoParams());
    
    if (isClosed) return;

    switch (result) {
      case Left(value: final failure):
        _logger.warning('Premium venues failed: ${failure.message}', tag: 'VenueBloc');
        emit(state.copyWith(
          isPremiumLoading: false,
          premiumError: failure.message,
        ));

      case Right(value: final venues):
        final nonNullVenues = venues.whereType<VenueEntity>().toList();
        _logger.info('Premium venues loaded: ${nonNullVenues.length}', tag: 'VenueBloc');
        emit(state.copyWith(
          isPremiumLoading: false,
          premiumVenues: nonNullVenues,
        ));
    }
  }

  // ─────────────────────────────────────────────────────────────
  // RECENT VENUES
  // ─────────────────────────────────────────────────────────────
  
  Future<void> _onLoadRecentVenues(
    LoadRecentVenues event,
    Emitter<VenueState> emit,
  ) async {
    _logger.debug('Loading recent venues', tag: 'VenueBloc');
    
    emit(state.copyWith(isRecentLoading: true, recentError: null));

    final result = await _getRecentVenuesUseCase(const NoParams());
    
    if (isClosed) return;

    switch (result) {
      case Left(value: final failure):
        _logger.warning('Recent venues failed: ${failure.message}', tag: 'VenueBloc');
        emit(state.copyWith(
          isRecentLoading: false,
          recentError: failure.message,
        ));

      case Right(value: final venues):
        final nonNullVenues = venues.whereType<VenueEntity>().toList();
        _logger.info('Recent venues loaded: ${nonNullVenues.length}', tag: 'VenueBloc');
        emit(state.copyWith(
          isRecentLoading: false,
          recentVenues: nonNullVenues,
        ));
    }
  }

  // ─────────────────────────────────────────────────────────────
  // SAVED VENUES
  // ─────────────────────────────────────────────────────────────
  
  Future<void> _onLoadSavedVenues(
    LoadSavedVenues event,
    Emitter<VenueState> emit,
  ) async {
    _logger.debug('Loading saved venues', tag: 'VenueBloc');
    
    emit(state.copyWith(isSavedLoading: true, savedError: null));

    final result = await _getSavedVenuesUseCase(event.userId);
    
    if (isClosed) return;

    switch (result) {
      case Left(value: final failure):
        _logger.warning('Saved venues failed: ${failure.message}', tag: 'VenueBloc');
        emit(state.copyWith(
          isSavedLoading: false,
          savedError: failure.message,
        ));

      case Right(value: final venues):
        final nonNullVenues = venues.whereType<VenueEntity>().toList();
        _logger.info('Saved venues loaded: ${nonNullVenues.length}', tag: 'VenueBloc');
        emit(state.copyWith(
          isSavedLoading: false,
          savedVenues: nonNullVenues,
          savedVenueIds: nonNullVenues.map((v) => v.id).toSet(),
        ));
    }
  }

  // ─────────────────────────────────────────────────────────────
  // TOGGLE SAVE
  // ─────────────────────────────────────────────────────────────
  
  Future<void> _onToggleSaveVenue(
    ToggleSaveVenue event,
    Emitter<VenueState> emit,
  ) async {
    final venueId = event.venueId;
    final venue = event.venue;
    final isSaved = state.savedVenueIds.contains(venueId);
    final previousSavedIds = state.savedVenueIds; // Rollback için sakla
    _logger.debug('Toggle save venue: $venueId (current: $isSaved)', tag: 'VenueBloc');

    // Optimistic update - önce UI'ı güncelle
    final newSavedIds = Set<String>.from(state.savedVenueIds);
    final newSavedVenues = List<VenueEntity>.from(state.savedVenues);
    if (isSaved) {
      newSavedIds.remove(venueId);
      newSavedVenues.removeWhere((v) => v.id == venueId);
    } else {
      newSavedIds.add(venueId);
      newSavedVenues.add(venue!);
    }
    emit(state.copyWith(savedVenueIds: newSavedIds, savedVenues: newSavedVenues));


    // API call
    final result = await _toggleSaveVenueUseCase((venueId, event.userId));
    
    if (isClosed) return;

    switch (result) {
      case Left(value: final failure):
        _logger.warning('Toggle save failed: ${failure.message}', tag: 'VenueBloc');
        // Rollback on failure
        emit(state.copyWith(savedVenueIds: previousSavedIds));

      case Right():
        _logger.info('Toggle save successful: $venueId', tag: 'VenueBloc');
    }
  }

  Future<void> _onSetSelectedTabIndex(
    SetSelectedTabIndex event,
    Emitter<VenueState> emit,
  ) async {
    emit(state.copyWith(selectedTabIndex: event.index));
  }
}