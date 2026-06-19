import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';
import 'parent_profile_screen.dart';
import 'parent_list_screen.dart';

class StudentDirectoryScreen extends StatefulWidget {
  const StudentDirectoryScreen({super.key});

  @override
  State<StudentDirectoryScreen> createState() => _StudentDirectoryScreenState();
}

class _StudentDirectoryScreenState extends State<StudentDirectoryScreen> {
  String _selectedFilter = 'All';
  bool _isGridView = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<StudentProfile> _students = const [
    StudentProfile(id: 'STU001', name: 'Rahul Kumar', rollNumber: '2024-A-01', className: 'Primary', photoUrl: '', achievements: ['Science Fair 1st Place', 'Perfect Attendance Dec'], leaveHistory: ['24/04/2024 - 26/04/2024 (Medical)']),
    StudentProfile(id: 'STU042', name: 'Sneha Singh', rollNumber: '2024-A-42', className: 'High', photoUrl: '', feeHistory: ['Term 1 - Paid', 'Term 2 - Pending']),
    StudentProfile(id: 'STU088', name: 'Priya Sharma', rollNumber: '2024-B-12', className: 'Primary', photoUrl: ''),
    StudentProfile(id: 'STU099', name: 'Arjun Das', rollNumber: '2024-C-05', className: 'Middle', photoUrl: '', achievements: ['Debate Team Lead']),
    StudentProfile(id: 'STU105', name: 'Vikram Singh', rollNumber: '2024-C-10', className: 'Middle', photoUrl: '', feeHistory: ['Term 1 - Paid']),
    StudentProfile(id: 'STU112', name: 'Ananya Patel', rollNumber: '2024-D-22', className: 'High', photoUrl: '', achievements: ['Math Olympiad Medalist']),
    StudentProfile(id: 'STU133', name: 'Neha Gupta', rollNumber: '2024-A-15', className: 'Primary', photoUrl: ''),
    StudentProfile(id: 'STU145', name: 'Karan Malhotra', rollNumber: '2024-B-08', className: 'High', photoUrl: ''),
  ];

  @override
  Widget build(BuildContext context) {
    List<StudentProfile> _filteredStudents = _students.where((s) {
      bool matchesFilter = _selectedFilter == 'All' || s.className == _selectedFilter;
      bool matchesSearch = s.name.toLowerCase().contains(_searchController.text.toLowerCase()) || 
                           s.rollNumber.toLowerCase().contains(_searchController.text.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Students Directory', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ParentListScreen()));
        },
        backgroundColor: Colors.black,
        icon: const Icon(Icons.family_restroom_rounded, color: Colors.white),
        label: const Text('View Parents', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterRow(),
          Expanded(
            child: _isGridView 
              ? GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.62,
                  ),
                  itemCount: _filteredStudents.length,
                  itemBuilder: (context, index) {
                    final student = _filteredStudents[index];
                    final colors = [const Color(0xFFBCE1EB), const Color(0xFFEEDC9A), const Color(0xFF8CD4CB), const Color(0xFF4AC2E2)];
                    final bgColor = colors[index % colors.length];

                    return GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StudentProfileDetailScreen(student: student, bgColor: bgColor))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage('https://i.pravatar.cc/250?u=${student.id}'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            student.name.split(' ')[0],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            student.className,
                            style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  },
                )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    itemCount: _filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = _filteredStudents[index];
                      final colors = [const Color(0xFFBCE1EB), const Color(0xFFEEDC9A), const Color(0xFF8CD4CB), const Color(0xFF4AC2E2)];
                      final bgColor = colors[index % colors.length];

                      return GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StudentProfileDetailScreen(student: student, bgColor: bgColor))),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8))],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: NetworkImage('https://i.pravatar.cc/250?u=${student.id}'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                                    const SizedBox(height: 4),
                                    Text('${student.className} • ${student.rollNumber}', style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                                child: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => setState(() {}),
          decoration: const InputDecoration(
            hintText: 'Search students...',
            border: InputBorder.none,
            icon: Icon(Icons.search_rounded, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    final filters = ['All', 'Primary', 'Middle', 'High'];
    return SizedBox(
      height: 55,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedFilter = filter);
              },
              selectedColor: Colors.black,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
              backgroundColor: Colors.grey.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide.none,
            ),
          );
        },
      ),
    );
  }
}

