import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

import 'screens/dashboard_screen.dart';
import 'screens/transfer_screen.dart';
import 'screens/topup_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';


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
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),

        '/dashboard': (context) => const DashboardScreen(),
        '/transfer': (context) => const TransferScreen(),
        '/topup': (context) => const TopUpScreen(),
        '/history': (context) => const HistoryScreen(),
        '/settings': (context) => const SettingsScreen(),
        // ⚠️ dashboard tidak dimasukkan ke routes karena kita mau passing username

      },
    );
  }
}
