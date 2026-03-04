@echo off
flutter clean
flutter pub get
flutter build windows --release
echo BUILD_COMPLETE
