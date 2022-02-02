# Getting Started

A Framework to create a Flutter Project follow GetX Pattern Design.

GetX Pattern:

- [Design Pattern](https://github.com/kauemurakami/getx_pattern)
- [Cookbook: pub.dev](https://pub.dev/packages/get)
- [Diagram](https://imgur.com/WMVyvYv)
 ![](https://imgur.com/WMVyvYv.png)

# Create Project

Create new project with sound null safety:
><project_name>: The project name for this new Flutter project. This must be a valid dart package name.

> <com.decomlab.base_source>: The organization responsible for your new Flutter project, in reverse domain name notation. This string is used in Java package names and as prefix in the iOS bundle identifier.
```dart
flutter create --project-name <project_name> --org <com.decomlab.base_source> -a [java/kotlin(default)] -i [swift/object-c] <output directory>
&& dart migrate --apply-changes
```
# [Build and release an iOS app](https://flutter.dev/docs/deployment/ios)

Before beginning the process of releasing your app, ensure that it meets [Apple’s App Review Guidelines](https://developer.apple.com/app-store/review/).

In order to publish your app to the App Store, you must first enroll in the [Apple Developer Program](https://developer.apple.com/programs/).

1. [Register a Bundle ID](https://developer.apple.com/account/ios/identifier/bundle)
2. [Create an application record on App Store Connect](https://help.apple.com/app-store-connect/#/dev2cd126805)
3. [Review Xcode project settings](https://help.apple.com/xcode/mac/current/#/dev91fe7130a)
4. Create a build archive
-  Run flutter build ipa to produce a build archive to Reduce shader compilation jank on mobile.
> Run the app with --cache-sksl turned on to capture shaders in SkSL:
```dart
// first time
$ flutter run --profile --cache-sksl --purge-persistent-cache
// not first time
$ flutter run --profile --cache-sksl
```
> Play with the app to trigger as many animations as needed; particularly those with compilation jank.

>Press M at the command line of flutter run to write the captured SkSL shaders into a file named something like flutter_01.sksl.json.

```dart
$ flutter build ipa --release --bundle-sksl-path flutter_01.sksl.json
```

> Open build/ios/archive/MyApp.xcarchive in Xcode.
> Click the Validate App button
> After the archive has been successfully validated, click Distribute App. You can follow the status of your◊ build in the Activities tab of your app’s details page on [App Store Connect](https://appstoreconnect.apple.com/).

5. [Release your app on TestFlight](https://developer.apple.com/testflight/)








```dart
// Android
// flutter build apk --release --bundle-sksl-path flutter_android_01.sksl.json
// or
// flutter build appbundle --release --bundle-sksl-path flutter_01.sksl.json

// Bundle to apks
// java -jar outputs/bundletool.jar build-apks --bundle=build/app/outputs/bundle/release/app-release.aab --output=outputs/unface_app.apks

// install apks
// java -jar outputs/bundletool.jar install-apks --apks=outputs/unface_app.apks

// copy to release folder
// cp build/app/outputs/flutter-apk/app-release.apk outputs/android-unface-release.apk
```