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
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverHeader(),
          SliverToBoxAdapter(child: const SizedBox(height: 20)),
          _buildFilterRow(),
          SliverToBoxAdapter(child: const SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final pending = filteredRequests.where((r) => r.status == RequestStatus.pending).toList();
                  final history = filteredRequests.where((r) => r.status != RequestStatus.pending).toList();
                  final combined = [...pending, ...history];
                  return _buildModernRequestCard(combined[index]);
                },
                childCount: filteredRequests.length,
              ),
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 180.0,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF000000),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final collapsed = constraints.maxHeight <= kToolbarHeight + MediaQuery.of(context).padding.top + 10;
          return FlexibleSpaceBar(
            centerTitle: true,
            titlePadding: const EdgeInsets.only(bottom: 14),
            title: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: collapsed ? 1.0 : 0.0,
              child: const Text('STUDENT REQUESTS',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
            ),
            background: Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.headerGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 50,
                    right: -30,
                    child: Icon(Icons.assignment_rounded, size: 200, color: Colors.white.withOpacity(0.05)),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Command Center',
                            style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
                          const SizedBox(height: 4),
                          const Text('Student Requests',
                            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildHeaderStat('Pending Actions', '${_requests.where((r) => r.status == RequestStatus.pending).length}', Icons.pending_actions_rounded, Colors.orangeAccent),
                              const SizedBox(width: 24),
                              _buildHeaderStat('Resolved Today', '${_requests.where((r) => r.status != RequestStatus.pending).length}', Icons.check_circle_rounded, Colors.greenAccent),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
          ],
        )
      ],
    );
  }

  Widget _buildFilterRow() {
    final filters = ['All', 'Leave', 'Fee', 'Achievement'];
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 50,
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
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(25),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
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
                    child: Icon(typeIcon, color: Colors.white, size: 12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.studentName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryText)),
                    const SizedBox(height: 4),
                    Text('${request.type.name.toUpperCase()} • ${request.studentId}', style: const TextStyle(color: AppTheme.secondaryText, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                  ],
                ),
              ),
              if (!isPending)
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
          const SizedBox(height: 16),
          Text(request.description, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, height: 1.5)),
          if (isPending) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => request.status = RequestStatus.rejected);
                      globalPendingRequestsCount.value = _requests.where((r) => r.status == RequestStatus.pending).length;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.red.withOpacity(0.2)),
                      ),
                      child: const Center(child: Text('Decline', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => request.status = RequestStatus.accepted);
                      globalPendingRequestsCount.value = _requests.where((r) => r.status == RequestStatus.pending).length;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: const Center(child: Text('Approve', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    ),
  );
}
}
