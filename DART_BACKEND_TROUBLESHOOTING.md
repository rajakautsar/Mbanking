# 🔧 Troubleshooting Dart Backend Server

## 🎯 **Informasi Server Anda:**

Berdasarkan gambar yang Anda tunjukkan, server Anda adalah:
- **Framework**: Dart dengan `shelf` dan `shelf_router`
- **Endpoint**: `/login` (POST) - sudah ada
- **Database**: `DatabaseHelper` dari `db.dart`
- **Response Format**: `{'success': true/false, 'message': '...'}`

## 🚨 **Masalah yang Ditemukan:**

### 1. **Port Server Tidak Terlihat**
Dari kode yang terlihat, port server tidak ditampilkan. Kita perlu tahu port berapa server berjalan.

### 2. **Endpoint `/register` Belum Ada**
Server hanya memiliki endpoint `/login`, belum ada `/register`.

### 3. **Endpoint `/health` Belum Ada**
Untuk testing koneksi, server belum memiliki endpoint health check.

## 🔍 **Langkah-langkah Debugging:**

### **1. Cari Port Server**
Di file `bin/mbanking_backend.dart` atau `lib/mbanking_backend.dart`, cari baris seperti:
```dart
await io.serve(app, 'localhost', 8080); // Port 8080
// atau
await io.serve(app, '0.0.0.0', 3000); // Port 3000
```

### **2. Test Koneksi dengan Debug Button**
- Jalankan aplikasi Flutter
- Tap tombol "🔍 Test Server Connection" di login screen
- Lihat hasil di dialog

### **3. Periksa Server Berjalan**
Pastikan server Dart sudah berjalan:
```bash
# Di terminal, jalankan:
dart run bin/mbanking_backend.dart
# atau
dart run lib/mbanking_backend.dart
```

### **4. Test di Browser**
Test endpoint login di browser:
```
http://localhost:8080/login
```
(Post request dengan JSON body)

## 🛠️ **Solusi Berdasarkan Masalah:**

### **Jika Port Salah:**
Ubah di `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://192.168.18.237:3000'; // Ganti port
```

### **Jika Endpoint `/register` Belum Ada:**
Tambahkan di server Dart:
```dart
// Endpoint Register
app.post('/register', (Request req) async {
  final body = await req.readAsString();
  final data = jsonDecode(body);
  
  final username = data['username'];
  final email = data['email'];
  final phone = data['phone'];
  final password = data['password'];
  
  if (dbHelper.register(username, email, phone, password)) {
    return Response.ok(
      jsonEncode({'success': true, 'message': 'Register berhasil'}),
      headers: {'Content-Type': 'application/json'},
    );
  } else {
    return Response.badRequest(
      body: jsonEncode({'success': false, 'message': 'Register gagal'}),
      headers: {'Content-Type': 'application/json'},
    );
  }
});
```

### **Jika Endpoint `/health` Belum Ada:**
Tambahkan di server Dart:
```dart
// Health check endpoint
app.get('/health', (Request req) async {
  return Response.ok(
    jsonEncode({'success': true, 'message': 'Server running'}),
    headers: {'Content-Type': 'application/json'},
  );
});
```

## 📋 **Checklist untuk Dart Backend:**

- [ ] Server Dart sudah berjalan (`dart run bin/mbanking_backend.dart`)
- [ ] Port server sudah diketahui
- [ ] URL di Flutter sudah sesuai dengan port server
- [ ] Endpoint `/login` bisa diakses
- [ ] Endpoint `/register` sudah dibuat (jika belum)
- [ ] Database connection di `db.dart` sudah benar
- [ ] Laragon MySQL sudah berjalan

## 🔧 **Cara Menjalankan Server Dart:**

### **1. Pastikan Dependencies Terinstall:**
```bash
cd MBANKING_BACKEND
dart pub get
```

### **2. Jalankan Server:**
```bash
dart run bin/mbanking_backend.dart
```

### **3. Test Server:**
```bash
# Test dengan curl
curl -X POST http://localhost:8080/login \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"test"}'
```

## 🚀 **Quick Fix:**

1. **Cari port server** di file `bin/mbanking_backend.dart`
2. **Update URL** di `lib/services/api_service.dart` sesuai port
3. **Test dengan debug button** di login screen
4. **Pastikan server berjalan** dengan `dart run bin/mbanking_backend.dart`

## 📞 **Jika Masih Bermasalah:**

1. **Periksa log server** saat menjalankan
2. **Test endpoint** dengan Postman atau curl
3. **Periksa database connection** di `db.dart`
4. **Pastikan Laragon MySQL** sudah berjalan
5. **Periksa firewall** tidak memblokir port

## 🎯 **Yang Perlu Diperiksa di Server:**

1. **File `bin/mbanking_backend.dart`** - untuk melihat port
2. **File `lib/db.dart`** - untuk database connection
3. **File `pubspec.yaml`** - untuk dependencies
4. **Terminal output** - untuk error messages
