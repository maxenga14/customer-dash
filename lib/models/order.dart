import 'package:flutter/material.dart';

// Matches Afya-Hub backend: received → processing → ready → delivered → cancelled
enum OrderStatus { received, processing, ready, delivered, cancelled }

class Order {
  const Order({
    required this.orderNumber,
    required this.date,
    required this.itemCount,
    required this.total,
    required this.isDelivery,
    required this.status,
    this.quotationNote,
    this.productImageVariant,
  });

  final String orderNumber;
  final String date;
  final int itemCount;
  final double total;
  final bool isDelivery;
  final OrderStatus status;
  final String? quotationNote;
  final int? productImageVariant;
}

extension OrderStatusExt on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.received:   return 'RECEIVED';
      case OrderStatus.processing: return 'PROCESSING';
      case OrderStatus.ready:      return 'READY';
      case OrderStatus.delivered:  return 'DELIVERED';
      case OrderStatus.cancelled:  return 'CANCELLED';
    }
  }

  Color get badgeColor {
    switch (this) {
      case OrderStatus.received:   return const Color(0xFF5B8FC9);
      case OrderStatus.processing: return const Color(0xFFF0A529);
      case OrderStatus.ready:      return const Color(0xFF17A772);
      case OrderStatus.delivered:  return const Color(0xFF17A772);
      case OrderStatus.cancelled:  return const Color(0xFFD14A4A);
    }
  }

  Color get badgeBg {
    switch (this) {
      case OrderStatus.received:   return const Color(0xFFEAF3FF);
      case OrderStatus.processing: return const Color(0xFFFFF5DE);
      case OrderStatus.ready:      return const Color(0xFFE9FAF1);
      case OrderStatus.delivered:  return const Color(0xFFE9FAF1);
      case OrderStatus.cancelled:  return const Color(0xFFFFEEEE);
    }
  }

  IconData get badgeIcon {
    switch (this) {
      case OrderStatus.received:   return Icons.inbox_outlined;
      case OrderStatus.processing: return Icons.local_shipping_outlined;
      case OrderStatus.ready:      return Icons.check_circle_outline_rounded;
      case OrderStatus.delivered:  return Icons.check_circle_outline_rounded;
      case OrderStatus.cancelled:  return Icons.cancel_outlined;
    }
  }
}
