// lib/domain/entities/venue_entity.dart
class VenueEntity {
  // 📋 TEMEL BİLGİLER
  // ─────────────────────────────────────────────────────────────
  final String id;
  final String ownerId;
  final String name;
  final String location;
  final num price;
  final num rating;
  final List<String> imagesUrl;
  final List<String> bookedSlots;
  final String startHour;
  final String endHour;
  
  // ─────────────────────────────────────────────────────────────
  // 📅 TARİH BİLGİLERİ
  // ─────────────────────────────────────────────────────────────
  final DateTime? createdAt;      // En yeniler için
  final DateTime? updatedAt;      // Güncelleme takibi
  
  // ─────────────────────────────────────────────────────────────
  // 🏷️ DURUM BİLGİLERİ
  // ─────────────────────────────────────────────────────────────
  final bool isPremium;           // Premium/öne çıkan saha
  final bool isActive;            // Yayında mı
  final int viewCount;            // Görüntülenme (popülerlik için)
  final int totalReviews;         // Yorum sayısı
  
  // ─────────────────────────────────────────────────────────────
  // 🎯 ÖZELLİKLER (Amenities)
  // ─────────────────────────────────────────────────────────────
  final bool hasParking;
  final bool hasShowers;
  final bool hasShoeRental;
  final bool hasCafeteria;
  final bool hasNightLighting;
  final bool hasMaleToilet;
  final bool hasFemaleToilet;
  final bool hasFoodService;
  final bool acceptsCreditCard;
  final bool hasFoosball;
  final bool hasCameras;
  final bool hasGoalkeeper;
  final bool hasPlayground;
  final bool hasPrayerRoom;
  final bool hasInternet;
  
  // ─────────────────────────────────────────────────────────────
  // 📝 EK BİLGİLER
  // ─────────────────────────────────────────────────────────────
  final String description;
  final String size;
  final String surface;
  final int maxPlayers;
  final String phone;
  final double latitude;
  final double longitude;

  const VenueEntity({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.imagesUrl,
    required this.bookedSlots,
    required this.startHour,
    required this.endHour,
    this.createdAt,
    this.updatedAt,
    this.isPremium = false,
    this.isActive = true,
    this.viewCount = 0,
    this.totalReviews = 0,
    required this.hasParking,
    required this.hasShowers,
    required this.hasShoeRental,
    required this.hasCafeteria,
    required this.hasNightLighting,
    required this.hasMaleToilet,
    required this.hasFemaleToilet,
    required this.hasFoodService,
    required this.acceptsCreditCard,
    required this.hasFoosball,
    required this.hasCameras,
    required this.hasGoalkeeper,
    required this.hasPlayground,
    required this.hasPrayerRoom,
    required this.hasInternet,
    required this.description,
    required this.size,
    required this.surface,
    required this.maxPlayers,
    required this.phone,
    required this.latitude,
    required this.longitude,
  });
}