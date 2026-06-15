import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/app_models.dart';
import 'notification_screen.dart';
import 'requests_screen.dart';
import 'student_directory_screen.dart';
import 'student_location_screen.dart';
import 'profile_screen.dart';
import 'parent_management_screen.dart';
import 'expense_center.dart';

class DashboardScreen extends StatelessWidget {
  final Function(int)? onNavigate;

  const DashboardScreen({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(),
                  const SizedBox(height: 8),
                  _buildAppModules(context),
                  const SizedBox(height: 16),
                  _buildStudentAlerts(context),
                  const SizedBox(height: 16),
                  _buildRecentNotifications(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      toolbarHeight: 65,
      backgroundColor: AppTheme.backgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      title: Row(
        children: [
          Image.asset('assets/hope3_logo.png', height: 32, errorBuilder: (context, error, stackTrace) => const Icon(Icons.volunteer_activism, color: AppTheme.primaryText)),
          const SizedBox(width: 8),
          const Text('Dashboard', style: TextStyle(color: AppTheme.primaryText, fontWeight: FontWeight.bold, fontSize: 22)),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen())),
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
              ],
            ),
            child: Stack(
              children: [
                const Icon(Icons.notifications_none_rounded, color: Colors.black, size: 24),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (onNavigate != null) {
              onNavigate!(4);
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
            }
          },
          child: Container(
            margin: const EdgeInsets.only(right: 24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
              ],
            ),
            child: const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good morning,',
          style: TextStyle(fontSize: 16, color: AppTheme.secondaryText, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 4),
        Text(
          'System Admin',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.primaryText, height: 1.1),
        ),
      ],
    );
  }

  Widget _buildAppModules(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.95,
          children: [
            _buildMenuTile(context, 'Requests', Icons.pending_actions_rounded, AppTheme.lavenderGradient, () {
               if (onNavigate != null) onNavigate!(1);
               else Navigator.push(context, MaterialPageRoute(builder: (context) => const RequestsScreen()));
            }),
            _buildMenuTile(context, 'Students', Icons.group_rounded, AppTheme.peachGradient, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentDirectoryScreen()))),
            _buildMenuTile(context, 'Location', Icons.location_on_rounded, AppTheme.mintGradient, () {
               if (onNavigate != null) onNavigate!(2);
               else Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentLocationScreen()));
            }),
            _buildMenuTile(context, 'Finance', Icons.account_balance_wallet_rounded, AppTheme.yellowGradient, () {
               if (onNavigate != null) onNavigate!(3);
               else Navigator.push(context, MaterialPageRoute(builder: (context) => const ExpenseCenterScreen()));
            }),
            _buildMenuTile(context, 'Parents', Icons.family_restroom_rounded, const LinearGradient(colors: [Color(0xFF89CFF0), Color(0xFFB0DFE5)]), () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ParentManagementScreen()))),
            _buildMenuTile(context, 'Reports', Icons.analytics_rounded, const LinearGradient(colors: [Color(0xFFFFB6C1), Color(0xFFFFC0CB)]), null),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuTile(BuildContext context, String title, IconData icon, LinearGradient gradient, VoidCallback? onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          // Soft premium environmental shadow tied to the primary color
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.08), // Made lighter as requested
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
          // Tight crisp shadow for button separation
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: gradient.colors.first.withOpacity(0.25),
          highlightColor: gradient.colors.first.withOpacity(0.1),
          child: Stack(
            children: [
              // Immersive elegant background wash gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        gradient.colors.first.withOpacity(0.2),
                        Colors.white.withOpacity(0.0),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0.0, 0.6],
                    ),
                  ),
                ),
              ),

              // Giant dramatic 'watermark' icon bleeding off the bottom right
              Positioned(
                bottom: -20,
                right: -25,
                child: Transform.rotate(
                  angle: -0.25,
                  child: Icon(
                    icon,
                    size: 110,
                    color: gradient.colors.first.withOpacity(0.08),
                  ),
                ),
              ),

              // Floating 3D crisp icon enclosure top-right
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: gradient.colors.first.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ShaderMask(
                    shaderCallback: (bounds) => gradient.createShader(bounds),
                    child: Icon(icon, color: Colors.white, size: 22),
                  ),
                ),
              ),

              // Super clean typography block bottom-left
              Positioned(
                bottom: 18,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter', // Sleek modern system font
                        fontWeight: FontWeight.w900, // Extra bold
                        fontSize: 18, // Increased size
                        color: AppTheme.primaryText,
                        letterSpacing: -0.2,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          'Tap to open',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryText.withOpacity(0.5),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 10,
                          color: AppTheme.primaryText.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentAlerts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'LOCATION ALERTS', 
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.secondaryText, letterSpacing: 1.5)
            ),
            GestureDetector(
              onTap: () {
                if (onNavigate != null) onNavigate!(2);
                else Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentLocationScreen()));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.peachAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('View Map', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.peachAccent)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildAlertStudentCard('Sneha Singh', 'STU042', 'Location Turned Off', Icons.gps_off_rounded, Colors.orange),
        _buildAlertStudentCard('Rahul Kumar', 'STU001', 'Out of Permitted Area', Icons.warning_rounded, Colors.red),
      ],
    );
  }

  Widget _buildAlertStudentCard(String name, String id, String alertType, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
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
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primaryText)),
                  const SizedBox(height: 4),
                  Text('$id • $alertType', style: const TextStyle(color: AppTheme.secondaryText, fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
             Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.secondaryText.withOpacity(0.5)),
        ],
      )
    );
  }

  Widget _buildRecentNotifications(BuildContext context) {
    final recentNotifs = [
      AppNotification(id: 'n1', title: 'Geofence Alert: Out of Area', message: 'Rahul Kumar is outside permitted area.', timestamp: DateTime.now().subtract(const Duration(minutes: 5)), icon: Icons.location_off_rounded, color: Colors.red),
      AppNotification(id: 'n2', title: 'Location Disabled', message: 'Sneha Singh has turned off location.', timestamp: DateTime.now().subtract(const Duration(hours: 1)), icon: Icons.gps_off_rounded, color: Colors.orange),
      AppNotification(id: 'n4', title: 'New Guidelines Update', message: 'Ensure volunteers review updated manuals.', timestamp: DateTime.now().subtract(const Duration(days: 1)), icon: Icons.info_outline_rounded, color: Colors.blue, isRead: true),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'RECENT NOTIFICATIONS', 
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.secondaryText, letterSpacing: 1.5)
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen())),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('See All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...recentNotifs.map((n) => _buildNotificationCard(n, context)),
      ],
    );
  }

  Widget _buildNotificationCard(AppNotification notification, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen())),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : notification.color.withOpacity(0.03),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: notification.isRead ? Colors.grey[100]! : notification.color.withOpacity(0.1)),
          boxShadow: notification.isRead 
            ? [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))] 
            : [BoxShadow(color: notification.color.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 6))],
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
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold,
                      fontSize: 14,
                      color: AppTheme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: TextStyle(
                      color: notification.isRead ? AppTheme.secondaryText : AppTheme.primaryText.withOpacity(0.8),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead) ...[
              const SizedBox(width: 8),
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: notification.color, shape: BoxShape.circle),
              )
            ]
          ],
        ),
      ),
    );
  }
}
