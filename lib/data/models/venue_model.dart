// lib/data/models/venue_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/venue_entity.dart';

class VenueModel extends VenueEntity {
  const VenueModel({
    // 📋 TEMEL BİLGİLER
    required super.id,
    required super.ownerId,
    required super.name,
    required super.location,
    required super.price,
    required super.rating,
    required super.imagesUrl,
    required super.bookedSlots,
    required super.startHour,
    required super.endHour,
    // 📅 TARİH BİLGİLERİ
    super.createdAt,
    super.updatedAt,
    // 🏷️ DURUM BİLGİLERİ
    super.isPremium,
    super.isActive,
    super.viewCount,
    super.totalReviews,
    // 🎯 ÖZELLİKLER (Amenities)
    required super.hasParking,
    required super.hasShowers,
    required super.hasShoeRental,
    required super.hasCafeteria,
    required super.hasNightLighting,
    required super.hasMaleToilet,
    required super.hasFemaleToilet,
    required super.hasFoodService,
    required super.acceptsCreditCard,
    required super.hasFoosball,
    required super.hasCameras,
    required super.hasGoalkeeper,
    required super.hasPlayground,
    required super.hasPrayerRoom,
    required super.hasInternet,
    // 📝 EK BİLGİLER
    required super.description,
    required super.size,
    required super.surface,
    required super.maxPlayers,
    required super.phone,
    required super.latitude,
    required super.longitude,
  });

  // ─────────────────────────────────────────────────────────────
  // 🔄 Firestore Document → VenueModel
  // ─────────────────────────────────────────────────────────────
  factory VenueModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    // Timestamp → DateTime dönüşümü
    final createdAtTimestamp = data['createdAt'] as Timestamp?;
    final updatedAtTimestamp = data['updatedAt'] as Timestamp?;

    return VenueModel(
      // 📋 TEMEL BİLGİLER
      id: data['id'] ?? doc.id,
      ownerId: data['ownerId'] ?? '',
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      price: data['price'] ?? 0,
      rating: data['rating'] ?? 0.0,
      imagesUrl: List<String>.from(data['imagesUrl'] ?? []),
      bookedSlots: List<String>.from(data['bookedSlots'] ?? []),
      startHour: data['startHour'] ?? '',
      endHour: data['endHour'] ?? '',
      // 📅 TARİH BİLGİLERİ
      createdAt: createdAtTimestamp?.toDate(),
      updatedAt: updatedAtTimestamp?.toDate(),
      // 🏷️ DURUM BİLGİLERİ
      isPremium: data['isPremium'] ?? false,
      isActive: data['isActive'] ?? true,
      viewCount: data['viewCount'] ?? 0,
      totalReviews: data['totalReviews'] ?? 0,
      // 🎯 ÖZELLİKLER (Amenities)
      hasParking: data['hasParking'] ?? false,
      hasShowers: data['hasShowers'] ?? false,
      hasShoeRental: data['hasShoeRental'] ?? false,
      hasCafeteria: data['hasCafeteria'] ?? false,
      hasNightLighting: data['hasNightLighting'] ?? false,
      hasMaleToilet: data['hasMaleToilet'] ?? false,
      hasFemaleToilet: data['hasFemaleToilet'] ?? false,
      hasFoodService: data['hasFoodService'] ?? false,
      acceptsCreditCard: data['acceptsCreditCard'] ?? false,
      hasFoosball: data['hasFoosball'] ?? false,
      hasCameras: data['hasCameras'] ?? false,
      hasGoalkeeper: data['hasGoalkeeper'] ?? false,
      hasPlayground: data['hasPlayground'] ?? false,
      hasPrayerRoom: data['hasPrayerRoom'] ?? false,
      hasInternet: data['hasInternet'] ?? false,
      // 📝 EK BİLGİLER
      description: data['description'] ?? '',
      size: data['size'] ?? '',
      surface: data['surface'] ?? '',
      maxPlayers: data['maxPlayers'] ?? 0,
      phone: data['phone'] ?? '',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 🔄 VenueModel → Map (Firestore'a yazma için)
  // ─────────────────────────────────────────────────────────────
  Map<String, dynamic> toMap({bool isUpdate = false}) {
    final map = <String, dynamic>{
      // 📋 TEMEL BİLGİLER
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'location': location,
      'price': price,
      'rating': rating,
      'imagesUrl': imagesUrl,
      'bookedSlots': bookedSlots,
      'startHour': startHour,
      'endHour': endHour,
      // 📅 TARİH BİLGİLERİ
      'updatedAt': FieldValue.serverTimestamp(),
      // 🏷️ DURUM BİLGİLERİ
      'isPremium': isPremium,
      'isActive': isActive,
      'viewCount': viewCount,
      'totalReviews': totalReviews,
      // 🎯 ÖZELLİKLER (Amenities)
      'hasParking': hasParking,
      'hasShowers': hasShowers,
      'hasShoeRental': hasShoeRental,
      'hasCafeteria': hasCafeteria,
      'hasNightLighting': hasNightLighting,
      'hasMaleToilet': hasMaleToilet,
      'hasFemaleToilet': hasFemaleToilet,
      'hasFoodService': hasFoodService,
      'acceptsCreditCard': acceptsCreditCard,
      'hasFoosball': hasFoosball,
      'hasCameras': hasCameras,
      'hasGoalkeeper': hasGoalkeeper,
      'hasPlayground': hasPlayground,
      'hasPrayerRoom': hasPrayerRoom,
      'hasInternet': hasInternet,
      // 📝 EK BİLGİLER
      'description': description,
      'size': size,
      'surface': surface,
      'maxPlayers': maxPlayers,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
    };

    // Sadece yeni kayıtta createdAt ekle
    if (!isUpdate) {
      map['createdAt'] = FieldValue.serverTimestamp();
    }

    return map;
  }

  // ─────────────────────────────────────────────────────────────
  // 🔄 VenueEntity → VenueModel
  // ─────────────────────────────────────────────────────────────
  factory VenueModel.fromEntity(VenueEntity entity) {
    return VenueModel(
      id: entity.id,
      ownerId: entity.ownerId,
      name: entity.name,
      location: entity.location,
      price: entity.price,
      rating: entity.rating,
      imagesUrl: entity.imagesUrl,
      bookedSlots: entity.bookedSlots,
      startHour: entity.startHour,
      endHour: entity.endHour,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isPremium: entity.isPremium,
      isActive: entity.isActive,
      viewCount: entity.viewCount,
      totalReviews: entity.totalReviews,
      hasParking: entity.hasParking,
      hasShowers: entity.hasShowers,
      hasShoeRental: entity.hasShoeRental,
      hasCafeteria: entity.hasCafeteria,
      hasNightLighting: entity.hasNightLighting,
      hasMaleToilet: entity.hasMaleToilet,
      hasFemaleToilet: entity.hasFemaleToilet,
      hasFoodService: entity.hasFoodService,
      acceptsCreditCard: entity.acceptsCreditCard,
      hasFoosball: entity.hasFoosball,
      hasCameras: entity.hasCameras,
      hasGoalkeeper: entity.hasGoalkeeper,
      hasPlayground: entity.hasPlayground,
      hasPrayerRoom: entity.hasPrayerRoom,
      hasInternet: entity.hasInternet,
      description: entity.description,
      size: entity.size,
      surface: entity.surface,
      maxPlayers: entity.maxPlayers,
      phone: entity.phone,
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }
}