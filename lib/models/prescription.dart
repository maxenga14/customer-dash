import 'package:flutter/material.dart';

enum RxStatus { quotationReady, pendingReview, verified, rejected }

extension RxStatusExt on RxStatus {
  String get label {
    switch (this) {
      case RxStatus.quotationReady: return 'Quotation Ready';
      case RxStatus.pendingReview:  return 'Pending Review';
      case RxStatus.verified:       return 'Verified';
      case RxStatus.rejected:       return 'Rejected';
    }
  }

  Color get badgeColor {
    switch (this) {
      case RxStatus.quotationReady: return const Color(0xFF17A772);
      case RxStatus.pendingReview:  return const Color(0xFFF0A529);
      case RxStatus.verified:       return const Color(0xFF17A772);
      case RxStatus.rejected:       return const Color(0xFFD14A4A);
    }
  }

  Color get badgeBg {
    switch (this) {
      case RxStatus.quotationReady: return const Color(0xFFE9FAF1);
      case RxStatus.pendingReview:  return const Color(0xFFFFF5DE);
      case RxStatus.verified:       return const Color(0xFFE9FAF1);
      case RxStatus.rejected:       return const Color(0xFFFFEEEE);
    }
  }

  IconData get badgeIcon {
    switch (this) {
      case RxStatus.quotationReady: return Icons.check_circle_outline_rounded;
      case RxStatus.pendingReview:  return Icons.access_time_rounded;
      case RxStatus.verified:       return Icons.verified_outlined;
      case RxStatus.rejected:       return Icons.cancel_outlined;
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
