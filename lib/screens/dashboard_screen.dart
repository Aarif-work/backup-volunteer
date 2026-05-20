import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'notification_screen.dart';
import 'student_directory_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 32),
                _buildQuickStats(context),
                const SizedBox(height: 32),
                const Text(
                  'PRIORITY TASKS', 
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.secondaryText, letterSpacing: 1.5)
                ),
                const SizedBox(height: 20),
                _buildActionCard(
                  context,
                  'Student Requests',
                  '3 pending approvals',
                  Icons.pending_actions_rounded,
                  AppTheme.yellowGradient,
                  AppTheme.yellowAccent,
                  () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen())),
                ),
                _buildActionCard(
                  context,
                  'Finance Review',
                  '2 reimbursements ready',
                  Icons.account_balance_wallet_rounded,
                  AppTheme.mintGradient,
                  AppTheme.mintAccent,
                  null,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/hope3_logo.png', height: 44),
              const SizedBox(height: 16),
              const Text('Welcome back,', style: TextStyle(color: AppTheme.secondaryText, fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                'John Volunteer',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primaryText),
              ),
            ],
        ),
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppTheme.warmSunsetGradient,
            boxShadow: [
              BoxShadow(color: AppTheme.pinkAccent.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
            ],
          ),
          child: const Center(child: Icon(Icons.person, color: Colors.white, size: 28)),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Row(
      children: [
        _buildStatItem('3', 'Requests', AppTheme.lavenderGradient, AppTheme.lavenderAccent, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()))),
        const SizedBox(width: 16),
        _buildStatItem('42', 'Students', AppTheme.peachGradient, AppTheme.peachAccent, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentDirectoryScreen()))),
      ],
    );
  }

  Widget _buildStatItem(String val, String label, LinearGradient gradient, Color accentColor, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(color: accentColor.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 10)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(val, style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: accentColor)),
              const SizedBox(height: 2),
              Text(label, style: TextStyle(fontSize: 14, color: accentColor.withOpacity(0.8), fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, String subtitle, IconData icon, LinearGradient gradient, Color accentColor, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: const Offset(0, 12)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(gradient: gradient, shape: BoxShape.circle),
              child: Icon(icon, color: accentColor, size: 24),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryText)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: AppTheme.secondaryText, fontSize: 13)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: AppTheme.secondaryText.withOpacity(0.5), size: 18),
          ],
        ),
      ),
    );
  }
}
