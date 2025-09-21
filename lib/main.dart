import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nusantara Bank',
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      theme: ThemeData(primarySwatch: Colors.blue),
=======
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Routing aplikasi
>>>>>>> 7932c1c7d79a013a10b7e981d6326f11d0e4e375
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        // ⚠️ dashboard tidak dimasukkan ke routes karena kita mau passing username
      },
    );
  }
}
