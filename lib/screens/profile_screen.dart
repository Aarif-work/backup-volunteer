import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'report_center_screen.dart';
import 'student_directory_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverAppBar(
            floating: true,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xFFF8F9FA),
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text('My Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade100,
                      backgroundImage: const NetworkImage('https://i.pravatar.cc/300?img=11'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('John Volunteer', style: TextStyle(color: AppTheme.primaryText, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('ID: HOPE3-2024-089', style: TextStyle(color: AppTheme.secondaryText, fontSize: 14, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Text('TOOLS & WORKSPACE',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryText,
                        letterSpacing: 1.5)),
                const SizedBox(height: 16),
                _buildToolGrid(context),
                const SizedBox(height: 32),
                const Text('ACCOUNT SETTINGS',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryText,
                        letterSpacing: 1.5)),
                const SizedBox(height: 16),
                _buildSettingRow(context, Icons.person_outline_rounded, 'Personal Details',
                    'Manage your contact info', Colors.blue),
                _buildSettingRow(context, Icons.security_rounded, 'Security',
                    'Password & biometric login', Colors.orange),
                _buildSettingRow(context, Icons.help_outline_rounded, 'Support',
                    'Contact foundation admin', Colors.green),
                const SizedBox(height: 40),
                _buildLogoutButton(context),
                const SizedBox(height: 24),
                const Center(
                  child: Text('HOPE3 Volunteer v1.2.0',
                      style: TextStyle(
                          color: AppTheme.secondaryText, fontSize: 11)),
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
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
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ReportCenterScreen())),
        ),
        _buildToolCard(
          context,
          'Student\nDirectory',
          Icons.people_alt_rounded,
          Colors.blue,
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const StudentDirectoryScreen())),
        ),
      ],
    );
  }

  Widget _buildToolCard(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
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
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppTheme.primaryText,
                      height: 1.2)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingRow(
      BuildContext context, IconData icon, String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitle,
            style: const TextStyle(
                fontSize: 12, color: AppTheme.secondaryText)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title - Coming soon!'), behavior: SnackBarBehavior.floating),
          );
        },
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        },
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: const Text('LOG OUT',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A0A0A),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
    );
  }
}
