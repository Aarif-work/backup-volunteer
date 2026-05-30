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
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF000000),
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final collapsed = constraints.maxHeight <=
                    kToolbarHeight + MediaQuery.of(context).padding.top + 10;
                return FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 14),
                  title: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: collapsed ? 1.0 : 0.0,
                    child: const Text(
                      'MY PROFILE',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2),
                    ),
                  ),
                  background: Container(
                    decoration:
                        const BoxDecoration(gradient: AppTheme.headerGradient),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: CircleAvatar(
                              radius: 46,
                              backgroundColor: Colors.grey.shade100,
                              backgroundImage: const NetworkImage(
                                  'https://i.pravatar.cc/300?img=11'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'John Volunteer',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'ID: HOPE3-2024-089',
                            style: TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
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
                _buildSettingRow(Icons.person_outline_rounded, 'Personal Details',
                    'Manage your contact info', Colors.blue),
                _buildSettingRow(Icons.security_rounded, 'Security',
                    'Password & biometric login', Colors.orange),
                _buildSettingRow(Icons.help_outline_rounded, 'Support',
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
      IconData icon, String title, String subtitle, Color color) {
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
