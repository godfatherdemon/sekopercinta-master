// settings.gradle.kts

include(":app")

val localPropertiesFile = File(rootProject.projectDir, "local.properties")
val properties = Properties()

require(localPropertiesFile.exists()) { "local.properties file not found." }
localPropertiesFile.reader("UTF-8").use { reader -> properties.load(reader) }

val flutterSdkPath = properties.getProperty("flutter.sdk")
requireNotNull(flutterSdkPath) { "flutter.sdk not set in local.properties." }
apply(from = File(flutterSdkPath, "packages/flutter_tools/gradle/app_plugin_loader.gradle"))
