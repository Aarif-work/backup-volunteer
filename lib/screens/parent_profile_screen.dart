import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_models.dart';
import 'student_directory_screen.dart';

class ParentProfileScreen extends StatelessWidget {
  final ParentProfile parent;
  final String Function(String) getStudentName;

  const ParentProfileScreen({super.key, required this.parent, required this.getStudentName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: const Color(0xFFF8F9FA),
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text('Parent Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: AppTheme.lavenderGradient,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                        ),
                        child: const Icon(Icons.person_rounded, color: AppTheme.lavenderAccent, size: 40),
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
                          Expanded(child: Text(activity, style: const TextStyle(color: AppTheme.primaryText, fontSize: 14))),
                        ],
                      ),
                    )),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.secondaryText)),
              Text(value, style: const TextStyle(fontSize: 14, color: AppTheme.primaryText, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStudentCard(String studentId, BuildContext context) {
    return GestureDetector(
      onTap: () {
        final mockStudent = StudentProfile(
          id: studentId,
          name: getStudentName(studentId),
          rollNumber: '2024-X-xx',
          className: 'RCD X',
          photoUrl: 'https://i.pravatar.cc/150?u=$studentId',
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
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
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
