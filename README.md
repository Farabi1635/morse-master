# MORSE MASTER (Flutter, Android)
Struktur: `lib/main.dart` (titik masuk), `app.dart` (tema), `widgets.dart` (komponen & logo), `core/` (data Morse, mesin audio/narator, penyimpanan), `pages/` (tiap halaman satu file), `assets/icon/` (logo).
Build: unggah semua ke GitHub, jalankan workflow "Build APK" (lihat `.github/workflows/apk.yml`), unduh artifact `MorseMaster-APK`.
Lokal: `sh setup.sh` lalu `flutter build apk --release`.
