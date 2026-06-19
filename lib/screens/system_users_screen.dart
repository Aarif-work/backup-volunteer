import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_models.dart';

class SystemUsersScreen extends StatefulWidget {
  const SystemUsersScreen({super.key});

  @override
  State<SystemUsersScreen> createState() => _SystemUsersScreenState();
}

class _SystemUsersScreenState extends State<SystemUsersScreen> {
  // Mock data for system users
  final List<Map<String, dynamic>> _users = [
    {
      'name': 'System Admin',
      'role': UserRole.superAdmin,
      'email': 'admin@hope3.org',
      'id': 'ADM-001',
    },
    {
      'name': 'Finance Manager',
      'role': UserRole.finance,
      'email': 'finance@hope3.org',
      'id': 'FIN-002',
    },
    {
      'name': 'Field Coordinator',
      'role': UserRole.admin,
      'email': 'field@hope3.org',
      'id': 'ADM-003',
    },
    {
      'name': 'Operations Lead',
      'role': UserRole.admin,
      'email': 'ops@hope3.org',
      'id': 'ADM-004',
    },
    {
      'name': 'Chief Financial Officer',
      'role': UserRole.superAdmin,
      'email': 'cfo@hope3.org',
      'id': 'ADM-005',
    },
  ];

  String _getRoleName(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.admin:
        return 'Admin';
      case UserRole.finance:
        return 'Finance';
    }
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return Colors.redAccent;
      case UserRole.admin:
        return Colors.blueAccent;
      case UserRole.finance:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('System Users', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: _users.length,
        itemBuilder: (context, index) => _buildUserCard(_users[index]),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final role = user['role'] as UserRole;
    final color = _getRoleColor(role);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1), 
              borderRadius: BorderRadius.circular(20)
            ),
            child: Icon(Icons.person_rounded, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'], 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryText)
                ),
                const SizedBox(height: 4),
                Text(
                  user['email'], 
                  style: const TextStyle(fontSize: 12, color: AppTheme.secondaryText, fontWeight: FontWeight.w500)
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: ${user['id']}', 
                  style: const TextStyle(fontSize: 11, color: Colors.blueGrey, fontWeight: FontWeight.bold)
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getRoleName(role), 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: color)
            ),
          ),
        ],
      ),
    );
  }
}
