plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")   // ⬅️ BUNU EKLE
}


android {
    namespace = "com.toplansin.toplansin_cleanarch"  // ← Bunu değiştir
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    // 🔴 Varsayılanı DEV yapıyoruz (dev app id)
    defaultConfig {
        applicationId = "com.toplansin.toplansin.dev"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // 🔹 flavor ayrımı
    flavorDimensions += "env"

    productFlavors {
        create("dev") {
            dimension = "env"
            // DEV: com.toplansin.toplansin.dev
            applicationId = "com.toplansin.toplansin.dev"
            resValue("string", "app_name", "Toplansın Dev")
        }
        create("prod") {
            dimension = "env"
            // PROD: canlı app id
            applicationId = "com.toplansin.toplansin"
            resValue("string", "app_name", "Toplansın")
        }
    }

    buildTypes {
        getByName("release") {
            // Şimdilik debug key ile imza; keystore’u sonra ekleyeceğiz
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
