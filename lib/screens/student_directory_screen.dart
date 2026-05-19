import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';

class StudentDirectoryScreen extends StatelessWidget {
  const StudentDirectoryScreen({super.key});

  final List<StudentProfile> _students = const [
    StudentProfile(
      id: 'STU001',
      name: 'Rahul Kumar',
      rollNumber: '2024-A-01',
      className: 'Grade 8-B',
      photoUrl: '',
      achievements: ['Science Fair 1st Place', 'Perfect Attendance Dec'],
      leaveHistory: ['24/04/2024 - 26/04/2024 (Medical)'],
    ),
    StudentProfile(
      id: 'STU042',
      name: 'Sneha Singh',
      rollNumber: '2024-A-42',
      className: 'Grade 9-A',
      photoUrl: '',
      feeHistory: ['Term 1 - Paid', 'Term 2 - Pending'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Student Directory'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search students...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _students.length,
        itemBuilder: (context, index) {
          final student = _students[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[100]!),
            ),
            child: ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StudentProfileDetailScreen(student: student))),
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                child: Text(student.name[0], style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
              ),
              title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${student.rollNumber} • ${student.className}', style: const TextStyle(fontSize: 12)),
              trailing: const Icon(Icons.chevron_right, size: 20),
            ),
          );
        },
      ),
    );
  }
}

class StudentProfileDetailScreen extends StatelessWidget {
  final StudentProfile student;
  const StudentProfileDetailScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Student Profile'), elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
              ),
              child: Column(
                children: [
                  CircleAvatar(radius: 50, backgroundColor: Colors.white24, child: Text(student.name[0], style: const TextStyle(fontSize: 40, color: Colors.white))),
                  const SizedBox(height: 16),
                  Text(student.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(student.rollNumber, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailSection(Icons.emoji_events_outlined, 'Achievements', student.achievements),
                  const SizedBox(height: 24),
                  _buildDetailSection(Icons.calendar_today_rounded, 'Leave History', student.leaveHistory),
                  const SizedBox(height: 24),
                  _buildDetailSection(Icons.payments_outlined, 'Fee Status', student.feeHistory),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(16)),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 12),
                        Expanded(child: Text('This profile is view-only for volunteers.', style: TextStyle(color: Colors.blue, fontSize: 12))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(IconData icon, String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.textSecondary),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textSecondary, letterSpacing: 0.5)),
          ],
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          const Text('No records found', style: TextStyle(color: Colors.grey, fontSize: 13, fontStyle: FontStyle.italic))
        else
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('• $item', style: const TextStyle(fontSize: 14, height: 1.4)),
          )),
      ],
    );
  }
}
