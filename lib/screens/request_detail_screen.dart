import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_models.dart';

class RequestDetailScreen extends StatelessWidget {
  final StudentRequest request;
  final VoidCallback onAction;

  const RequestDetailScreen({
    super.key,
    required this.request,
    required this.onAction,
  });

  String _formatDateTime(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    int hour = date.hour;
    String amPm = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;
    String minute = date.minute.toString().padLeft(2, '0');
    return '${date.day} ${months[date.month - 1]} ${date.year} • $hour:$minute $amPm';
  }

  @override
  Widget build(BuildContext context) {
    bool isPending = request.status == RequestStatus.pending;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Request Details', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStudentHeader(context),
              const SizedBox(height: 32),
              _buildDetailsCard(),
              const SizedBox(height: 24),
              _buildNoteCard(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomSheet: isPending ? _buildBottomActions(context) : null,
    );
  }

  Widget _buildStudentHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${request.studentId}'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request.studentName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryText),
              ),
              const SizedBox(height: 4),
              Text(
                '${request.type.name} Request',
                style: const TextStyle(fontSize: 14, color: AppTheme.secondaryText, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDateTime(request.date),
                style: const TextStyle(fontSize: 12, color: AppTheme.secondaryText),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: request.status == RequestStatus.pending
                ? Colors.orange.withOpacity(0.1)
                : request.status == RequestStatus.accepted
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            request.status.name.toUpperCase(),
            style: TextStyle(
              color: request.status == RequestStatus.pending
                  ? Colors.orange
                  : request.status == RequestStatus.accepted
                      ? Colors.green
                      : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsCard() {
    String cardTitle;
    IconData icon;
    Color color;
    Widget details;

    switch (request.type) {
      case RequestType.leave:
        cardTitle = 'Leave Details';
        icon = Icons.calendar_today_rounded;
        color = Colors.orange;
        details = Row(
          children: [
            _buildInfoItem('From', '22 May 2025'),
            const SizedBox(width: 40),
            _buildInfoItem('To', '24 May 2025'),
          ],
        );
        break;
      case RequestType.fee:
        cardTitle = 'Fee Assistance Details';
        icon = Icons.payments_outlined;
        color = Colors.blue;
        details = Row(
          children: [
            _buildInfoItem('Amount Requested', '₹500'),
            const SizedBox(width: 40),
            _buildInfoItem('Category', 'Library Fees'),
          ],
        );
        break;
      case RequestType.achievement:
        cardTitle = 'Achievement Verification';
        icon = Icons.emoji_events_outlined;
        color = Colors.purple;
        details = Row(
          children: [
            _buildInfoItem('Category', 'Science Fair'),
            const SizedBox(width: 40),
            _buildInfoItem('Position', '1st Place'),
          ],
        );
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Text(cardTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 20),
          details,
          const SizedBox(height: 20),
          const Text('Description', style: TextStyle(fontSize: 11, color: AppTheme.secondaryText, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            request.description,
            style: const TextStyle(fontSize: 14, color: AppTheme.primaryText, height: 1.5, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.secondaryText, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
      ],
    );
  }

  Widget _buildNoteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Student Note', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          const Text(
            'Please approve my leave request.',
            style: TextStyle(fontSize: 14, color: AppTheme.primaryText, height: 1.5),
          ),
        ],
      ),
    );
  }


  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                request.status = RequestStatus.rejected;
                onAction();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close_rounded, size: 18),
              label: const Text('Reject', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5252),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                request.status = RequestStatus.accepted;
                onAction();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check_rounded, size: 18),
              label: const Text('Approve', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
