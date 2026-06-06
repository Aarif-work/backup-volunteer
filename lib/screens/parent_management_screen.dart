import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_models.dart';
import 'student_directory_screen.dart';

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

  void _showParentDetails(BuildContext context, ParentProfile parent) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ParentDetailBottomSheet(parent: parent, getStudentName: _getStudentName),
    );
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
      onTap: () => _showParentDetails(context, parent),
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
        child: Row(
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
      ),
    );
  }
}

class ParentDetailBottomSheet extends StatelessWidget {
  final ParentProfile parent;
  final String Function(String) getStudentName;

  const ParentDetailBottomSheet({required this.parent, required this.getStudentName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! > 300) {
          Navigator.maybePop(context);
        }
      },
      child: Container(
      decoration: const BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.all(24).copyWith(bottom: MediaQuery.of(context).padding.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(gradient: AppTheme.lavenderGradient, shape: BoxShape.circle),
                child: const Icon(Icons.person_rounded, color: AppTheme.lavenderAccent, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(parent.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
                    const SizedBox(height: 4),
                    Text('Parent ID: ${parent.id}', style: const TextStyle(fontSize: 14, color: AppTheme.secondaryText)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text('CONTACT INFORMATION', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.secondaryText, letterSpacing: 1.5)),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.phone_rounded, 'Phone', parent.contactNumber),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.email_rounded, 'Email', parent.email),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.location_on_rounded, 'Address', parent.address),
          const SizedBox(height: 32),
          const Text('LINKED STUDENTS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.secondaryText, letterSpacing: 1.5)),
          const SizedBox(height: 16),
          ...parent.studentIds.map((id) => _buildStudentCard(id, context)),
           const SizedBox(height: 32),
          if (parent.activityHistory.isNotEmpty) ...[
            const Text('ACTIVITY HISTORY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.secondaryText, letterSpacing: 1.5)),
            const SizedBox(height: 16),
            ...parent.activityHistory.map((activity) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.history_rounded, size: 16, color: AppTheme.secondaryText),
                  const SizedBox(width: 8),
                  Text(activity, style: const TextStyle(color: AppTheme.primaryText, fontSize: 14)),
                ],
              ),
            )),
          ]
        ],
      ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 18, color: AppTheme.secondaryText),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.secondaryText)),
            Text(value, style: const TextStyle(fontSize: 14, color: AppTheme.primaryText, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget _buildStudentCard(String studentId, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Push the actual student screen
        // But to avoid infinite loop, we can just push. If they click parent from there, it will pop.
        final mockStudent = StudentProfile(
          id: studentId,
          name: getStudentName(studentId),
          rollNumber: '2024-X-xx',
          className: 'RCD X',
          photoUrl: '',
        );
        Navigator.push(context, MaterialPageRoute(builder: (_) => StudentProfileDetailScreen(
          student: mockStudent, 
          bgColor: const Color(0xFFBCE1EB),
          isFromParent: true,
        )));
      },
      child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(gradient: AppTheme.peachGradient, shape: BoxShape.circle),
            child: const Icon(Icons.school_rounded, color: AppTheme.peachAccent, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(getStudentName(studentId), style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
                Text('ID: $studentId', style: const TextStyle(fontSize: 12, color: AppTheme.secondaryText)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppTheme.secondaryText),
        ],
      ),
      ),
    );
  }
}
