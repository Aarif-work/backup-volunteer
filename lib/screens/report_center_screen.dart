import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ReportCenterScreen extends StatelessWidget {
  const ReportCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Report Center'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Download and share foundation mission reports.',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 32),
            _buildReportCategory('Financial Reports'),
            const SizedBox(height: 12),
            _buildReportCard('Expense Detailed History', 'Itemized expense records (Excel)', Icons.table_view, Colors.green),
            _buildReportCard('Refund Status Report', 'Pending vs Processed refunds', Icons.account_balance_wallet, Colors.blue),
            
            const SizedBox(height: 32),
            _buildReportCategory('Activity Reports'),
            const SizedBox(height: 12),
            _buildReportCard('Mission Log Summary', 'Volunteer hours and activities', Icons.history, Colors.purple),
            _buildReportCard('Student Request Summary', 'Trends in leave and fee assistance', Icons.assessment_outlined, Colors.orange),
            
            const SizedBox(height: 48),
            _buildInfoBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCategory(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppTheme.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildReportCard(String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download_for_offline, color: AppTheme.primaryColor),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: AppTheme.primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Reports exclude media files to ensure efficient sharing between foundation stakeholders.',
              style: TextStyle(fontSize: 12, color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
