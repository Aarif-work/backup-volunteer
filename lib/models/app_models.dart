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

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.volunteerId,
    required this.profilePhotoUrl,
    required this.badge,
    required this.contact,
  });
}

// --- ACTIVITY MODELS ---
class VolunteerActivity {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final double hoursSpent;

  VolunteerActivity({
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

  ExpenseRecord({
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
  });
}
