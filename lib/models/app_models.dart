import 'package:flutter/material.dart';

// --- USER & VOLUNTEER MODELS ---
enum UserRole { superAdmin, admin, finance }

final ValueNotifier<UserRole> currentUserRole = ValueNotifier(UserRole.superAdmin);

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

  // New Full Schema Fields
  final String? userId;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? bloodGroup;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final String? emergencyContact;
  final String? hostelRoom;
  final String? religion;
  final String? community;

  // Academic
  final String? schoolName;
  final String? course;
  final String? major;
  final String? college;
  final String? year;
  final String? currentYear;
  final String? mode;
  final String? schoolName10th;
  final String? schoolName12th;

  // Finance
  final String? bankName;
  final String? bankAccountNumber;
  final String? bankIfsc;
  final String? fundingPercentage;
  final String? amountApprox;

  // Family
  final String? fatherName;
  final String? fatherContactNumber;
  final String? fatherOccupation;
  final String? motherName;
  final String? motherContactNumber;
  final String? motherOccupation;
  final String? guardianName;
  final String? guardianContactNumber;
  final String? guardianOccupation;

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
    this.userId,
    this.dateOfBirth,
    this.gender,
    this.bloodGroup,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.emergencyContact,
    this.hostelRoom,
    this.religion,
    this.community,
    this.schoolName,
    this.course,
    this.major,
    this.college,
    this.year,
    this.currentYear,
    this.mode,
    this.schoolName10th,
    this.schoolName12th,
    this.bankName,
    this.bankAccountNumber,
    this.bankIfsc,
    this.fundingPercentage,
    this.amountApprox,
    this.fatherName,
    this.fatherContactNumber,
    this.fatherOccupation,
    this.motherName,
    this.motherContactNumber,
    this.motherOccupation,
    this.guardianName,
    this.guardianContactNumber,
    this.guardianOccupation,
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

abstract class StudentRequest {
  String get id;
  String get studentName;
  String get studentId;
  RequestType get type;
  String get description;
  DateTime get date;
  RequestStatus get status;
  set status(RequestStatus value);
}

class LeaveRequestModel implements StudentRequest {
  final String leaveRequestId;
  @override final String studentId;
  @override final String studentName;
  final String requestedBy;
  final String reason;
  final DateTime leaveDate;
  final DateTime resumeDate;
  @override RequestStatus status;
  final String? reviewedBy;
  final String? reviewNote;
  final DateTime? reviewedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  LeaveRequestModel({
    required this.leaveRequestId,
    required this.studentId,
    required this.studentName,
    required this.requestedBy,
    required this.reason,
    required this.leaveDate,
    required this.resumeDate,
    this.status = RequestStatus.pending,
    this.reviewedBy,
    this.reviewNote,
    this.reviewedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  @override String get id => leaveRequestId;
  @override RequestType get type => RequestType.leave;
  @override String get description => reason;
  @override DateTime get date => createdAt;
}

class FeeRequestModel implements StudentRequest {
  final String feeRequestId;
  @override final String studentId;
  @override final String studentName;
  final String requestedBy;
  final double amount;
  final String reason;
  @override RequestStatus status;
  final String feeType;
  final String email;
  final int submittedMarksheets;
  final int submittedPaymentReceipts;
  final String driveLink;
  final String studentHope3Id;
  final String course;
  final DateTime dueDate;
  final String contactNumber;
  final String paymentMode;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? reviewedBy;
  final String? reviewNote;
  final DateTime? reviewedAt;

  FeeRequestModel({
    required this.feeRequestId,
    required this.studentId,
    required this.studentName,
    required this.requestedBy,
    required this.amount,
    required this.reason,
    this.status = RequestStatus.pending,
    required this.feeType,
    required this.email,
    required this.submittedMarksheets,
    required this.submittedPaymentReceipts,
    required this.driveLink,
    required this.studentHope3Id,
    required this.course,
    required this.dueDate,
    required this.contactNumber,
    required this.paymentMode,
    required this.createdAt,
    required this.updatedAt,
    this.reviewedBy,
    this.reviewNote,
    this.reviewedAt,
  });

  @override String get id => feeRequestId;
  @override RequestType get type => RequestType.fee;
  @override String get description => reason;
  @override DateTime get date => createdAt;
}

class StudentAchievementModel implements StudentRequest {
  final String achievementId;
  @override final String studentId;
  @override final String studentName;
  final String achievementType;
  final String title;
  @override RequestStatus status;
  final DateTime submittedAt;
  final String achievementDescription;
  final String photoDriveLink;
  final String? reviewedBy;
  final String? reviewNote;
  final DateTime? reviewedAt;
  final DateTime updatedAt;

  StudentAchievementModel({
    required this.achievementId,
    required this.studentId,
    required this.studentName,
    required this.achievementType,
    required this.title,
    this.status = RequestStatus.pending,
    required this.submittedAt,
    required this.achievementDescription,
    required this.photoDriveLink,
    this.reviewedBy,
    this.reviewNote,
    this.reviewedAt,
    required this.updatedAt,
  });

  @override String get id => achievementId;
  @override RequestType get type => RequestType.achievement;
  @override String get description => achievementDescription;
  @override DateTime get date => submittedAt;
}

class MessageModel {
  final String messageId;
  final String studentId;
  final String senderId;
  final String message;
  final bool isRead;
  final DateTime sentAt;
  final DateTime updatedAt;

  MessageModel({
    required this.messageId,
    required this.studentId,
    required this.senderId,
    required this.message,
    required this.isRead,
    required this.sentAt,
    required this.updatedAt,
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
  final String submittedBy;

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
    this.submittedBy = 'System Admin',
  });

  double get remainingBalance => approvedAmount - receivedAmount;
}

// --- PARENT MODELS ---
class ParentProfile {
  final String parentId;
  final String userId;
  final String studentId;
  final String parentName;
  final String parentPhone;
  final String relation;
  final int isPrimary;
  final String? fcmToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ParentProfile({
    required this.parentId,
    required this.userId,
    required this.studentId,
    required this.parentName,
    required this.parentPhone,
    required this.relation,
    required this.isPrimary,
    this.fcmToken,
    required this.createdAt,
    required this.updatedAt,
  });
}

// --- DONOR MODELS ---
class DonationRecord {
  final String id;
  final double amount;
  final DateTime date;
  final String purpose;

  const DonationRecord({
    required this.id,
    required this.amount,
    required this.date,
    required this.purpose,
  });
}

class DonorProfile {
  final String id;
  final String name;
  final String contactNumber;
  final String email;
  final String photoUrl;
  final List<String> studentIds;
  final List<DonationRecord> donationHistory;
  final String notes;

  const DonorProfile({
    required this.id,
    required this.name,
    required this.contactNumber,
    required this.email,
    required this.photoUrl,
    this.studentIds = const [],
    this.donationHistory = const [],
    this.notes = '',
  });
}

// --- HEALTH MODELS ---
class StudentHealthModel {
  final String healthReportId;
  final String studentId;
  final DateTime reportDate;
  final double heightCm;
  final double weightKg;
  final String healthStatus;
  final String medicine;
  final String doctorVisit;
  final String recordedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  StudentHealthModel({
    required this.healthReportId,
    required this.studentId,
    required this.reportDate,
    required this.heightCm,
    required this.weightKg,
    required this.healthStatus,
    required this.medicine,
    required this.doctorVisit,
    required this.recordedBy,
    required this.createdAt,
    required this.updatedAt,
  });
}
