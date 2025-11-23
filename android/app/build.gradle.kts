import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
var keystorePropertiesFile : File;
if (System.getProperty("os.name").toLowerCase().contains("win")) {
    keystorePropertiesFile = rootProject.file("key.properties.windows")  // Windows specific key.properties
} else if (System.getProperty("os.name").toLowerCase().contains("mac")) {
    keystorePropertiesFile = rootProject.file("key.properties")  // macOS specific key.properties
} else {
    keystorePropertiesFile = rootProject.file("key.properties")  // Default Linux key.properties
}
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.app.mingly"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.appx.mingly"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Configure signingConfigs automatically. If a platform-specific key properties file
    // (key.properties.windows or key.properties) exists and was loaded above into
    // `keystoreProperties`, the release signing config will be populated from it.
    // If no release keystore is found, the release build will fall back to the
    // debug keystore so you don't need to uncomment anything for local debugging.
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = keystoreProperties["storeFile"]?.let { file(it as String) }
                storePassword = keystoreProperties["storePassword"] as String
            } else {
                // No release keystore provided; keep values unset so debug keystore
                // will be used as a fallback by buildTypes below.
            }
        }
    }

    buildTypes {
        release {
            // If we loaded a release keystore file, use that signing config;
            // otherwise fall back to the debug signing config so local runs still work.
            // signingConfig = if (keystorePropertiesFile.exists()) {
            //     signingConfigs.getByName("release")
            // } else {
            //     signingConfigs.getByName("debug")
            // }
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // Print a small message during configuration so it's obvious which signing
    // config will be used. This appears in Gradle output when configuration runs.
    if (keystorePropertiesFile.exists()) {
        println("Gradle: Found release keystore at: ${keystorePropertiesFile.path} — release builds will use it.")
    } else {
        println("Gradle: No release keystore found; release builds will fall back to debug signing locally.")
    }
}

flutter {
    source = "../.."
}
