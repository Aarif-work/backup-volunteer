import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: Color(0xFFF8F9FA),
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text('Attendance Log', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text('Review and manage daily attendance records.', style: TextStyle(color: AppTheme.secondaryText, fontSize: 14)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(25),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSessionCard('Primary Science A', '9:30 AM - 11:30 AM', 'Room 204', true),
                _buildSessionCard('Secondary Math B', '1:00 PM - 3:00 PM', 'Room 105', false),
                const SizedBox(height: 32),
                const Text('UPCOMING SESSIONS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary, letterSpacing: 1.2)),
                const SizedBox(height: 16),
                _buildUpcomingItem('Health Workshop', 'Tomorrow, 10:00 AM'),
                _buildUpcomingItem('Art Class', 'Friday, 2:00 PM'),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(String title, String time, String location, bool active) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: active ? Border.all(color: AppTheme.primaryColor.withOpacity(0.3), width: 2) : Border.all(color: Colors.grey[100]!),
        boxShadow: active ? [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8))] : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: active ? AppTheme.primaryColor : Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                child: Text(active ? 'LIVE NOW' : 'SCHEDULED', style: TextStyle(color: active ? Colors.white : Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const Icon(Icons.more_horiz, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: AppTheme.textSecondary),
              const SizedBox(width: 6),
              Text(time, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
              const SizedBox(width: 16),
              const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textSecondary),
              const SizedBox(width: 6),
              Text(location, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: active ? AppTheme.primaryColor : Colors.grey[100],
              foregroundColor: active ? Colors.white : Colors.grey[600],
              elevation: 0,
            ),
            child: Text(active ? 'MARK ATTENDANCE' : 'VIEW DETAILS'),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingItem(String title, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[100]!)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppTheme.primaryLight, shape: BoxShape.circle),
            child: const Icon(Icons.event, color: AppTheme.primaryColor, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(date, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
        ],
      ),
    );
  }
}
