import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'report_center_screen.dart';
import 'student_directory_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildProfileHeader(context),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuickStats(),
                    const SizedBox(height: 32),
                    const Text('TOOLS & WORKSPACE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.secondaryText, letterSpacing: 1.5)),
                    const SizedBox(height: 16),
                    _buildToolGrid(context),
                    const SizedBox(height: 32),
                    const Text('ACCOUNT SETTINGS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.secondaryText, letterSpacing: 1.5)),
                    const SizedBox(height: 16),
                    _buildSettingRow(Icons.person_outline_rounded, 'Personal Details', 'Manage your contact info', Colors.blue),
                    _buildSettingRow(Icons.security_rounded, 'Security', 'Password & biometric login', Colors.orange),
                    _buildSettingRow(Icons.help_outline_rounded, 'Support', 'Contact foundation admin', Colors.green),
                    const SizedBox(height: 40),
                    _buildLogoutButton(context),
                    const SizedBox(height: 24),
                    const Center(
                      child: Text('HOPE3 Volunteer v1.2.0', style: TextStyle(color: AppTheme.secondaryText, fontSize: 11)),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF2C3E50),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('MY PROFILE', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
              const SizedBox(height: 40),
            ],
          ),
        ),
        Positioned(
          bottom: -40,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade100,
              backgroundImage: const NetworkImage('https://i.pravatar.cc/300?img=11'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          const Text('John Volunteer', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
          const Text('ID: HOPE3-2024-089', style: TextStyle(fontSize: 12, color: AppTheme.secondaryText, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }



  Widget _buildToolGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildToolCard(
          context,
          'Report\nCenter',
          Icons.auto_graph_rounded,
          Colors.indigo,
          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportCenterScreen())),
        ),
        _buildToolCard(
          context,
          'Student\nDirectory',
          Icons.people_alt_rounded,
          Colors.blue,
          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentDirectoryScreen())),
        ),
      ],
    );
  }

  Widget _buildToolCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primaryText, height: 1.2)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingRow(IconData icon, String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.secondaryText)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: () {},
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: const Text('LOG OUT', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2C3E50),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
    );
  }
}
