import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_models.dart';
import 'donor_profile_screen.dart';

class DonorManagementScreen extends StatefulWidget {
  const DonorManagementScreen({super.key});

  @override
  State<DonorManagementScreen> createState() => _DonorManagementScreenState();
}

class _DonorManagementScreenState extends State<DonorManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Mock Data
  final List<DonorProfile> _allDonors = [
    DonorProfile(
      id: 'D001',
      name: 'Eleanor Vance',
      contactNumber: '+1 555-0201',
      email: 'eleanor.v@example.com',
      photoUrl: 'https://i.pravatar.cc/150?img=5',
      studentIds: ['s1', 's2', 's3'],
      donationHistory: [
        DonationRecord(id: 'dn1', amount: 5000.0, date: DateTime(2024, 1, 15), purpose: 'Annual Sponsorship'),
        DonationRecord(id: 'dn2', amount: 1500.0, date: DateTime(2024, 5, 20), purpose: 'Books and Supplies'),
      ],
      notes: 'Prefers annual updates on student progress.',
    ),
    DonorProfile(
      id: 'D002',
      name: 'Robert Fox',
      contactNumber: '+1 555-0202',
      email: 'robert.f@example.com',
      photoUrl: 'https://i.pravatar.cc/150?img=11',
      studentIds: ['s4'],
      donationHistory: [
        DonationRecord(id: 'dn3', amount: 2000.0, date: DateTime(2024, 3, 10), purpose: 'General Fund'),
      ],
      notes: 'Interested in sponsoring another student next year.',
    ),
    DonorProfile(
      id: 'D003',
      name: 'Sophia Martinez',
      contactNumber: '+1 555-0203',
      email: 'sophia.m@example.com',
      photoUrl: 'https://i.pravatar.cc/150?img=9',
      studentIds: ['s5'],
      donationHistory: [
        DonationRecord(id: 'dn4', amount: 1000.0, date: DateTime(2024, 2, 28), purpose: 'Library Expansion'),
      ],
      notes: 'Wants updates on library construction.',
    ),
    DonorProfile(
      id: 'D004',
      name: 'William Taylor',
      contactNumber: '+1 555-0204',
      email: 'william.t@example.com',
      photoUrl: 'https://i.pravatar.cc/150?img=14',
      studentIds: ['s6', 's7'],
      donationHistory: [
        DonationRecord(id: 'dn5', amount: 3500.0, date: DateTime(2024, 4, 12), purpose: 'Computer Lab Equipment'),
      ],
      notes: 'Invited to the annual technology fair.',
    ),
  ];

  // Helper method to get mock student names
  String _getStudentName(String id) {
    if (id == 's1') return 'Alice Smith';
    if (id == 's2') return 'Bob Smith';
    if (id == 's3') return 'Charlie Johnson';
    if (id == 's4') return 'Diana Brown';
    if (id == 's5') return 'Ethan Davis';
    if (id == 's6') return 'Fiona Davis';
    if (id == 's7') return 'George Wilson';
    return 'Unknown Student';
  }

  List<DonorProfile> _filteredDonors = [];

  @override
  void initState() {
    super.initState();
    _filteredDonors = _allDonors;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _filteredDonors = _allDonors
          .where((donor) =>
              donor.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
              donor.contactNumber.contains(_searchController.text))
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
            const SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: Color(0xFFF8F9FA),
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              title: Text('Donor Management', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
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
                      hintText: 'Search donors by name...',
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
                    final donor = _filteredDonors[index];
                    return _buildDonorCard(donor);
                  },
                  childCount: _filteredDonors.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildDonorCard(DonorProfile donor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => DonorProfileScreen(
          donor: donor,
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
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(donor.photoUrl),
                  backgroundColor: AppTheme.peachAccent.withOpacity(0.2),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(donor.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryText)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.email_rounded, size: 14, color: AppTheme.secondaryText),
                          const SizedBox(width: 4),
                          Text(donor.email, style: const TextStyle(color: AppTheme.secondaryText, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.peachAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${donor.studentIds.length} Student${donor.studentIds.length > 1 ? 's' : ''}',
                    style: const TextStyle(color: AppTheme.peachAccent, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (donor.studentIds.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFEEEEEE)),
              const SizedBox(height: 12),
              const Text('SPONSORED STUDENTS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.secondaryText, letterSpacing: 1.0)),
              const SizedBox(height: 12),
              SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: donor.studentIds.length,
                  itemBuilder: (context, idx) {
                    final sId = donor.studentIds[idx];
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
