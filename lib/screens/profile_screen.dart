import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';
import 'report_center_screen.dart';
import 'student_directory_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 32),
            _buildActionList(context),
            const SizedBox(height: 32),
            _buildSettingsList(),
            const SizedBox(height: 48),
            _buildLogoutButton(context),
            const SizedBox(height: 24),
            const Text('HOPE3 Volunteer v1.2.0', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.yellowAction,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
          ),
          alignment: Alignment.center,
          child: const FaIcon(FontAwesomeIcons.userLarge, color: Colors.white, size: 36),
        ),
        const SizedBox(width: 20),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('John Volunteer', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
            Text('ID: HOPE3-2024-089', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TOOLS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary, letterSpacing: 1.2)),
        const SizedBox(height: 16),
        _buildMenuCard(
          'Report Center', 
          'Download financial audit logs', 
          Icons.file_copy_outlined, 
          AppTheme.primaryColor,
          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportCenterScreen())),
        ),
        _buildMenuCard(
          'Student Directory', 
          'View and manage student records', 
          Icons.people_outline, 
          Colors.indigo,
          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentDirectoryScreen())),
        ),
      ],
    );
  }

  Widget _buildSettingsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ACCOUNT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary, letterSpacing: 1.2)),
        const SizedBox(height: 16),
        _buildMenuCard('Personal Details', 'Edit your contact information', Icons.person_outline, Colors.teal, null),
        _buildMenuCard('Support', 'Contact foundation admin', Icons.help_outline, Colors.orange, null),
      ],
    );
  }

  Widget _buildMenuCard(String title, String sub, IconData icon, Color color, VoidCallback? onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(sub, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.logout, size: 18),
      label: const Text('LOGOUT'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[50],
        foregroundColor: Colors.red,
        elevation: 0,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
