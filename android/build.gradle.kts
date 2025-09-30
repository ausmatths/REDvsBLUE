allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

plugins {
    id("com.google.gms.google-services") version "4.4.1" apply false
}


android {
    namespace = "com.rvb.redvsblue"
    compileSdk = 34

    defaultConfig { // <-- This is the block you are looking for
        applicationId = "com.rvb.redvsblue"
        minSdk = 21 // <-- Make sure this is 21 or higher
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

}