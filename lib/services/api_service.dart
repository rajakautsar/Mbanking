import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL untuk Dart backend server (shelf)
  // PENTING: Sesuaikan dengan port server Dart Anda
  static const String baseUrl = 'http://10.0.2.2:8080'; // Untuk Android emulator
  
  // Alternatif URLs untuk Dart backend:
  // static const String baseUrl = 'http://localhost:8080'; // Jika server di localhost
  // static const String baseUrl = 'http://10.0.2.2:8080'; // Untuk Android emulator
  // static const String baseUrl = 'http://127.0.0.1:8080'; // Local server
  
  // Headers untuk request
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Register user
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: headers,
        body: jsonEncode({
          'username': username,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'],
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Terjadi kesalahan',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Koneksi ke server gagal. Pastikan backend Laragon sudah berjalan.',
      };
    }
  }

  // Login user
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: headers,
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'],
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Terjadi kesalahan',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Koneksi ke server gagal. Pastikan backend Laragon sudah berjalan.',
      };
    }
  }

  // Health check dengan detail error untuk Dart backend
  static Future<Map<String, dynamic>> checkServerHealth() async {
    try {
      print('🔍 Testing connection to Dart backend: $baseUrl');
      
      // Test dengan endpoint login yang ada (karena /health mungkin belum dibuat)
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: headers,
        body: jsonEncode({
          'username': 'raja',
          'password': '123456',
        }),
      ).timeout(const Duration(seconds: 5));
      
      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');
      
      return {
        'success': response.statusCode == 200 || response.statusCode == 403, // 403 = server running but wrong credentials
        'statusCode': response.statusCode,
        'body': response.body,
        'url': baseUrl,
        'note': response.statusCode == 403 ? 'Server running, wrong credentials' : 'Server response',
      };
    } catch (e) {
      print('❌ Connection error: $e');
      return {
        'success': false,
        'error': e.toString(),
        'url': baseUrl,
      };
    }
  }

  // Test multiple URLs untuk debugging Dart backend
  static Future<void> testConnections() async {
    final testUrls = [
      'http://192.168.18.237:8080',
      'http://192.168.18.237:3000',
      'http://192.168.18.237:8000',
      'http://localhost:8080',
      'http://localhost:3000',
      'http://localhost:8000',
      'http://10.0.2.2:8080', // Android emulator
      'http://10.0.2.2:3000',
      'http://127.0.0.1:8080',
      'http://127.0.0.1:3000',
    ];
    
    print('🔍 Testing multiple URLs untuk Dart backend...');
    
    for (final url in testUrls) {
      try {
        print('Testing: $url/login');
        // Test dengan endpoint login yang ada
        final response = await http.post(
          Uri.parse('$url/login'),
          headers: headers,
          body: jsonEncode({
            'username': 'raja',
            'password': '123456',
          }),
        ).timeout(const Duration(seconds: 3));
        
        print('✅ $url - Status: ${response.statusCode}');
        print('Response: ${response.body}');
      } catch (e) {
        print('❌ $url - Error: $e');
      }
    }
  }
}