class StudentProfileDetailScreen extends StatelessWidget {
  final StudentProfile student;
  final Color bgColor;
  final bool isFromParent;
  
  const StudentProfileDetailScreen({
    super.key, 
    required this.student, 
    required this.bgColor,
    this.isFromParent = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool swipeEnabled = true;

    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! > 300) {
          Navigator.maybePop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Student Profile', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(45),
                    boxShadow: [
                      BoxShadow(color: bgColor.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                    image: DecorationImage(
                      image: NetworkImage('https://i.pravatar.cc/500?u=${student.id}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(student.name, style: const TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${student.className} • ${student.rollNumber}',
                  style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              const SizedBox(height: 48),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PARENT / GUARDIAN', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.secondaryText, letterSpacing: 1.5)),
                    const SizedBox(height: 16),
                    _buildParentCard(context),
                    const SizedBox(height: 32),
                    _buildPremiumDetailSection(Icons.person_pin_rounded, 'Personal Details', [
                      'Phone: +91 98765 43210',
                      'Blood Group: O+',
                      'Gender: Male',
                      'DOB: 12 Jan 2009',
                    ]),
                    const SizedBox(height: 24),
                    _buildPremiumDetailSection(Icons.location_on_outlined, 'Location Status', [
                      student.isLocationOff 
                        ? 'Location Services: OFF' 
                        : 'Current Location: ${student.currentLocation.name.toUpperCase()}',
                      student.isPermittedToLeave ? 'Permission: Authorized' : 'Permission: Restricted (Unauthorized Outing Alert)',
                    ]),
                    const SizedBox(height: 24),
                    _buildPremiumDetailSection(Icons.emoji_events_outlined, 'Achievements', student.achievements),
                    const SizedBox(height: 24),
                    _buildPremiumDetailSection(Icons.calendar_today_rounded, 'Leave History', student.leaveHistory),
                    const SizedBox(height: 24),
                    _buildPremiumDetailSection(Icons.payments_outlined, 'Fee Status', student.feeHistory),
                    const SizedBox(height: 48),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.white),
                          SizedBox(width: 16),
                          Expanded(child: Text('This profile is view-only for volunteers.', style: TextStyle(color: Colors.white, fontSize: 13))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumDetailSection(IconData icon, String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Color(0xFFF5F5F5), shape: BoxShape.circle),
              child: Icon(icon, size: 18, color: Colors.black),
            ),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 0.5, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 16),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.only(left: 48),
            child: Text('No records found', style: TextStyle(color: Colors.grey, fontSize: 13, fontStyle: FontStyle.italic)),
          )
        else
          ...items.map((item) => Padding(
              padding: const EdgeInsets.only(left: 48, bottom: 12),
              child: Text('• $item', style: const TextStyle(fontSize: 14, height: 1.4, color: AppTheme.textPrimary)),
            )),
      ],
    );
  }

  Widget _buildParentCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if ((context.widget as dynamic).isFromParent == true) {
           Navigator.maybePop(context);
        } else {
           Navigator.push(context, MaterialPageRoute(builder: (context) => ParentProfileScreen(
             parent: ParentProfile(
               id: 'p1',
               name: 'Mr. Kumar (Father)',
               contactNumber: '+91 98765 43210',
               email: 'kumar@example.com',
               address: '123 Main St, Springfield',
               studentIds: [student.id],
               activityHistory: ['Attended PTA meeting', 'Called regarding leave'],
             ),
             getStudentName: (id) => student.name,
           )));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.lavenderAccent.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(color: AppTheme.lavenderAccent.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8)),
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
              child: const Icon(Icons.family_restroom_rounded, color: AppTheme.lavenderAccent),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Primary Contact', style: TextStyle(color: AppTheme.secondaryText, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  SizedBox(height: 4),
                  Text('Mr. Kumar (Father)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryText)),
                  SizedBox(height: 2),
                  Text('+91 98765 43210', style: TextStyle(color: AppTheme.secondaryText, fontSize: 13)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppTheme.lavenderAccent.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.lavenderAccent),
            ),
          ],
        ),
      ),
    );
  }
}
