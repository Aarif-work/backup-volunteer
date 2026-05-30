import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import '../models/app_models.dart';

class StudentLocationScreen extends StatefulWidget {
  const StudentLocationScreen({super.key});

  @override
  State<StudentLocationScreen> createState() => _StudentLocationScreenState();
}

class _StudentLocationScreenState extends State<StudentLocationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final ScrollController _scrollController = ScrollController();
  String _selectedFilter = 'All';

  final List<StudentProfile> _students = [
    StudentProfile(
      id: 'STU001',
      name: 'Rahul Kumar',
      rollNumber: '101',
      className: 'Grade 10',
      photoUrl: 'https://i.pravatar.cc/150?u=STU001',
      currentLocation: StudentLocation.unknown,
      isPermittedToLeave: false,
    ),
    StudentProfile(
      id: 'STU042',
      name: 'Sneha Singh',
      rollNumber: '204',
      className: 'Grade 12',
      photoUrl: 'https://i.pravatar.cc/150?u=STU042',
      currentLocation: StudentLocation.hostel,
      isLocationOff: true,
    ),
    StudentProfile(
      id: 'STU112',
      name: 'Amit Patel',
      rollNumber: '312',
      className: 'Grade 11',
      photoUrl: 'https://i.pravatar.cc/150?u=STU112',
      currentLocation: StudentLocation.college,
    ),
    StudentProfile(
      id: 'STU088',
      name: 'Priya Sharma',
      rollNumber: '208',
      className: 'Grade 10',
      photoUrl: 'https://i.pravatar.cc/150?u=STU088',
      currentLocation: StudentLocation.home,
      isPermittedToLeave: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<StudentProfile> filteredStudents = _students.where((student) {
      if (_selectedFilter == 'All') return true;
      
      bool hasAlert = student.isLocationOff || (student.currentLocation == StudentLocation.unknown && !student.isPermittedToLeave);
      if (_selectedFilter.startsWith('Alerts')) return hasAlert;
      if (_selectedFilter.startsWith('Hostel')) return student.currentLocation == StudentLocation.hostel && !student.isLocationOff;
      if (_selectedFilter.startsWith('College')) return student.currentLocation == StudentLocation.college && !student.isLocationOff;
      if (_selectedFilter.startsWith('On Leave')) return student.currentLocation == StudentLocation.home && !student.isLocationOff;
      
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverHeader(),
          SliverToBoxAdapter(child: const SizedBox(height: 20)),
          _buildLiveStatusRow(),
          SliverToBoxAdapter(child: const SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildModernTrackingCard(filteredStudents[index]),
                childCount: filteredStudents.length,
              ),
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 180.0,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF000000),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
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
              child: const Text('STUDENT RADAR',
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
                    child: Icon(Icons.radar_rounded, size: 200, color: Colors.white.withOpacity(0.05)),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Live Radar',
                            style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
                          const SizedBox(height: 4),
                          const Text('Student Monitoring',
                            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildHeaderStat('Actively Tracked', '4', Icons.my_location_rounded, Colors.greenAccent),
                              const SizedBox(width: 24),
                              _buildHeaderStat('Critical Alerts', '2', Icons.warning_amber_rounded, Colors.redAccent),
                            ],
                          ),
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
    );
  }

  Widget _buildHeaderStat(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
          ],
        )
      ],
    );
  }

  Widget _buildLiveStatusRow() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          physics: const BouncingScrollPhysics(),
          children: [
            _buildStatusChip('All'),
            _buildStatusChip('Hostel (1)'),
            _buildStatusChip('College (1)'),
            _buildStatusChip('On Leave (1)'),
            _buildStatusChip('Alerts (2)'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300, width: 1.5),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))] : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ),
    );
  }

  Widget _buildModernTrackingCard(StudentProfile student) {
    bool hasAlert = student.isLocationOff || (student.currentLocation == StudentLocation.unknown && !student.isPermittedToLeave);
    
    // Determine colors
    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (student.isLocationOff) {
      statusColor = Colors.orange;
      statusIcon = Icons.gps_off_rounded;
      statusText = 'GPS Disabled';
    } else if (hasAlert) {
      statusColor = Colors.red;
      statusIcon = Icons.location_off_rounded;
      statusText = 'Out of Bound';
    } else {
      switch (student.currentLocation) {
        case StudentLocation.hostel:
          statusColor = Colors.green;
          statusIcon = Icons.home_rounded;
          statusText = 'In Hostel';
          break;
        case StudentLocation.college:
          statusColor = Colors.blue;
          statusIcon = Icons.school_rounded;
          statusText = 'In College';
          break;
        case StudentLocation.home:
          statusColor = Colors.purple;
          statusIcon = Icons.business_rounded;
          statusText = 'On Leave';
          break;
        default:
          statusColor = Colors.grey;
          statusIcon = Icons.help_outline_rounded;
          statusText = 'Unknown';
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: hasAlert ? Colors.red.withOpacity(0.1) : Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (hasAlert)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.red.withOpacity(_pulseController.value * 0.5),
                        width: 2,
                      ),
                    ),
                  );
                }
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: statusColor.withOpacity(0.3), width: 3),
                            image: DecorationImage(image: NetworkImage(student.photoUrl), fit: BoxFit.cover),
                          ),
                        ),
                        if (!student.isLocationOff)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                    boxShadow: [
                                      BoxShadow(color: statusColor.withOpacity(_pulseController.value), blurRadius: 10, spreadRadius: 2)
                                    ],
                                  ),
                                );
                              }
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(statusIcon, color: statusColor, size: 14),
                                    const SizedBox(width: 4),
                                    Text(statusText, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('Roll No: ${student.rollNumber} • ${student.className}', style: const TextStyle(color: AppTheme.secondaryText, fontSize: 13)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.access_time_rounded, size: 14, color: AppTheme.secondaryText),
                              const SizedBox(width: 4),
                              const Text('Updated 2m ago', style: TextStyle(color: AppTheme.secondaryText, fontSize: 11, fontWeight: FontWeight.w500)),
                              const Spacer(),
                              if (hasAlert)
                                const Text('ACTION REQUIRED', style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                if (hasAlert) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          child: const Icon(Icons.priority_high_rounded, color: Colors.white, size: 12),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            student.isLocationOff 
                              ? 'Location signal lost. Possible device switch off.' 
                              : 'Student breached expected parameter zone without active leave request.',
                            style: TextStyle(color: Colors.red.shade900, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            minimumSize: Size.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Contact', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
