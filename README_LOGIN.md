# TALENTA Mobile: Fitur Login

Isi paket ini: layar login sesuai desain Figma, koneksi ke API Laravel, penyimpanan token
yang aman, cek sesi saat aplikasi dibuka (user tetap login sampai logout), dan halaman
placeholder setelah login. File di sini adalah kode Dart saja, bukan project Flutter utuh.

## 1. Siapkan project Flutter

Di dalam folder repo `Talenta-mobile-Flutter` (folder yang sudah ada `.git` dan `README.md`):

```bash
flutter create . --project-name talenta_mobile --org id.talenta
flutter pub add provider http flutter_secure_storage
```

Lalu salin `lib/` dan `assets/` dari paket ini ke folder itu (timpa `lib/main.dart`).

## 2. Daftarkan aset di `pubspec.yaml`

Di bagian `flutter:`:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

## 3. Izin internet dan HTTP (Android)

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>

<application
    android:usesCleartextTraffic="true"
    ... >
```

`usesCleartextTraffic` dibutuhkan karena server lokal memakai `http://`, bukan `https://`.
Hapus atau matikan saat rilis, dan pakai HTTPS di server produksi.

Kalau build gagal karena `minSdkVersion`, di `android/app/build.gradle(.kts)` set `minSdk = 23`
(dibutuhkan `flutter_secure_storage` versi terbaru).

## 4. Alamat server

| Perangkat | Alamat API | Cara |
|---|---|---|
| Emulator Android | `http://10.0.2.2:8000/api/v1` | Otomatis, tidak perlu diatur |
| HP asli | `http://IP-KOMPUTER:8000/api/v1` | Lihat di bawah |

Untuk HP asli (HP dan komputer harus di Wi-Fi yang sama):

```bash
# di project Laravel
php artisan serve --host=0.0.0.0

# di project Flutter
flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8000/api/v1
```

Ganti `192.168.1.10` dengan IP komputermu (`ipconfig`). Firewall Windows mungkin meminta izin untuk PHP.

## 5. Coba login

1. Pastikan MySQL menyala dan `php artisan migrate --seed` sudah berhasil, lalu `php artisan serve`.
2. Buat akun lewat Postman: `POST /api/v1/auth/register` (name, email, password, role, sekolah, jurusan).
3. Jalankan `flutter run`, lalu login dengan email dan password akun itu.
4. Tutup aplikasi lalu buka lagi: harus langsung masuk tanpa login ulang.
5. Tekan Keluar di halaman placeholder: kembali ke layar login.

Akun `admin` dan `super_admin` sengaja ditolak di aplikasi mobile.

## 6. Struktur

```
lib/
  main.dart                      AuthGate: pilih halaman sesuai status login
  core/app_config.dart           alamat API, timeout
  core/app_theme.dart            warna dan tema
  models/app_user.dart
  services/auth_service.dart     login, /me, logout
  services/token_storage.dart    token di secure storage
  services/api_exception.dart
  providers/auth_provider.dart   status login (Provider)
  screens/login_screen.dart      layar login
  screens/home_placeholder.dart  ganti dengan dashboard
  screens/offline_screen.dart
  widgets/app_text_field.dart
  widgets/splash_view.dart
```

## 7. Belum ada

- Layar Selamat Datang, pilih Siswa/Alumni, dan Daftar
- Lupa Sandi, Continue With Google, Continue With Email (tombolnya ada, backend belum mendukung)
- Dashboard siswa dan alumni
