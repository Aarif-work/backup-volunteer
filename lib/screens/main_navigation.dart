import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'expense_center.dart';
import 'profile_screen.dart';
import 'requests_screen.dart';
import 'student_location_screen.dart';
import '../theme/app_theme.dart';
import '../models/app_models.dart';

class MainNavigationContainer extends StatefulWidget {
  const MainNavigationContainer({super.key});

  @override
  State<MainNavigationContainer> createState() => _MainNavigationContainerState();
}

class _MainNavigationContainerState extends State<MainNavigationContainer> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    DashboardScreen(onNavigate: (index) {
      setState(() {
        _currentIndex = index;
      });
    }),
    const RequestsScreen(),
    const StudentLocationScreen(),
    const ExpenseCenterScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null && details.primaryVelocity! > 300) {
               if (_currentIndex != 0) {
                 setState(() => _currentIndex = 0);
               }
            }
          },
          child: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
        ),
        bottomNavigationBar: _buildPremiumNavBar(),
      ),
    );
  }

  Widget _buildPremiumNavBar() {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: globalPendingRequestsCount,
        builder: (context, count, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.grid_view_rounded, 'Home', 0),
              _buildNavItem(1, Icons.pending_actions_rounded, 'Requests', count),
              _buildNavItem(2, Icons.location_on_rounded, 'Location', 0),
              _buildNavItem(3, Icons.account_balance_wallet_rounded, 'Finance', 0),
              _buildNavItem(4, Icons.person_rounded, 'Profile', 0),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, int badgeCount) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon, 
                  color: isSelected ? Colors.black : Colors.grey[300],
                  size: 26,
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        badgeCount.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
            if (isSelected) 
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
