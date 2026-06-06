import 'package:flutter/material.dart';

// --- USER & VOLUNTEER MODELS ---
enum VolunteerBadge { active, eventLeader }

class AppUser {
  final String id;
  final String name;
  final String email;
  final String volunteerId;
  final String profilePhotoUrl;
  final VolunteerBadge badge;
  final String contact;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.volunteerId,
    required this.profilePhotoUrl,
    required this.badge,
    required this.contact,
  });
}

enum StudentLocation { hostel, college, home, leave, unknown }

class StudentProfile {
  final String id;
  final String name;
  final String rollNumber;
  final String className;
  final String photoUrl;
  final List<String> achievements;
  final List<String> leaveHistory;
  final List<String> feeHistory;
  final StudentLocation currentLocation;
  final bool isLocationOff;
  final bool isPermittedToLeave;

  const StudentProfile({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.className,
    required this.photoUrl,
    this.achievements = const [],
    this.leaveHistory = const [],
    this.feeHistory = const [],
    this.currentLocation = StudentLocation.unknown,
    this.isLocationOff = false,
    this.isPermittedToLeave = true,
  });
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final IconData icon;
  final Color color;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.icon,
    required this.color,
    this.isRead = false,
  });
}

final ValueNotifier<int> globalPendingRequestsCount = ValueNotifier(3);

enum RequestType { leave, fee, achievement }
enum RequestStatus { pending, accepted, rejected }

class StudentRequest {
  final String id;
  final String studentName;
  final String studentId;
  final RequestType type;
  final String description;
  final DateTime date;
  RequestStatus status;

  StudentRequest({
    required this.id,
    required this.studentName,
    required this.studentId,
    required this.type,
    required this.description,
    required this.date,
    this.status = RequestStatus.pending,
  });
}

// --- ACTIVITY MODELS ---
class VolunteerActivity {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final double hoursSpent;

  const VolunteerActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.hoursSpent,
  });
}

// --- EXPENSE & FINANCE MODELS ---
enum ExpenseCategory {
  snacks,
  foodDistribution,
  travel,
  medical,
  educational,
  printing,
  stationary,
  donation,
  volunteerSupport,
  other
}

enum ApprovalStatus { pending, approved, rejected, needClarification }

class ExpenseRecord {
  final String id;
  final String title;
  final String description;
  final ExpenseCategory category;
  final double amount;
  final DateTime date;
  final String? proofImageUrl;
  final ApprovalStatus status;
  final bool refundRequested;
  final double approvedAmount;
  final double receivedAmount;
  final bool isPrivate;
  final bool isFoundationPaid;

  const ExpenseRecord({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.amount,
    required this.date,
    this.proofImageUrl,
    this.status = ApprovalStatus.pending,
    this.refundRequested = false,
    this.approvedAmount = 0.0,
    this.receivedAmount = 0.0,
    this.isPrivate = false,
    this.isFoundationPaid = false,
  });

  double get remainingBalance => approvedAmount - receivedAmount;
}

// --- PARENT MODELS ---
class ParentProfile {
  final String id;
  final String name;
  final String contactNumber;
  final String email;
  final String address;
  final List<String> studentIds; 
  final List<String> activityHistory; 

  const ParentProfile({
    required this.id,
    required this.name,
    required this.contactNumber,
    required this.email,
    required this.address,
    required this.studentIds,
    this.activityHistory = const [],
  });
}
