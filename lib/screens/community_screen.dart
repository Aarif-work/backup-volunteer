import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLeaderboardPreview(),
            const SizedBox(height: 32),
            const Text('ANNOUNCEMENTS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary, letterSpacing: 1.2)),
            const SizedBox(height: 16),
            _buildPostCard('Weekend Food Drive', 'We need 5 more volunteers for the downtown distribution this Saturday.', 'Admin', '2h ago'),
            _buildPostCard('New Training Module', 'A new safety training module is available for all event leaders.', 'Foundation HQ', '1d ago'),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardPreview() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Top Contributors', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Icon(Icons.emoji_events, color: Colors.white, size: 24),
            ],
          ),
          const SizedBox(height: 20),
          _buildLeaderRow('1', 'Sarah Jenkins', '45h this month'),
          _buildLeaderRow('2', 'Mike Chen', '38h this month'),
          _buildLeaderRow('3', 'You', '32h this month'),
        ],
      ),
    );
  }

  Widget _buildLeaderRow(String rank, String name, String stats) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(rank, style: const TextStyle(color: Colors.white60, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(width: 16),
          CircleAvatar(radius: 14, backgroundColor: Colors.white24, child: Text(name[0], style: const TextStyle(fontSize: 10, color: Colors.white))),
          const SizedBox(width: 12),
          Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(stats, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildPostCard(String title, String body, String author, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 12, backgroundColor: AppTheme.primaryColor.withOpacity(0.1), child: const Icon(Icons.person, size: 12, color: AppTheme.primaryColor)),
              const SizedBox(width: 8),
              Text(author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const Spacer(),
              Text(time, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(body, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }
}
