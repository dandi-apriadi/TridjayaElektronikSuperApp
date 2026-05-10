allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val rootBuildDirectory = rootProject.layout.projectDirectory.dir("../build")

allprojects {
    val projectBuildDirectory = if (project == rootProject) {
        rootBuildDirectory
    } else {
        rootBuildDirectory.dir(project.name)
    }
    layout.buildDirectory.set(projectBuildDirectory)

    // Force stable AndroidX versions to avoid AGP 8.9.1 requirements
    configurations.all {
        resolutionStrategy {
            force("androidx.browser:browser:1.7.0")
            force("androidx.activity:activity:1.8.2")
            force("androidx.core:core:1.13.1")
            force("androidx.core:core-ktx:1.13.1")
            force("androidx.navigationevent:navigationevent-android:1.0.0-alpha01")
        }
    }
}

subprojects {
    afterEvaluate {
        if (project.extensions.findByName("android") != null) {
            val android = project.extensions.getByName("android")
            if (android is com.android.build.gradle.BaseExtension) {
                // Using stable API 34
                android.compileSdkVersion(34)
                android.defaultConfig.targetSdk = 34
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
