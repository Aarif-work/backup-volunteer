import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_models.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<AppNotification> _notifications = [
    AppNotification(
      id: 'n1',
      title: 'Geofence Alert: Out of Area',
      message: 'Student Rahul Kumar (STU001) is outside the permitted area without leave approval.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      icon: Icons.location_off_rounded,
      color: Colors.red,
    ),
    AppNotification(
      id: 'n2',
      title: 'Location Services Disabled',
      message: 'Sneha Singh (STU042) has turned off location services.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      icon: Icons.gps_off_rounded,
      color: Colors.orange,
    ),
    AppNotification(
      id: 'n3',
      title: 'Geofence Alert: Out of Area',
      message: 'Amit Patel (STU112) is outside the permitted area.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      icon: Icons.location_off_rounded,
      color: Colors.red,
    ),
    AppNotification(
      id: 'n4',
      title: 'Welcome to Hope3',
      message: 'New volunteer guidelines have been updated in the portal.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      icon: Icons.info_outline_rounded,
      color: Colors.blue,
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all read', style: TextStyle(color: Colors.blue, fontSize: 13)),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _buildNotificationCard(notification);
        },
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : notification.color.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: notification.isRead ? Colors.grey[100]! : notification.color.withOpacity(0.1)),
        boxShadow: notification.isRead 
          ? [] 
          : [BoxShadow(color: notification.color.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: notification.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(notification.icon, color: notification.color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold,
                          fontSize: 15,
                          color: AppTheme.primaryText,
                        ),
                      ),
                    ),
                    Text(
                      _formatTimestamp(notification.timestamp),
                      style: const TextStyle(color: AppTheme.secondaryText, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: TextStyle(
                    color: notification.isRead ? AppTheme.secondaryText : AppTheme.primaryText.withOpacity(0.8),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
