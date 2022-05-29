# music_player_example

a simple music player app for android using flutter. This app can be used to find a list of songs from [iTuneSearchAPI](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html#//apple_ref/doc/uid/TP40017632-CH3-SW1). In addition, this app can be used to play song snippets.

## Supported Devices
- tester device: Google Pixel 3 Api 28, Android 9.0 [Pie](https://developer.android.com/about/versions/pie)
- minSdkVersion 16, Android 4.1 [Jelly bean](https://developer.android.com/about/versions/jelly-bean)
- targetSdkVersion 31

## Supported Feature
- Search for song from iTune Search API
- play a snippet of a song

## Requirements to build the app
- [Flutter 2.5.2](https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_2.5.2-stable.zip)
- [Dart 2.14.3](https://storage.googleapis.com/dart-archive/channels/stable/release/2.14.3/sdk/dartsdk-windows-x64-release.zip)
- [fluttertoast: ^8.0.9](https://pub.dev/packages/fluttertoast)
- [dio: ^3.0.10](https://pub.dev/packages/dio)
- [audioplayers: ^0.18.3](https://pub.dev/packages/audioplayer)

## Instructions to build and deploy the app
### Getting Started
- Pull project from this repository
- Get required dependent library
```
flutter pub get
```
### Build and deploy
for runing the project
- Add aditional run args
- flutter run --no-sound-null-safety

for deploy using Android Studio
- Build > Flutter > Build APK
