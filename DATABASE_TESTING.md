# ✅ Database & Login Testing Guide

## 🔍 **Database Information:**

### **Database Type**: SQLite (bukan MySQL Laragon)
- **File**: `mbanking.db`
- **Location**: Di folder `MBANKING_BACKEND`

### **Table Structure**:
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT NOT NULL,
  password TEXT NOT NULL
);
```

### **Dummy User**:
- **Username**: `raja`
- **Password**: `123456`

## 🚀 **Testing Login:**

### **1. Test dengan Debug Button**
- Buka aplikasi Flutter
- Tap tombol "🔍 Test Server Connection"
- Sekarang akan menggunakan kredensial yang benar

### **2. Test Login Manual**
Di login screen, masukkan:
- **Username**: `raja`
- **Password**: `123456`

### **3. Test dengan curl**
```bash
curl -X POST http://localhost:8080/login \
  -H "Content-Type: application/json" \
  -d '{"username":"raja","password":"123456"}'
```

**Expected Response**:
```json
{
  "success": true,
  "message": "Login berhasil"
}
```

## 🔧 **Register Endpoint:**

Jika endpoint `/register` belum ada, tambahkan di server Dart:

```dart
// Endpoint Register
app.post('/register', (Request req) async {
  final body = await req.readAsString();
  final data = jsonDecode(body);
  
  final username = data['username'];
  final password = data['password'];
  
  // Insert user baru ke database
  db.execute(
    'INSERT INTO users (username, password) VALUES (?, ?)',
    [username, password],
  );
  
  return Response.ok(
    jsonEncode({'success': true, 'message': 'Register berhasil'}),
    headers: {'Content-Type': 'application/json'},
  );
});
```

## 📋 **Testing Checklist:**

- [x] Server Dart berjalan ✅
- [x] Database SQLite terhubung ✅
- [x] User dummy tersedia ✅
- [x] Endpoint `/login` berfungsi ✅
- [ ] Test login dengan kredensial benar
- [ ] Test register (jika endpoint ada)

## 🎯 **Next Steps:**

1. **Test login** dengan username: `raja`, password: `123456`
2. **Jika berhasil**, aplikasi akan redirect ke dashboard
3. **Jika perlu register**, buat endpoint `/register` di server
4. **Test register** untuk membuat user baru

## 🚨 **Important Notes:**

- Database menggunakan **SQLite**, bukan MySQL Laragon
- File database: `mbanking.db` di folder server
- Password disimpan sebagai **plain text** (tidak di-hash)
- Untuk production, sebaiknya gunakan password hashing

## 🔧 **Troubleshooting:**

### **Jika Login Gagal:**
1. Periksa username/password benar
2. Periksa database file `mbanking.db` ada
3. Periksa server log untuk error

### **Jika Register Gagal:**
1. Pastikan endpoint `/register` sudah dibuat
2. Periksa database connection
3. Periksa format data yang dikirim
