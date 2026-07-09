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

// file_picker (as of 11.0.2) skips applying the Kotlin Android Gradle plugin
// under AGP 9+, assuming AGP's built-in Kotlin support will compile its .kt
// sources automatically. That assumption doesn't hold here and leaves
// FilePickerPlugin uncompiled ("cannot find symbol" in
// GeneratedPluginRegistrant). Force the plugin back on, and re-set the JVM
// target it would otherwise have configured itself (also gated behind the
// same skipped AGP<9 branch), until upstream ships a real fix:
// https://github.com/miguelpruivo/flutter_file_picker/issues/1973
subprojects {
    if (project.name == "file_picker") {
        pluginManager.apply("org.jetbrains.kotlin.android")
        tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            compilerOptions.jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
