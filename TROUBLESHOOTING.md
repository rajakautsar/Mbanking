# 🔧 Troubleshooting Koneksi Server

## 🚨 **Masalah: "Koneksi ke server gagal"**

### 🔍 **Langkah-langkah Debugging:**

#### 1. **Periksa URL API**
Saat ini menggunakan: `http://192.168.18.237:8080`

**Cara mengubah URL:**
- Buka file `lib/services/api_service.dart`
- Ubah baris 7: `static const String baseUrl = 'URL_ANDA_DISINI';`

**URL Alternatif yang bisa dicoba:**
```dart
// Untuk server lokal Laragon
static const String baseUrl = 'http://localhost:8080';
static const String baseUrl = 'http://127.0.0.1:8080';

// Untuk Android emulator
static const String baseUrl = 'http://10.0.2.2:8080';

// Untuk device fisik (ganti dengan IP komputer Anda)
static const String baseUrl = 'http://192.168.1.100:8080';
```

#### 2. **Test Koneksi dengan Debug Button**
- Jalankan aplikasi Flutter
- Di login screen, tap tombol "🔍 Test Server Connection"
- Lihat hasil di dialog yang muncul
- Jika gagal, tap "Test URLs Lain" untuk test multiple URLs

#### 3. **Periksa Server Laragon**
Pastikan server Laragon sudah berjalan:
- Buka Laragon
- Klik "Start All"
- Pastikan status hijau untuk Apache dan MySQL
- Test di browser: `http://localhost:8080` atau `http://192.168.18.237:8080`

#### 4. **Periksa Endpoint API**
Pastikan endpoint yang benar:
- Login: `POST /login` (bukan `/api/login`)
- Register: `POST /register` (bukan `/api/register`)
- Health: `GET /health` (bukan `/api/health`)

#### 5. **Periksa Network**
- Pastikan komputer dan device/emulator dalam network yang sama
- Untuk emulator Android, gunakan `10.0.2.2` bukan `localhost`
- Untuk device fisik, gunakan IP address komputer

#### 6. **Periksa CORS**
Jika server menggunakan CORS, pastikan mengizinkan request dari Flutter:
```php
// Di server PHP/Laravel
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
```

#### 7. **Periksa Firewall**
- Pastikan firewall tidak memblokir port 8080
- Test dengan browser terlebih dahulu

### 🔧 **Solusi Berdasarkan Error:**

#### **Error: "Connection refused"**
- Server tidak berjalan
- Port salah
- Firewall memblokir

#### **Error: "Timeout"**
- Network lambat
- Server tidak responsif
- URL salah

#### **Error: "Host not found"**
- URL salah
- DNS tidak resolve
- Network tidak terhubung

#### **Error: "CORS"**
- Server tidak mengizinkan request dari Flutter
- Perlu konfigurasi CORS di server

### 📱 **Testing di Device Berbeda:**

#### **Android Emulator:**
```dart
static const String baseUrl = 'http://10.0.2.2:8080';
```

#### **iOS Simulator:**
```dart
static const String baseUrl = 'http://localhost:8080';
```

#### **Device Fisik:**
```dart
// Ganti dengan IP address komputer Anda
static const String baseUrl = 'http://192.168.1.100:8080';
```

### 🛠️ **Cara Mengetahui IP Address Komputer:**

#### **Windows:**
```cmd
ipconfig
```

#### **Mac/Linux:**
```bash
ifconfig
```

### 📋 **Checklist Troubleshooting:**

- [ ] Server Laragon sudah berjalan
- [ ] URL API sudah benar
- [ ] Port sudah benar (8080)
- [ ] Network terhubung
- [ ] Firewall tidak memblokir
- [ ] CORS sudah dikonfigurasi
- [ ] Endpoint API sudah benar
- [ ] Test dengan browser berhasil

### 🚀 **Quick Fix:**

1. **Ubah URL di `api_service.dart`:**
```dart
static const String baseUrl = 'http://10.0.2.2:8080'; // Untuk emulator
```

2. **Test dengan debug button di login screen**

3. **Lihat console log untuk detail error**

4. **Jika masih gagal, coba URL lain:**
```dart
static const String baseUrl = 'http://192.168.1.100:8080'; // IP komputer Anda
```

### 📞 **Jika Masih Bermasalah:**

1. Pastikan server API sudah berjalan dan bisa diakses dari browser
2. Periksa log server untuk error
3. Test dengan Postman atau curl
4. Pastikan format data yang dikirim sesuai dengan yang diharapkan server
