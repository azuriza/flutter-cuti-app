import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true; // Tambahkan ini di atas dalam State
  String? error;

  DateTime? _lastBackPressed; // ← Tambahkan di sini

  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  Future<void> login() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/login'),
      // Uri.parse('http://192.168.1.82:8000/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        final user = responseData['user'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseData['token']);
        await prefs.setString('name', user['name']);
        await prefs.setString('last_name', user['last_name']);
        await prefs.setString('employeeid', user['employeeid']);
        await prefs.setString('email', user['email']);

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } else {
      setState(() {
        error = 'Login gagal. Cek email/password.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _fadeIn,
        builder: (context, child) => Opacity(
          opacity: _fadeIn.value,
          child: child,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    'assets/logo.png',
                    height: 100,
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    "LOGIN HRMS UPI",
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 32),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      error!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Input Email Address",
                    labelStyle: TextStyle(color: Colors.black), 
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    ),
                    enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Input Password",
                    labelStyle: const TextStyle(color: Colors.black),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     TextButton(
                //       onPressed: () {},
                //       child: const Text("Belum punya akun? Daftar"),
                //     ),
                //     TextButton(
                //       onPressed: () {},
                //       child: const Text("Lupa password?"),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white, // warna teks jadi putih
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                child: Text(
                    '© 2025 UPI HRMS | All Right Reserved',
                    style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    ),
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
