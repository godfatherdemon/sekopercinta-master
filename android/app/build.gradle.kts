// plugins {
//     kotlin("jvm") version "1.5.31"
//     // Add other plugins as needed
// }

// repositories {
//     // Add repositories as needed
// }

// dependencies {
//     implementation(kotlin("stdlib-jdk8"))
//     // Add other dependencies as needed
// }

// tasks {
//     // Define your tasks here
// }

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    kotlin("android")
    kotlin("jvm") version "1.5.31"
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.reader().use { reader ->
        localProperties.load(reader)
    }
}

val flutterRoot = localProperties.getProperty("flutter.sdk")
if (flutterRoot == null) {
    throw GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file.")
}

var flutterVersionCode = localProperties.getProperty("flutter.versionCode")
if (flutterVersionCode == null) {
    flutterVersionCode = "1"
}

var flutterVersionName = localProperties.getProperty("flutter.versionName")
if (flutterVersionName == null) {
    flutterVersionName = "1.0"
}

android {
    compileSdkVersion(34)

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    defaultConfig {
        applicationId = "id.braga.sekoci"
        minSdkVersion(22)
        targetSdkVersion(33)
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
        multiDexEnabled(true)
    }

    dexOptions {
        javaMaxHeapSize = "4g"
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"]
            keyPassword = keystoreProperties["keyPassword"]
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"]
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs["release"]

            ndk {
                abiFilters("armeabi-v7a", "arm64-v8a", "x86_64", "x86")
            }
        }
    }
}

flutter {
    source("../..")
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version")
    implementation("com.android.support:multidex:2.0.1") // <-- Check for this line
}

// Additional configurations and customizations can be added here
