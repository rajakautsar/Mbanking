import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/api_config.dart';
import 'dashboard_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> login() async {
    setState(() => _isLoading = true);

<<<<<<< HEAD
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": usernameController.text,
          "password": passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == "success") {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(username: usernameController.text),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Login gagal")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
=======
   try {
  final response = await http.post(
    Uri.parse("http://192.168.18.237:8080/login"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "username": usernameController.text,
      "password": passwordController.text,
    }),
  );

  if (response.statusCode == 200) {
    // 🔥 Kalau login sukses, arahkan ke dashboard
    Navigator.pushReplacementNamed(context, '/dashboard');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Login gagal, periksa username/password")),
    );
  }
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Error: $e")),
  );
} finally {
      setState(() {
        _isLoading = false;
      });
>>>>>>> 7932c1c7d79a013a10b7e981d6326f11d0e4e375
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: Colors.blue[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_balance, size: 100, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                "BANK NUSANTARA",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 30),
=======
      backgroundColor: const Color(0xFFBEE5FF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                SizedBox(
                  height: 110,
                  width: 110,
                  child: Image.asset('assets/Logo_Nusantara.png'),
                ),
                const SizedBox(height: 18),
>>>>>>> 7932c1c7d79a013a10b7e981d6326f11d0e4e375

              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 14),

              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _isLoading ? null : login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Sign In", style: TextStyle(fontSize: 18)),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun? "),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    ),
                    child: const Text("Register"),
                  ),
<<<<<<< HEAD
                ],
              )
            ],
=======
                ),
                // 🔥 Tambahan tulisan "Belum punya akun?"
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Text("Belum punya akun? "),
    GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/register');
      },
      child: const Text(
        "Register",
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ],
),
              ],
            ),
>>>>>>> 7932c1c7d79a013a10b7e981d6326f11d0e4e375
          ),
        ),
      ),
    );
  }
}
