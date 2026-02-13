import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toplansin_cleanarch/core/constants/mock_venues.dart';
import 'package:toplansin_cleanarch/data/models/venue_model.dart';

/// Mock venue'leri Firestore `hali_sahalar` collection'ına yazar.
/// Bir kez çalıştırman yeterli (örn. main'de SEED_VENUES=true ile).
Future<void> seedFirestoreVenues(FirebaseFirestore firestore) async {
  const collectionId = 'hali_sahalar';
  for (final venue in MockVenues.list) {
    final model = VenueModel.fromEntity(venue);
    await firestore.collection(collectionId).doc(venue.id).set(model.toMap());
  }
}
