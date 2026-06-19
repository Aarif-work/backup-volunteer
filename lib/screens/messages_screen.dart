import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final List<MessageModel> _messages = [
    MessageModel(
      messageId: 'e141a91d-2ce6-479f-b91f-c20eac1a7d0b',
      studentId: 'STU001',
      senderId: 'STU001',
      message: 'Going to Koviloor for the weekend.',
      isRead: true,
      sentAt: DateTime.now().subtract(const Duration(minutes: 15)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    MessageModel(
      messageId: 'm2',
      studentId: 'STU042',
      senderId: 'STU042',
      message: 'Just going to the nearby shop, will be back in 20 mins.',
      isRead: false,
      sentAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    MessageModel(
      messageId: 'm3',
      studentId: 'STU112',
      senderId: 'STU112',
      message: 'Going home for Diwali.',
      isRead: true,
      sentAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  String _formatDateTime(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    int hour = date.hour;
    String amPm = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;
    String minute = date.minute.toString().padLeft(2, '0');
    return '${date.day} ${months[date.month - 1]} • $hour:$minute $amPm';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Group Updates', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final msg = _messages[index];
          return _buildMessageCard(msg);
        },
      ),
    );
  }

  Widget _buildMessageCard(MessageModel msg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8)),
        ],
        border: msg.isRead ? null : Border.all(color: AppTheme.peachAccent.withOpacity(0.5), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${msg.studentId}'),
                  ),
                  const SizedBox(width: 12),
                  Text('Student • ${msg.studentId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              Text(
                _formatDateTime(msg.sentAt),
                style: const TextStyle(color: AppTheme.secondaryText, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            msg.message,
            style: const TextStyle(color: AppTheme.primaryText, fontSize: 15, height: 1.4),
          ),
        ],
      ),
    );
  }
}
