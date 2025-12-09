#!/bin/bash

# Flutter flavor'a göre doğru GoogleService-Info.plist'i kopyalar
# Bu script Xcode Build Phases'da çalıştırılır

# Proje klasörü
RUNNER_PATH="${SRCROOT}/Runner"

# Flavor kontrolü - Flutter'dan gelen flavor veya configuration'a göre karar ver
if [[ "${PRODUCT_BUNDLE_IDENTIFIER}" == *".dev"* ]] || [[ "${CONFIGURATION}" == *"Dev"* ]] || [[ "${FLUTTER_FLAVOR}" == "dev" ]]; then
    PLIST_SOURCE="${RUNNER_PATH}/dev/GoogleService-Info.plist"
    echo "📱 DEV ortamı için GoogleService-Info.plist kopyalanıyor..."
elif [[ "${PRODUCT_BUNDLE_IDENTIFIER}" == "com.toplansin.toplansin" ]] || [[ "${CONFIGURATION}" == *"Prod"* ]] || [[ "${FLUTTER_FLAVOR}" == "prod" ]]; then
    PLIST_SOURCE="${RUNNER_PATH}/prod/GoogleService-Info.plist"
    echo "🚀 PROD ortamı için GoogleService-Info.plist kopyalanıyor..."
else
    # Varsayılan olarak DEV kullan
    PLIST_SOURCE="${RUNNER_PATH}/dev/GoogleService-Info.plist"
    echo "⚠️ Flavor belirlenemedi, varsayılan DEV kullanılıyor..."
fi

PLIST_DESTINATION="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"

# Kaynak dosya var mı kontrol et
if [ -f "${PLIST_SOURCE}" ]; then
    cp "${PLIST_SOURCE}" "${PLIST_DESTINATION}"
    echo "✅ GoogleService-Info.plist kopyalandı: ${PLIST_SOURCE}"
else
    echo "❌ HATA: Kaynak dosya bulunamadı: ${PLIST_SOURCE}"
    exit 1
fi

