import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ReportCenterScreen extends StatelessWidget {
  const ReportCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF000000),
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final collapsed = constraints.maxHeight <= kToolbarHeight + MediaQuery.of(context).padding.top + 10;
                return FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 14),
                  title: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: collapsed ? 1.0 : 0.0,
                    child: const Text('REPORT CENTER',
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: AppTheme.headerGradient,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 50,
                          right: -30,
                          child: Icon(Icons.analytics_rounded, size: 200, color: Colors.white.withOpacity(0.05)),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Data Hub',
                                  style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
                                const SizedBox(height: 4),
                                const Text('Report Center',
                                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                const Text('Download and share foundation mission reports.',
                                  style: TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildReportCategory('Financial Reports'),
                const SizedBox(height: 12),
                _buildReportCard('Expense Detailed History', 'Itemized records (Excel)', Icons.table_view, Colors.green),
                _buildReportCard('Refund Status Report', 'Pending vs Processed', Icons.account_balance_wallet, Colors.blue),
                
                const SizedBox(height: 32),
                _buildReportCategory('Activity Reports'),
                const SizedBox(height: 12),
                _buildReportCard('Mission Log Summary', 'Volunteer hours & activities', Icons.history, Colors.purple),
                _buildReportCard('Student Request Summary', 'Trends in leave & fee assistance', Icons.assessment_outlined, Colors.orange),
                
                const SizedBox(height: 48),
                _buildInfoBox(),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
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
