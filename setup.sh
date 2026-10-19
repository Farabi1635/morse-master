#!/bin/sh
# Membuat folder android/ tanpa menimpa kode di lib/, lalu memasang logo.
set -e
for f in main.dart app.dart widgets.dart core/engine.dart core/morse.dart pages/home.dart; do
  [ -f lib/$f ] || { echo "GAGAL: lib/$f tidak ada di repo. Unggah ulang folder lib."; exit 1; }
done
grep -q MorseApp lib/app.dart || { echo "GAGAL: lib/app.dart bukan kode MORSE MASTER."; exit 1; }
[ -f assets/icon/icon.png ] || { echo "GAGAL: assets/icon/icon.png tidak ada. Unggah folder assets."; exit 1; }
rm -f lib/engine.dart lib/morse.dart
rm -rf /tmp/lib_bak && cp -r lib /tmp/lib_bak
flutter create . --platforms=android --org id.pramuka --project-name morse_master
rm -rf lib && cp -r /tmp/lib_bak lib
M=android/app/src/main/AndroidManifest.xml
grep -q TTS_SERVICE $M || sed -i 's#<application#<queries><intent><action android:name="android.intent.action.TTS_SERVICE"/></intent></queries>\n    <application#' $M
sed -i 's#android:label="[^"]*"#android:label="MORSE MASTER"#' $M
flutter pub get
dart run flutter_launcher_icons
echo "Siap. Jalankan: flutter build apk --release"
