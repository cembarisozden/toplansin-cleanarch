/// Onboarding içerik modeli
class OnboardingContent {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingContent({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

/// Onboarding sayfaları içerikleri
const List<OnboardingContent> onboardingItems = [
  OnboardingContent(
    title: 'Sahanı Bul, Maçını Ayarla',
    description:
        'Yüzlerce halı saha arasından sana en uygununu keşfet, saniyeler içinde rezervasyonunu yap.',
    imagePath: 'assets/images/onboarding_1.png',
  ),
  OnboardingContent(
    title: 'Haftalık Abonelikle Yerin Hazır',
    description:
        'Her hafta maçını garanti al, rezervasyon derdiyle uğraşma. Otomatik yenilenen abonelikle saha hep senin olsun.',
    imagePath: 'assets/images/onboarding_2.png',
  ),
  OnboardingContent(
    title: 'Takımını Kur, Sahaya Çık',
    description:
        'Arkadaşlarını davet et, eksik oyuncu bul veya hazır maçlara katıl. Futbol heyecanını birlikte yaşa.',
    imagePath: 'assets/images/onboarding_3.png',
  ),
  
];