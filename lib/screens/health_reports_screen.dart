import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';

class HealthReportsScreen extends StatefulWidget {
  const HealthReportsScreen({super.key});

  @override
  State<HealthReportsScreen> createState() => _HealthReportsScreenState();
}

class _HealthReportsScreenState extends State<HealthReportsScreen> {
  final List<StudentHealthModel> _reports = [
    StudentHealthModel(
      healthReportId: '0afb1454-a771-4cb1-8380-e75f8b5f627b',
      studentId: 'STU001',
      reportDate: DateTime(2026, 6, 13),
      heightCm: 150.50,
      weightKg: 45.20,
      healthStatus: 'Healthy',
      medicine: 'None',
      doctorVisit: 'No',
      recordedBy: 'c7b4dc02-b9a2-40db-b396-9ccb375a6879',
      createdAt: DateTime(2026, 6, 13, 10, 51, 5),
      updatedAt: DateTime(2026, 6, 13, 10, 51, 5),
    ),
  ];

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Student Health Reports', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: _reports.length,
        itemBuilder: (context, index) {
          final report = _reports[index];
          return _buildHealthCard(report);
        },
      ),
    );
  }

  Widget _buildHealthCard(StudentHealthModel report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8)),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite_rounded, color: Colors.red, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Student ID: ${report.studentId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryText)),
                    const SizedBox(height: 4),
                    Text('Report Date: ${_formatDate(report.reportDate)}', style: const TextStyle(color: AppTheme.secondaryText, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  report.healthStatus.toUpperCase(),
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Color(0xFFF0F0F0), thickness: 1),
          ),
          Row(
            children: [
              Expanded(child: _buildInfoItem('Height', '${report.heightCm} cm', Icons.height_rounded)),
              Expanded(child: _buildInfoItem('Weight', '${report.weightKg} kg', Icons.monitor_weight_rounded)),
              Expanded(child: _buildInfoItem('Doctor', report.doctorVisit, Icons.medical_services_rounded)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(flex: 2, child: _buildInfoItem('Medicine', report.medicine, Icons.medication_rounded)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
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
