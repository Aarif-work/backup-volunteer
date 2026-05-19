import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_models.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<StudentRequest> _requests = [
    StudentRequest(
      id: 'r1',
      studentName: 'Rahul Kumar',
      studentId: 'STU001',
      type: RequestType.leave,
      description: 'Requesting 2 days leave for sister\'s wedding.',
      date: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    StudentRequest(
      id: 'r2',
      studentName: 'Sneha Singh',
      studentId: 'STU042',
      type: RequestType.fee,
      description: 'Requesting assistance for Term 2 library fees (₹500).',
      date: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    StudentRequest(
      id: 'r3',
      studentName: 'Amit Patel',
      studentId: 'STU112',
      type: RequestType.achievement,
      description: 'Won 1st prize in Zonal Science Fair. Uploading certificate.',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Student Requests'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader('PENDING APPROVALS'),
          ..._requests.where((r) => r.status == RequestStatus.pending).map((r) => _buildRequestCard(r)),
          const SizedBox(height: 32),
          _buildSectionHeader('ACTION HISTORY'),
          ..._requests.where((r) => r.status != RequestStatus.pending).map((r) => _buildRequestCard(r)),
          const SizedBox(height: 24),
          _buildSectionHeader('SYSTEM NOTIFICATIONS'),
          _buildNotificationItem(
            'Expense Approved',
            'Your travel expense for food distribution (₹450) has been approved.',
            Icons.check_circle_outline,
            Colors.green,
            '10:30 AM',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 1.1),
      ),
    );
  }

  Widget _buildRequestCard(StudentRequest request) {
    IconData typeIcon;
    Color typeColor;
    switch (request.type) {
      case RequestType.leave:
        typeIcon = Icons.calendar_today_rounded;
        typeColor = Colors.orange;
        break;
      case RequestType.fee:
        typeIcon = Icons.payments_outlined;
        typeColor = Colors.blue;
        break;
      case RequestType.achievement:
        typeIcon = Icons.emoji_events_outlined;
        typeColor = Colors.purple;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: typeColor.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(typeIcon, color: typeColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.studentName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text('${request.type.name.toUpperCase()} • ${request.studentId}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                  ],
                ),
              ),
              if (request.status != RequestStatus.pending)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: request.status == RequestStatus.accepted ? Colors.green[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    request.status.name.toUpperCase(),
                    style: TextStyle(color: request.status == RequestStatus.accepted ? Colors.green : Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(request.description, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, height: 1.4)),
          if (request.status == RequestStatus.pending) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => setState(() => request.status = RequestStatus.rejected),
                    icon: const Icon(Icons.close, size: 18, color: Colors.red),
                    label: const Text('Reject', style: TextStyle(color: Colors.red)),
                  ),
                ),
                Container(width: 1, height: 24, color: Colors.grey[200]),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => setState(() => request.status = RequestStatus.accepted),
                    icon: const Icon(Icons.check, size: 18, color: Colors.green),
                    label: const Text('Accept', style: TextStyle(color: Colors.green)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String body, IconData icon, Color color, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                Text(body, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 9)),
        ],
      ),
    );
  }
}
