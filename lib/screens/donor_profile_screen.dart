import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_models.dart';
import 'student_directory_screen.dart';

class DonorProfileScreen extends StatelessWidget {
  final DonorProfile donor;
  final String Function(String) getStudentName;

  const DonorProfileScreen({super.key, required this.donor, required this.getStudentName});

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
            title: const Text('Donor Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
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
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey.shade100,
                          backgroundImage: NetworkImage(donor.photoUrl),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(donor.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
                            const SizedBox(height: 4),
                            Text('Donor ID: ${donor.id}', style: const TextStyle(fontSize: 14, color: AppTheme.secondaryText)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text('CONTACT INFORMATION', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.secondaryText, letterSpacing: 1.5)),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.phone_rounded, 'Phone', donor.contactNumber),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.email_rounded, 'Email', donor.email),
                  const SizedBox(height: 32),
                  const Text('SPONSORED STUDENTS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.secondaryText, letterSpacing: 1.5)),
                  const SizedBox(height: 16),
                  if (donor.studentIds.isEmpty)
                    const Text('No students sponsored yet.', style: TextStyle(color: AppTheme.secondaryText))
                  else
                    ...donor.studentIds.map((id) => _buildStudentCard(id, context)),
                  const SizedBox(height: 32),
                  const Text('DONATION HISTORY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.secondaryText, letterSpacing: 1.5)),
                  const SizedBox(height: 16),
                  if (donor.donationHistory.isEmpty)
                    const Text('No donation history available.', style: TextStyle(color: AppTheme.secondaryText))
                  else
                    ...donor.donationHistory.map((donation) => _buildDonationCard(donation)),
                  const SizedBox(height: 32),
                  if (donor.notes.isNotEmpty) ...[
                    const Text('NOTES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.secondaryText, letterSpacing: 1.5)),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(donor.notes, style: const TextStyle(color: AppTheme.primaryText, fontSize: 14, height: 1.5)),
                    ),
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
          isFromParent: true, // Reusing this flag to avoid showing Parent/Donor specific bottom sheets again
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
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=$studentId'),
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

  Widget _buildDonationCard(DonationRecord donation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.peachAccent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppTheme.peachAccent.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.favorite_rounded, color: AppTheme.peachAccent, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(donation.purpose, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryText, fontSize: 14)),
                const SizedBox(height: 4),
                Text(donation.date.toString().substring(0, 10), style: const TextStyle(fontSize: 12, color: AppTheme.secondaryText)),
              ],
            ),
          ),
          Text('\$${donation.amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryText, fontSize: 16)),
        ],
      ),
    );
  }
}
