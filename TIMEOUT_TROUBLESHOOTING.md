# 🚨 Troubleshooting TimeoutException

## 🔍 **Error yang Terjadi:**
```
TimeoutException after 0:00:10.000000: Future not completed
URL: http://192.168.18.237:8080
```

## 🎯 **Artinya:**
- ✅ Flutter bisa mencapai URL tersebut
- ❌ Server tidak merespons dalam 10 detik
- ❌ Kemungkinan server tidak berjalan atau port salah

## 🛠️ **Solusi Langkah demi Langkah:**

### **1. Periksa Server Dart Berjalan**
```bash
# Buka terminal di folder MBANKING_BACKEND
cd MBANKING_BACKEND

# Jalankan server
dart run bin/mbanking_backend.dart
```

**Output yang diharapkan:**
```
Serving at http://localhost:8080
# atau
Serving at http://0.0.0.0:8080
```

### **2. Periksa Port Server**
Cari di file `bin/mbanking_backend.dart` atau `lib/mbanking_backend.dart`:
```dart
await io.serve(app, 'localhost', 8080); // Port 8080
// atau
await io.serve(app, '0.0.0.0', 3000); // Port 3000
```

### **3. Test dengan Browser**
Buka browser dan test:
```
http://localhost:8080/login
```
(POST request dengan JSON body)

### **4. Test dengan curl**
```bash
curl -X POST http://localhost:8080/login \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"test"}'
```

### **5. Periksa IP Address**
```bash
# Windows
ipconfig

# Mac/Linux
ifconfig
```

### **6. Test Multiple URLs**
Tap tombol **"Test URLs Lain"** di dialog error untuk test:
- `http://192.168.18.237:3000`
- `http://192.168.18.237:8000`
- `http://localhost:8080`
- `http://10.0.2.2:8080` (Android emulator)

## 🔧 **Quick Fix:**

### **Jika Server Berjalan di Port Lain:**
Ubah di `lib/services/api_service.dart`:
```dart
// Jika server di port 3000:
static const String baseUrl = 'http://192.168.18.237:3000';

// Jika server di port 8000:
static const String baseUrl = 'http://192.168.18.237:8000';
```

### **Jika Server Berjalan di localhost:**
```dart
// Untuk Android emulator:
static const String baseUrl = 'http://10.0.2.2:8080';

// Untuk device fisik:
static const String baseUrl = 'http://192.168.1.100:8080'; // Ganti dengan IP komputer Anda
```

## 📋 **Checklist:**

- [ ] Server Dart sudah berjalan (`dart run bin/mbanking_backend.dart`)
- [ ] Port server sudah diketahui
- [ ] Server bisa diakses dari browser
- [ ] IP address komputer sudah benar
- [ ] Network terhubung
- [ ] Firewall tidak memblokir

## 🚀 **Langkah Selanjutnya:**

1. **Jalankan server Dart** di terminal
2. **Periksa port** yang digunakan
3. **Update URL** di Flutter sesuai port
4. **Test dengan debug button** lagi
5. **Jika masih timeout**, coba port lain

## 📞 **Jika Masih Bermasalah:**

1. **Periksa log server** untuk error
2. **Test dengan Postman** atau curl
3. **Periksa database connection** di `db.dart`
4. **Pastikan Laragon MySQL** sudah berjalan
5. **Restart server** dan coba lagi
