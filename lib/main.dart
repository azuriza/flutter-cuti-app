import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';
import 'splash_screen.dart'; // Tambah ini

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Cuti',
      theme: ThemeData(primarySwatch: Colors.orange),
      initialRoute: '/splash', // Ubah jadi splash dulu
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/splash': (context) => const SplashScreen(),
      },
    );
  }
}