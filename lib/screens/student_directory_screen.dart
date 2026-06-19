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

  final List<StudentProfile> _students = [
    StudentProfile(
      id: '1088145b-4651-4563-8f2a-91b4f8345463',
      userId: '10b9ef48-7a1a-470f-b2c8-1096b0996dbc',
      name: 'Rahul Kumar',
      rollNumber: '123456',
      className: 'RCD 1',
      photoUrl: '',
      dateOfBirth: DateTime(2006, 6, 17),
      gender: 'Male',
      bloodGroup: 'O+',
      address: '123 Tech Park',
      city: 'Bangalore',
      state: 'Karnataka',
      pincode: '560001',
      emergencyContact: '9876543210',
      religion: 'Hindu',
      community: 'General',
      course: 'B.Tech',
      major: 'Computer Science',
      college: 'National Institute of Technology',
      year: '3',
      currentYear: '3',
      bankName: 'State Bank of India',
      bankAccountNumber: 'SBI123456789',
      bankIfsc: 'SBIN0001234',
      fundingPercentage: '100.00',
      amountApprox: '50000.00',
      fatherName: 'Mr. Kumar',
      fatherOccupation: 'Engineer',
      fatherContactNumber: '9876543211',
      motherName: 'Mrs. Kumar',
      motherOccupation: 'Teacher',
      motherContactNumber: '9876543212',
      achievements: ['Science Fair 1st Place', 'Perfect Attendance Dec'],
      leaveHistory: ['24/04/2024 - 26/04/2024 (Medical)'],
    ),
    const StudentProfile(id: 'STU042', name: 'Sneha Singh', rollNumber: '2024-A-42', className: 'RCD 2', photoUrl: '', feeHistory: ['Term 1 - Paid', 'Term 2 - Pending']),
    const StudentProfile(id: 'STU088', name: 'Priya Sharma', rollNumber: '2024-B-12', className: 'RCD 1', photoUrl: ''),
    const StudentProfile(id: 'STU099', name: 'Arjun Das', rollNumber: '2024-C-05', className: 'RCD 3', photoUrl: '', achievements: ['Debate Team Lead']),
    const StudentProfile(id: 'STU105', name: 'Vikram Singh', rollNumber: '2024-C-10', className: 'RCD 3', photoUrl: '', feeHistory: ['Term 1 - Paid']),
    const StudentProfile(id: 'STU112', name: 'Ananya Patel', rollNumber: '2024-D-22', className: 'RCD 2', photoUrl: '', achievements: ['Math Olympiad Medalist']),
    const StudentProfile(id: 'STU133', name: 'Neha Gupta', rollNumber: '2024-A-15', className: 'RCD 1', photoUrl: ''),
    const StudentProfile(id: 'STU145', name: 'Karan Malhotra', rollNumber: '2024-B-08', className: 'RCD 2', photoUrl: ''),
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
    final filters = ['All', 'RCD 1', 'RCD 2', 'RCD 3'];
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == _selectedFilter;
          return GestureDetector(
            onTap: () {
              if (!isSelected) setState(() => _selectedFilter = filter);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300, width: 1.5),
                boxShadow: isSelected 
                  ? [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))] 
                  : [],
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
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
                      'DOB: ${student.dateOfBirth != null ? "${student.dateOfBirth!.day}/${student.dateOfBirth!.month}/${student.dateOfBirth!.year}" : "N/A"}',
                      'Gender: ${student.gender ?? "N/A"}',
                      'Blood Group: ${student.bloodGroup ?? "N/A"}',
                      'Emergency Contact: ${student.emergencyContact ?? "N/A"}',
                      'Address: ${student.address ?? ""}, ${student.city ?? ""} ${student.state ?? ""}',
                      'Religion: ${student.religion ?? "N/A"}',
                    ]),
                    const SizedBox(height: 24),
                    _buildPremiumDetailSection(Icons.school_rounded, 'Academic Details', [
                      'Course: ${student.course ?? "N/A"} (${student.major ?? "N/A"})',
                      'College: ${student.college ?? "N/A"}',
                      'Current Year: ${student.currentYear ?? "N/A"}',
                      '10th School: ${student.schoolName10th ?? "N/A"}',
                    ]),
                    const SizedBox(height: 24),
                    _buildPremiumDetailSection(Icons.account_balance_rounded, 'Banking & Finance', [
                      'Bank Name: ${student.bankName ?? "N/A"}',
                      'A/C Number: ${student.bankAccountNumber ?? "N/A"}',
                      'IFSC Code: ${student.bankIfsc ?? "N/A"}',
                      'Funding Percentage: ${student.fundingPercentage != null ? "${student.fundingPercentage}%" : "N/A"}',
                      'Approx Amount: ₹${student.amountApprox ?? "0.00"}',
                    ]),
                    const SizedBox(height: 24),
                    _buildPremiumDetailSection(Icons.family_restroom_rounded, 'Family Details', [
                      'Father: ${student.fatherName ?? "N/A"} (${student.fatherContactNumber ?? "N/A"})',
                      'Mother: ${student.motherName ?? "N/A"} (${student.motherContactNumber ?? "N/A"})',
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
                    const SizedBox(height: 32),
                    _buildHealthSection(),
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
               parentId: 'eedb48f8-4645-4ee4-aae2-7c28c896b062',
               userId: 'c7b4dc02-b9a2-40db-b396-9ccb375a6879',
               studentId: student.id,
               parentName: 'Mr. Kumar',
               parentPhone: '+91 98765 43210',
               relation: 'father',
               isPrimary: 1,
               createdAt: DateTime.now().subtract(const Duration(days: 300)),
               updatedAt: DateTime.now(),
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

  Widget _buildHealthSection() {
    final report = StudentHealthModel(
      healthReportId: '0afb1454-a771-4cb1-8380-e75f8b5f627b',
      studentId: student.id,
      reportDate: DateTime(2026, 6, 13),
      heightCm: 150.50,
      weightKg: 45.20,
      healthStatus: 'Healthy',
      medicine: 'None',
      doctorVisit: 'No',
      recordedBy: 'c7b4dc02-b9a2-40db-b396-9ccb375a6879',
      createdAt: DateTime(2026, 6, 13, 10, 51, 5),
      updatedAt: DateTime(2026, 6, 13, 10, 51, 5),
    );

    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    String dateStr = '${report.reportDate.day} ${months[report.reportDate.month - 1]} ${report.reportDate.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Color(0xFFF5F5F5), shape: BoxShape.circle),
              child: const Icon(Icons.monitor_heart_rounded, size: 18, color: Colors.black),
            ),
            const SizedBox(width: 12),
            const Text('Health Report', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 0.5, fontSize: 16)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Text(report.healthStatus.toUpperCase(), style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
            boxShadow: [BoxShadow(color: Colors.redAccent.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: $dateStr', style: const TextStyle(color: AppTheme.secondaryText, fontSize: 12, fontWeight: FontWeight.bold)),
              const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: Color(0xFFEEEEEE))),
              Row(
                children: [
                  Expanded(child: _buildHealthInfoItem('Height', '${report.heightCm} cm', Icons.height_rounded)),
                  Expanded(child: _buildHealthInfoItem('Weight', '${report.weightKg} kg', Icons.monitor_weight_rounded)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildHealthInfoItem('Doctor', report.doctorVisit, Icons.medical_services_rounded)),
                  Expanded(child: _buildHealthInfoItem('Medicine', report.medicine, Icons.medication_rounded)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHealthInfoItem(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppTheme.secondaryText),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.secondaryText, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
          ],
        ),
      ],
    );
  }
}
