import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_models.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  String _selectedFilter = 'All';
  
  final List<StudentRequest> _requests = [
    StudentRequest(
      id: 'r1',
      studentName: 'Rahul Kumar',
      studentId: 'STU001',
      type: RequestType.leave,
      description: 'Requesting 2 days leave for sister\'s wedding.',
      date: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    StudentRequest(
      id: 'r2',
      studentName: 'Sneha Singh',
      studentId: 'STU042',
      type: RequestType.fee,
      description: 'Requesting assistance for Term 2 library fees (₹500).',
      date: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    StudentRequest(
      id: 'r3',
      studentName: 'Amit Patel',
      studentId: 'STU112',
      type: RequestType.achievement,
      description: 'Won 1st prize in Zonal Science Fair. Uploading certificate.',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<StudentRequest> filteredRequests = _requests;
    if (_selectedFilter != 'All') {
      filteredRequests = _requests.where((r) => r.type.name.toLowerCase() == _selectedFilter.toLowerCase()).toList();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Student Requests', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          _buildFilterRow(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildSectionHeader('PENDING APPROVALS'),
                ...filteredRequests.where((r) => r.status == RequestStatus.pending).map((r) => _buildRequestCard(r)),
                const SizedBox(height: 32),
                _buildSectionHeader('ACTION HISTORY'),
                ...filteredRequests.where((r) => r.status != RequestStatus.pending).map((r) => _buildRequestCard(r)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    final filters = ['All', 'Leave', 'Fee', 'Achievement'];
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300, width: 1.5),
                  boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))] : [],
                ),
                child: Center(
                  child: Text(
                    filter,
                    style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 1.1),
      ),
    );
  }

  Widget _buildRequestCard(StudentRequest request) {
    IconData typeIcon;
    Color typeColor;
    switch (request.type) {
      case RequestType.leave:
        typeIcon = Icons.calendar_today_rounded;
        typeColor = Colors.orange;
        break;
      case RequestType.fee:
        typeIcon = Icons.payments_outlined;
        typeColor = Colors.blue;
        break;
      case RequestType.achievement:
        typeIcon = Icons.emoji_events_outlined;
        typeColor = Colors.purple;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(18),
                  image: DecorationImage(
                    image: NetworkImage('https://i.pravatar.cc/150?u=${request.studentId}'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: typeColor, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
                    child: Icon(typeIcon, color: Colors.white, size: 10),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.studentName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryText)),
                    const SizedBox(height: 2),
                    Text('${request.type.name.toUpperCase()} • ${request.studentId}', style: const TextStyle(color: AppTheme.secondaryText, fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              if (request.status != RequestStatus.pending)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: request.status == RequestStatus.accepted ? Colors.green[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    request.status.name.toUpperCase(),
                    style: TextStyle(color: request.status == RequestStatus.accepted ? Colors.green : Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(request.description, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, height: 1.4)),
          if (request.status == RequestStatus.pending) ...[
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFEEEEEE)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() => request.status = RequestStatus.rejected);
                      globalPendingRequestsCount.value = _requests.where((r) => r.status == RequestStatus.pending).length;
                    },
                    icon: const Icon(Icons.close, size: 18, color: Colors.red),
                    label: const Text('Reject', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
                ),
                Container(width: 1, height: 24, color: Colors.grey[300]),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() => request.status = RequestStatus.accepted);
                      globalPendingRequestsCount.value = _requests.where((r) => r.status == RequestStatus.pending).length;
                    },
                    icon: const Icon(Icons.check, size: 18, color: Colors.green),
                    label: const Text('Accept', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
