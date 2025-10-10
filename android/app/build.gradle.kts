// plugins {
//     id("com.android.application")
//     id("com.google.gms.google-services")
//     id("kotlin-android")
//     id("dev.flutter.flutter-gradle-plugin")
// }

// android {
//     namespace = "com.example.store"
//     compileSdk = flutter.compileSdkVersion
//     ndkVersion = flutter.ndkVersion
//    defaultConfig {
//         minSdkVersion(26) // <-- لازم يكون هنا
//     }
//     compileOptions {
//         isCoreLibraryDesugaringEnabled = true
//         sourceCompatibility = JavaVersion.VERSION_1_8
//         targetCompatibility = JavaVersion.VERSION_1_8

//     }

//     kotlinOptions {
//         jvmTarget = JavaVersion.VERSION_1_8.toString()
//     }

//     defaultConfig {
//         applicationId = "com.example.store"
//         minSdk = flutter.minSdkVersion
//         targetSdk = flutter.targetSdkVersion
//         versionCode = flutter.versionCode
//         versionName = flutter.versionName

//     }

//     buildTypes {
//         release {
//             signingConfig = signingConfigs.getByName("debug")
//         }
//     }
// }

// flutter {
//     source = "../.."
// }

// dependencies {
//     coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
// }

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.store"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }

    // تم دمج الجزئين هنا في جزء واحد صحيح
    defaultConfig {
        applicationId = "com.example.store"
        minSdkVersion(26) // <-- هذا هو التعديل الصحيح
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}