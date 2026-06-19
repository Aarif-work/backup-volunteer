import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_models.dart';
import 'parent_profile_screen.dart';

class ParentListScreen extends StatefulWidget {
  const ParentListScreen({super.key});

  @override
  State<ParentListScreen> createState() => _ParentListScreenState();
}

class _ParentListScreenState extends State<ParentListScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  final List<ParentProfile> _allParents = [
    ParentProfile(
      parentId: 'eedb48f8-4645-4ee4-aae2-7c28c896b062',
      userId: 'c7b4dc02-b9a2-40db-b396-9ccb375a6879',
      studentId: 'STU001',
      parentName: 'Test Parent',
      parentPhone: '9876543210',
      relation: 'father',
      isPrimary: 1,
      createdAt: DateTime.parse('2026-06-13T10:25:23'),
      updatedAt: DateTime.parse('2026-06-15T12:02:06'),
    ),
    ParentProfile(
      parentId: 'p2',
      userId: 'u2',
      studentId: 'STU042',
      parentName: 'Sarah Johnson',
      parentPhone: '555-0102',
      relation: 'mother',
      isPrimary: 1,
      createdAt: DateTime.parse('2026-05-10T10:00:00'),
      updatedAt: DateTime.parse('2026-06-10T10:00:00'),
    ),
  ];

  String _getStudentName(String id) {
    if (id == 'STU001') return 'Rahul Kumar';
    if (id == 'STU042') return 'Sneha Singh';
    return 'Unknown Student';
  }

  List<ParentProfile> _filteredParents = [];

  @override
  void initState() {
    super.initState();
    _filteredParents = _allParents;
  }

  void _onSearchChanged(String value) {
    setState(() {
      _filteredParents = _allParents
          .where((parent) =>
              parent.parentName.toLowerCase().contains(value.toLowerCase()) ||
              parent.parentPhone.contains(value))
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
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: Color(0xFFF8F9FA),
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text('Parents Directory', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
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
                  onChanged: _onSearchChanged,
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
                      Text(parent.parentName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryText)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.phone_rounded, size: 14, color: AppTheme.secondaryText),
                          const SizedBox(width: 4),
                          Text(parent.parentPhone, style: const TextStyle(color: AppTheme.secondaryText, fontSize: 13)),
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
                    parent.relation.toUpperCase(),
                    style: const TextStyle(color: AppTheme.mintAccent, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFEEEEEE)),
            const SizedBox(height: 12),
            const Text('LINKED STUDENT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.secondaryText, letterSpacing: 1.0)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.only(right: 12, top: 4, bottom: 4, left: 4),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(radius: 14, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${parent.studentId}')),
                  const SizedBox(width: 8),
                  Text(_getStudentName(parent.studentId), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
