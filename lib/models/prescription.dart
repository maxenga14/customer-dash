import 'package:flutter/material.dart';

// Matches Afya-Hub backend: pending → approved → rejected → paid
enum RxStatus { pending, approved, rejected, paid }

extension RxStatusExt on RxStatus {
  String get label {
    switch (this) {
      case RxStatus.pending:  return 'Pending Review';
      case RxStatus.approved: return 'Quotation Ready';
      case RxStatus.rejected: return 'Rejected';
      case RxStatus.paid:     return 'Verified';
    }
  }

  Color get badgeColor {
    switch (this) {
      case RxStatus.pending:  return const Color(0xFFF0A529);
      case RxStatus.approved: return const Color(0xFF17A772);
      case RxStatus.rejected: return const Color(0xFFD14A4A);
      case RxStatus.paid:     return const Color(0xFF17A772);
    }
  }

  Color get badgeBg {
    switch (this) {
      case RxStatus.pending:  return const Color(0xFFFFF5DE);
      case RxStatus.approved: return const Color(0xFFE9FAF1);
      case RxStatus.rejected: return const Color(0xFFFFEEEE);
      case RxStatus.paid:     return const Color(0xFFE9FAF1);
    }
  }

  IconData get badgeIcon {
    switch (this) {
      case RxStatus.pending:  return Icons.access_time_rounded;
      case RxStatus.approved: return Icons.check_circle_outline_rounded;
      case RxStatus.rejected: return Icons.cancel_outlined;
      case RxStatus.paid:     return Icons.verified_outlined;
    }
  }
}

class Prescription {
  const Prescription({
    required this.id,
    required this.name,
    required this.uploadedAt,
    required this.status,
    this.statusNote,
    this.quotationPrice,
    this.quotationPharmacy,
    this.linkedOrderNumber,
    this.linkedPharmacy,
  });

  final String id;
  final String name;
  final String uploadedAt;
  final RxStatus status;
  final String? statusNote;
  final double? quotationPrice;
  final String? quotationPharmacy;
  final String? linkedOrderNumber;
  final String? linkedPharmacy;
}
