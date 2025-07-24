import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String fullName = '';
  String about = '';

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name') ?? '';
    final lastName = prefs.getString('last_name') ?? '';
    final empid = prefs.getString('employeeid') ?? '';
    final email = prefs.getString('email') ?? '';
    setState(() {
      fullName = '$name $lastName';
      about = '$empid | $email';
    });
  }

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Akun Saya"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
        //   const Icon(Icons.account_circle, size: 100, color: Colors.orange),
        //   const SizedBox(height: 8),
          Text(
            fullName.isEmpty ? "Nama Pengguna" : fullName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            about.isEmpty ? "-" : about,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.orange),
                  title: const Text("Ubah Profil"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Arahkan ke halaman ubah profil
                  },
                ),
                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined, color: Colors.grey),
                  title: const Text("Kebijakan dan Privasi"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigasi ke halaman privasi
                  },
                ),
                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.grey),
                  title: const Text("Tentang Aplikasi"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigasi ke halaman tentang
                  },
                ),
                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text("Sign Out"),
                  onTap: () => _logout(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "v.1.0.0",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
