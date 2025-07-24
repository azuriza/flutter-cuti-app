import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String fullName = '';
  int _selectedIndex = 0;

  List<Widget> _pages() => [
    DashboardContent(fullName: fullName),
    Placeholder(color: Colors.blue),
    AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name') ?? '';
    final lastName = prefs.getString('last_name') ?? '';
    setState(() {
      fullName = '$name $lastName';
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
    return WillPopScope(
      onWillPop: () async {
        await _logout(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Ini yang menghilangkan panah back
          title: Row(
            children: [
              Image.asset(
                'assets/logo.png',
                height: 32, // ukuran logo
              ),
              const SizedBox(width: 12),
              const Text(
                "UPI HRMS",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _logout(context),
              tooltip: 'Logout',
            )
          ],
        ),
        body: SafeArea(
          child: _pages()[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'Ajukan Cuti',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Akun',
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================
// Dashboard Content (List Version)
// ===========================
class DashboardContent extends StatelessWidget {
  final String fullName;
  const DashboardContent({super.key, required this.fullName});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          fullName.isEmpty ? "WELCOME!" : "WELCOME $fullName!",
          style: const TextStyle(fontSize: 18),
        ),
        const Divider(height: 24),
        _buildMenuItem(
          icon: Icons.assignment,
          label: "Ajukan Cuti",
          onTap: () {
            // Navigasi ke tab 1
          },
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          icon: Icons.history,
          label: "Riwayat Cuti",
          onTap: () {
            // Navigasi ke riwayat cuti
          },
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          icon: Icons.person,
          label: "Akun Saya",
          onTap: () {
            // Navigasi ke tab 2
          },
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          icon: Icons.logout,
          label: "Logout",
          onTap: () {
            // Tambahkan aksi logout jika diperlukan
          },
        ),
      ],
    );
  }

  static Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 30, color: Colors.orange),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ===========================
// Dashboard Content
// ===========================
/*class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _buildMenuItem(
            icon: Icons.assignment,
            label: "Ajukan Cuti",
            onTap: () {
              // Navigasi atau ubah tab ke 1
              // Kamu bisa modif untuk pakai callback kalau butuh
            },
          ),
          _buildMenuItem(
            icon: Icons.history,
            label: "Riwayat Cuti",
            onTap: () {
              // Navigasi ke riwayat cuti
            },
          ),
          _buildMenuItem(
            icon: Icons.person,
            label: "Akun Saya",
            onTap: () {
              // Navigasi ke tab ke-2
            },
          ),
          _buildMenuItem(
            icon: Icons.logout,
            label: "Logout",
            onTap: () {
              // Logout bisa langsung panggil method jika dibutuhkan
            },
          ),
        ],
      ),
    );
  }

  static Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}*/