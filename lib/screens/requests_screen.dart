import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_models.dart';
import 'request_detail_screen.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> with SingleTickerProviderStateMixin {
  String _selectedFilter = 'All';
  final ScrollController _scrollController = ScrollController();
  
  final List<StudentRequest> _requests = [
    LeaveRequestModel(
      leaveRequestId: 'r1',
      studentName: 'Rahul Kumar',
      studentId: 'STU001',
      requestedBy: 'ADM001',
      reason: 'Requesting 2 days leave for sister\'s wedding.',
      leaveDate: DateTime.now().add(const Duration(days: 2)),
      resumeDate: DateTime.now().add(const Duration(days: 4)),
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    FeeRequestModel(
      feeRequestId: 'r2',
      studentName: 'Sneha Singh',
      studentId: 'STU042',
      requestedBy: 'ADM001',
      amount: 500.0,
      reason: 'Requesting assistance for Term 2 library fees (₹500).',
      feeType: 'fee',
      email: 'sneha@example.com',
      submittedMarksheets: 1,
      submittedPaymentReceipts: 0,
      driveLink: 'https://drive.google.com/xyz',
      studentHope3Id: 'HOPE_SNEHA',
      course: 'High School',
      dueDate: DateTime.now().add(const Duration(days: 10)),
      contactNumber: '1234567890',
      paymentMode: 'online_portal',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    StudentAchievementModel(
      achievementId: 'r3',
      studentName: 'Amit Patel',
      studentId: 'STU112',
      achievementType: 'prize',
      title: 'Zonal Science Fair',
      achievementDescription: 'Won 1st prize in Zonal Science Fair. Uploading certificate.',
      photoDriveLink: 'https://drive.google.com/abc',
      submittedAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  final List<MessageModel> _messages = [
    MessageModel(
      messageId: 'e141a91d-2ce6-479f-b91f-c20eac1a7d0b',
      studentId: 'STU001',
      senderId: 'STU001',
      message: 'Going to Koviloor for the weekend.',
      isRead: true,
      sentAt: DateTime.now().subtract(const Duration(minutes: 15)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    MessageModel(
      messageId: 'm2',
      studentId: 'STU042',
      senderId: 'STU042',
      message: 'Just going to the nearby shop, will be back in 20 mins.',
      isRead: false,
      sentAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    MessageModel(
      messageId: 'm3',
      studentId: 'STU112',
      senderId: 'STU112',
      message: 'Going home for Diwali.',
      isRead: true,
      sentAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<StudentRequest> filteredRequests = _requests;
    if (_selectedFilter != 'All') {
      filteredRequests = _requests.where((r) => r.type.name.toLowerCase() == _selectedFilter.toLowerCase()).toList();
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverHeader(),
          _buildStatsSection(),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          _buildFilterRow(),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (_selectedFilter == 'Messages') {
                    return _buildMessageCard(_messages[index]);
                  }
                  final pending = filteredRequests.where((r) => r.status == RequestStatus.pending).toList();
                  final history = filteredRequests.where((r) => r.status != RequestStatus.pending).toList();
                  final combined = [...pending, ...history];
                  return _buildModernRequestCard(combined[index]);
                },
                childCount: _selectedFilter == 'Messages' ? _messages.length : filteredRequests.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    ));
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: const Color(0xFFF8F9FA),
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      title: const Text('Student Requests', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
    );
  }

  Widget _buildStatsSection() {
    final pendingCount = _requests.where((r) => r.status == RequestStatus.pending).length;
    final resolvedCount = _requests.where((r) => r.status != RequestStatus.pending).length;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pending Actions', style: TextStyle(color: AppTheme.secondaryText, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(pendingCount.toString(), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppTheme.primaryText, height: 1.0)),
                    const SizedBox(width: 8),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 6),
                      child: Text('requests', style: TextStyle(fontSize: 14, color: AppTheme.secondaryText, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Text('$resolvedCount Resolved', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    final filters = ['All', 'Leave', 'Fee', 'Achievement', 'Messages'];
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: filters.length,
          itemBuilder: (context, index) {
            final filter = filters[index];
            final isSelected = filter == _selectedFilter;
            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: Container(
                margin: const EdgeInsets.only(right: 20),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: isSelected ? AppTheme.peachAccent : Colors.transparent, width: 3)),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? AppTheme.peachAccent : Colors.grey, 
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, 
                    fontSize: 15
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildModernRequestCard(StudentRequest request) {
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

    final bool isPending = request.status == RequestStatus.pending;

    return GestureDetector(
      onTap: () => Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => RequestDetailScreen(
            request: request,
            onAction: () {
              setState(() {});
              globalPendingRequestsCount.value = _requests.where((r) => r.status == RequestStatus.pending).length;
            },
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: const Offset(0, 8))
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: typeColor.withOpacity(0.2), width: 2),
                image: DecorationImage(
                  image: NetworkImage('https://i.pravatar.cc/150?u=${request.studentId}'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: typeColor, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                  child: Icon(typeIcon, color: Colors.white, size: 10),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(request.studentName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryText)),
                  const SizedBox(height: 4),
                  Text('${request.type.name.toUpperCase()} • ${request.studentId}', style: const TextStyle(color: AppTheme.secondaryText, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  Text(request.description, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (isPending)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() => request.status = RequestStatus.rejected);
                      globalPendingRequestsCount.value = _requests.where((r) => r.status == RequestStatus.pending).length;
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.close_rounded, color: Colors.red, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() => request.status = RequestStatus.accepted);
                      globalPendingRequestsCount.value = _requests.where((r) => r.status == RequestStatus.pending).length;
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.check_rounded, color: Colors.green, size: 20),
                    ),
                  ),
                ],
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: request.status == RequestStatus.accepted ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  request.status.name.toUpperCase(),
                  style: TextStyle(color: request.status == RequestStatus.accepted ? Colors.green : Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    int hour = date.hour;
    String amPm = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;
    String minute = date.minute.toString().padLeft(2, '0');
    return '${date.day} ${months[date.month - 1]} • $hour:$minute $amPm';
  }

  Widget _buildMessageCard(MessageModel msg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8)),
        ],
        border: msg.isRead ? null : Border.all(color: AppTheme.peachAccent.withOpacity(0.5), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${msg.studentId}'),
                  ),
                  const SizedBox(width: 12),
                  Text('Student • ${msg.studentId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              Text(
                _formatDateTime(msg.sentAt),
                style: const TextStyle(color: AppTheme.secondaryText, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            msg.message,
            style: const TextStyle(color: AppTheme.primaryText, fontSize: 15, height: 1.4),
          ),
        ],
      ),
    );
  }
}
