plugins { id("com.android.application"); id("org.jetbrains.kotlin.android") }

android { namespace = "com.hindtechgroup.sequenceiq"; compileSdk = 36
    defaultConfig { applicationId = "com.hindtechgroup.sequenceiq"; minSdk = 26; targetSdk = 36; versionCode = 1; versionName = "1.0" }
}

kotlin { jvmToolchain(17) }

android.sourceSets["main"].java.srcDirs("..")

dependencies { implementation("androidx.appcompat:appcompat:1.7.1") }
