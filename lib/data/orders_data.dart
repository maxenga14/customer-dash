import '../models/order.dart';

final List<Order> mockOrders = [
  Order(
    orderNumber: '#ORD-8478',
    date: 'Today, 10:45 AM',
    itemCount: 3,
    total: 45.49,
    isDelivery: true,
    status: OrderStatus.onRoute,
    productImageVariant: 0,
  ),
  Order(
    orderNumber: '#ORD-8438',
    date: 'Yesterday, 14:20 PM',
    itemCount: 2,
    total: 28.00,
    isDelivery: true,
    status: OrderStatus.needsAction,
    quotationNote: 'Quotation ready for Salbutamol\nReview prices from 3 pharmacies',
    productImageVariant: null,
  ),
  Order(
    orderNumber: '#ORD-8410',
    date: 'Oct 12, 09:15 AM',
    itemCount: 1,
    total: 12.50,
    isDelivery: false,
    status: OrderStatus.delivered,
    productImageVariant: 1,
  ),
  Order(
    orderNumber: '#ORD-8402',
    date: 'Oct 05, 16:30 PM',
    itemCount: 4,
    total: 80.00,
    isDelivery: true,
    status: OrderStatus.cancelled,
    productImageVariant: 0,
  ),
];
