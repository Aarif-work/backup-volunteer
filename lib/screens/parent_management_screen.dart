import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_models.dart';
import 'student_directory_screen.dart';
import 'parent_profile_screen.dart';

class ParentManagementScreen extends StatefulWidget {
  const ParentManagementScreen({super.key});

  @override
  State<ParentManagementScreen> createState() => _ParentManagementScreenState();
}

class _ParentManagementScreenState extends State<ParentManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Mock Data
  final List<ParentProfile> _allParents = [
    ParentProfile(
      id: 'p1',
      name: 'Michael Smith',
      contactNumber: '+1 555-0101',
      email: 'michael.smith@example.com',
      address: '123 Main St, Springfield',
      studentIds: ['s1', 's2'],
      activityHistory: ['Attended PTA meeting', 'Called regarding leave'],
    ),
    ParentProfile(
      id: 'p2',
      name: 'Sarah Johnson',
      contactNumber: '+1 555-0102',
      email: 'sarah.j@example.com',
      address: '456 Oak Ave, Springfield',
      studentIds: ['s3'],
      activityHistory: ['Submitted fee receipt'],
    ),
    ParentProfile(
      id: 'p3',
      name: 'David Brown',
      contactNumber: '+1 555-0103',
      email: 'david.b@example.com',
      address: '789 Pine Rd, Springfield',
      studentIds: ['s4'],
      activityHistory: [],
    ),
  ];

  // Helper method to get mock student names
  String _getStudentName(String id) {
    if (id == 's1') return 'Alice Smith';
    if (id == 's2') return 'Bob Smith';
    if (id == 's3') return 'Charlie Johnson';
    if (id == 's4') return 'Diana Brown';
    return 'Unknown Student';
  }

  List<ParentProfile> _filteredParents = [];

  @override
  void initState() {
    super.initState();
    _filteredParents = _allParents;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _filteredParents = _allParents
          .where((parent) =>
              parent.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
              parent.contactNumber.contains(_searchController.text))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! > 300) {
          Navigator.maybePop(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 180.0,
              floating: false,
              pinned: true,
              backgroundColor: AppTheme.backgroundColor,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.primaryText),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 50, bottom: 16),
              title: const Text(
                'Parent Management',
                style: TextStyle(color: AppTheme.primaryText, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.lavenderAccent.withOpacity(0.1),
                      AppTheme.backgroundColor,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      top: -20,
                      child: Icon(Icons.family_restroom_rounded, size: 200, color: AppTheme.lavenderAccent.withOpacity(0.05)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search parents by name or contact...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search_rounded, color: AppTheme.secondaryText),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final parent = _filteredParents[index];
                  return _buildParentCard(parent);
                },
                childCount: _filteredParents.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
      ),
    );
  }

  Widget _buildParentCard(ParentProfile parent) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ParentProfileScreen(
          parent: parent,
          getStudentName: _getStudentName,
        )));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    gradient: AppTheme.lavenderGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_rounded, color: AppTheme.lavenderAccent),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(parent.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryText)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.phone_rounded, size: 14, color: AppTheme.secondaryText),
                          const SizedBox(width: 4),
                          Text(parent.contactNumber, style: const TextStyle(color: AppTheme.secondaryText, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.mintAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${parent.studentIds.length} Student${parent.studentIds.length > 1 ? 's' : ''}',
                    style: const TextStyle(color: AppTheme.mintAccent, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (parent.studentIds.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFEEEEEE)),
              const SizedBox(height: 12),
              const Text('LINKED STUDENTS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.secondaryText, letterSpacing: 1.0)),
              const SizedBox(height: 12),
              SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: parent.studentIds.length,
                  itemBuilder: (context, idx) {
                    final sId = parent.studentIds[idx];
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.only(right: 12, top: 4, bottom: 4, left: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(radius: 14, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=$sId')),
                          const SizedBox(width: 8),
                          Text(_getStudentName(sId), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
