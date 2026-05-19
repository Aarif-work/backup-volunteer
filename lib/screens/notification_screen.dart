import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildNotificationGroup('Today'),
          _buildNotificationItem(
            'Expense Approved',
            'Your travel expense for food distribution (₹450) has been approved by admin.',
            Icons.check_circle_outline,
            Colors.green,
            '10:30 AM',
          ),
          _buildNotificationItem(
            'Attendance Pending',
            'Please mark attendance for Primary Science A session today.',
            Icons.warning_amber_rounded,
            Colors.orange,
            '09:00 AM',
          ),
          const SizedBox(height: 24),
          _buildNotificationGroup('Yesterday'),
          _buildNotificationItem(
            'New Announcement',
            'Foundation meeting at 5 PM tomorrow. Attendance requested.',
            Icons.campaign_outlined,
            AppTheme.primaryColor,
            '4:15 PM',
          ),
          _buildNotificationItem(
            'Refund Processed',
            'A refund of ₹2,450 has been transferred to your account.',
            Icons.account_balance_wallet_outlined,
            Colors.blue,
            '1:00 PM',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationGroup(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String body, IconData icon, Color color, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(time, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(body, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
