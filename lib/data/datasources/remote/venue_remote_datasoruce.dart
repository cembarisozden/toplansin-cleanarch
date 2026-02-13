import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:toplansin_cleanarch/core/errors/firebase_error_handler.dart';
import 'package:toplansin_cleanarch/core/utils/logger.dart';
import 'package:toplansin_cleanarch/data/models/venue_model.dart';
import 'package:toplansin_cleanarch/domain/entities/venue_entity.dart';

abstract class VenueRemoteDataSource {
  Future<List<VenueEntity?>> getPremiumVenues();
  Future<List<VenueEntity?>> getRecentVenues();
  Future<List<VenueEntity?>> getSavedVenues(String userId);
  Future<VenueEntity?> getVenueById(String venueId);
  Future<void> toggleSaveVenue(String venueId, String userId);
}
@LazySingleton(as: VenueRemoteDataSource)
class VenueRemoteDataSourceImpl implements VenueRemoteDataSource {
  final FirebaseFirestore _firebaseFirestore;
  final AppLogger _logger;
  VenueRemoteDataSourceImpl(this._firebaseFirestore, this._logger);

  @override
  Future<List<VenueEntity?>> getPremiumVenues() async {
    _logger.debug('Getting premium venues', tag: 'VenueRemoteDataSource');
    try {
      final result = await _firebaseFirestore.collection('hali_sahalar').where('isPremium', isEqualTo: true).get();
      return result.docs.map((doc) => VenueModel.fromFirestore(doc)).toList();
    } catch (e,stackTrace) {
      _logger.error('Error getting premium venues: $e', tag: 'VenueRemoteDataSource',error: e,stackTrace: stackTrace);
      throw FirebaseErrorHandler.handle(e);
    }
  }

  @override
  Future<List<VenueEntity?>> getRecentVenues() async {
    _logger.debug('Getting recent venues', tag: 'VenueRemoteDataSource');
    try {
      final result = await _firebaseFirestore.collection('hali_sahalar').orderBy('createdAt', descending: true).get();
      return result.docs.map((doc) => VenueModel.fromFirestore(doc)).toList();
    } catch (e,stackTrace) {
      _logger.error('Error getting recent venues: $e', tag: 'VenueRemoteDataSource',error: e,stackTrace: stackTrace);
      throw FirebaseErrorHandler.handle(e);
    }
  }

@override
Future<List<VenueEntity?>> getSavedVenues(String userId) async {
  _logger.debug('Getting saved venues for user: $userId', tag: 'VenueRemoteDataSource');
  try {
    final favoritesSnapshot = await _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();

    if (favoritesSnapshot.docs.isEmpty) return [];

    final venueIds = favoritesSnapshot.docs.map((doc) => doc.id).toList();
    final venues = <VenueEntity?>[];

    for (final venueId in venueIds) {
      final venue = await getVenueById(venueId);
      venues.add(venue);
    }

    return venues;
  } catch (e, stackTrace) {
    _logger.error(
      'Error getting saved venues: $e for user: $userId',
      tag: 'VenueRemoteDataSource',
      error: e,
      stackTrace: stackTrace,
    );
    throw FirebaseErrorHandler.handle(e);
  }
}

  @override
  Future<VenueEntity?> getVenueById(String venueId) async {
    _logger.debug('Getting venue by id: $venueId', tag: 'VenueRemoteDataSource');
    try {
      final result = await _firebaseFirestore.collection('hali_sahalar').doc(venueId).get();
      return VenueModel.fromFirestore(result);
    } catch (e,stackTrace) {
      _logger.error('Error getting venue by id: $e', tag: 'VenueRemoteDataSource',error: e,stackTrace: stackTrace);
      throw FirebaseErrorHandler.handle(e);
    }
  }

 @override
Future<void> toggleSaveVenue(String venueId, String userId) async {
  _logger.debug('Toggling save venue: $venueId for user: $userId', tag: 'VenueRemoteDataSource');
  try {
    final docRef = _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(venueId);

    final snapshot = await docRef.get();

    if (snapshot.exists) {
      await docRef.delete();
      _logger.debug('Removed venue from favorites: $venueId', tag: 'VenueRemoteDataSource');
    } else {
      await docRef.set({
        'venueId': venueId,
        'createdAt': DateTime.now(),
      });
      _logger.debug('Saved venue to favorites: $venueId', tag: 'VenueRemoteDataSource');
    }
  } catch (e, stackTrace) {
    _logger.error(
      'Error toggling save venue: $e for user: $userId',
      tag: 'VenueRemoteDataSource',
      error: e,
      stackTrace: stackTrace,
    );
    throw FirebaseErrorHandler.handle(e);
  }
}
}