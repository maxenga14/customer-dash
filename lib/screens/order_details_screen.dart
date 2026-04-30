import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'checkout_screen.dart';
import '../utils/formatters.dart';


/// Represents one item in an order for the details view
class OrderLineItem {
  const OrderLineItem({
    required this.name,
    required this.subtitle,
    required this.price,
    required this.qty,
    this.imageBg = const Color(0xFFEAF3FF),
  });
  final String name;
  final String subtitle;
  final double price;
  final int qty;
  final Color imageBg;
}

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({
    super.key,
    required this.order,
    this.hasPrescription = false,
  });

  final Order order;
  final bool hasPrescription;

  bool get _isOnRoute => order.status == OrderStatus.processing;
  bool get _isDelivered => order.status == OrderStatus.delivered;

  // Sample line items — in production these come from the order model
  static final _items = [
    const OrderLineItem(name: 'Paracetamol 500mg', subtitle: 'Pack of 16', price: 2500, qty: 1, imageBg: Color(0xFFEAF3FF)),
    const OrderLineItem(name: 'Benylin Dry Cough', subtitle: '150ml bottle', price: 8000, qty: 1, imageBg: Color(0xFFFFF1F1)),
  ];

  /// Static version so other screens (e.g. OrdersScreen) can reorder without
  /// needing an instance. In production, pass real items from the order object.
  static List<CartItem> itemsForOrder(Order order) => _items
      .map((item) => CartItem(
            name: item.name,
            subtitle: item.subtitle,
            price: item.price,
            quantity: item.qty,
          ))
      .toList();

  /// Converts this order's line items into CartItems ready for CheckoutScreen.
  List<CartItem> get _asCartItems => _items
      .map((item) => CartItem(
            name: item.name,
            subtitle: item.subtitle,
            price: item.price,
            quantity: item.qty,
          ))
      .toList();

  void _reorder(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 320),
        reverseTransitionDuration: const Duration(milliseconds: 260),
        pageBuilder: (_, animation, __) => SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(
                  parent: animation, curve: Curves.easeOutCubic)),
          child: CheckoutScreen(initialItems: _asCartItems),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _appBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── prescription banner (on-route + has Rx only)
                    if (_isOnRoute && hasPrescription) ...[
                      _prescriptionBanner(),
                      const SizedBox(height: 14),
                    ],

                    // ── order status timeline
                    _sectionCard(
                      title: 'Order Status',
                      child: _timeline(),
                    ),
                    const SizedBox(height: 14),

                    // ── items
                    _sectionCard(
                      title: 'Items (${_items.length})',
                      child: Column(
                        children: _items
                            .map((item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _itemRow(item),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── delivery address
                    _sectionCard(
                      title: 'Delivery Address',
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.lightGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.location_on_outlined,
                                size: 16, color: AppColors.green),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Home',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                                SizedBox(height: 3),
                                Text(
                                  '123 Uhuru Street, Apt 4C\nDar es Salaam, Tanzania',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.muted,
                                      height: 1.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── payment summary
                    _paymentSummary(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _bottomActions(context),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // App bar
  // ────────────────────────────────────────────────────────────
  Widget _appBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 15, color: AppColors.text),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Order Details',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text)),
              Text(order.orderNumber,
                  style: const TextStyle(fontSize: 10.5, color: AppColors.muted)),
            ],
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // Prescription banner
  // ────────────────────────────────────────────────────────────
  Widget _prescriptionBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCCDCF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFF5B8FC9).withOpacity(.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.description_outlined,
                    size: 15, color: Color(0xFF5B8FC9)),
              ),
              const SizedBox(width: 10),
              const Text('Prescription Quotation Ready',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2C5F9A))),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'We\'ve found matching substitutes for your uploaded prescription. Please review and confirm to proceed.',
            style: TextStyle(fontSize: 10.8, color: Color(0xFF4A6FA5), height: 1.5),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B8FC9),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 11),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Review & Confirm',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // Order status timeline
  // ────────────────────────────────────────────────────────────
  Widget _timeline() {
    // Steps: (label, subtitle, reached, isActive)
    final steps = _buildSteps();
    return Column(
      children: List.generate(steps.length, (i) {
        final s = steps[i];
        final isLast = i == steps.length - 1;
        return _timelineStep(
          label: s['label'] as String,
          sub: s['sub'] as String,
          reached: s['reached'] as bool,
          isActive: s['active'] as bool,
          showLine: !isLast,
          driverCard: s['driver'] as bool,
        );
      }),
    );
  }

  List<Map<String, dynamic>> _buildSteps() {
    if (_isDelivered) {
      return [
        {'label': 'Order Placed', 'sub': order.date, 'reached': true, 'active': false, 'driver': false},
        {'label': 'Processing', 'sub': 'We were packing your items', 'reached': true, 'active': false, 'driver': false},
        {'label': 'On Route', 'sub': 'Rider delivered to your location', 'reached': true, 'active': false, 'driver': false},
        {'label': 'Delivered', 'sub': 'Estimated: 2:30 PM – 3:00 PM', 'reached': true, 'active': true, 'driver': false},
      ];
    }
    // on-route
    return [
      {'label': 'Order Placed', 'sub': order.date, 'reached': true, 'active': false, 'driver': false},
      {'label': 'Processing', 'sub': 'We are packing your items', 'reached': true, 'active': false, 'driver': false},
      {'label': 'On Route', 'sub': 'Rider is heading to your location', 'reached': true, 'active': true, 'driver': true},
      {'label': 'Delivered', 'sub': 'Estimated: 2:30 PM – 3:00 PM', 'reached': false, 'active': false, 'driver': false},
    ];
  }

  Widget _timelineStep({
    required String label,
    required String sub,
    required bool reached,
    required bool isActive,
    required bool showLine,
    required bool driverCard,
  }) {
    final dotColor = reached ? AppColors.green : const Color(0xFFDDE3ED);
    final lineColor = reached && showLine ? AppColors.green : const Color(0xFFDDE3ED);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // dot + line column
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor,
                    boxShadow: reached
                        ? [BoxShadow(color: AppColors.green.withOpacity(.25), blurRadius: 6, spreadRadius: 1)]
                        : [],
                  ),
                  child: reached
                      ? const Icon(Icons.check_rounded, size: 10, color: Colors.white)
                      : null,
                ),
                if (showLine)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: lineColor,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isActive ? AppColors.green : AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(sub,
                      style: const TextStyle(
                          fontSize: 10.5, color: AppColors.muted)),
                  if (driverCard) ...[
                    const SizedBox(height: 10),
                    _driverCard(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _driverCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE5EAF0)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFDDF6E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_rounded,
                color: AppColors.green, size: 20),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Michael T.',
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700)),
                SizedBox(height: 2),
                Text('OVA 098 • Motorcycle',
                    style: TextStyle(fontSize: 10, color: AppColors.muted)),
              ],
            ),
          ),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.green,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.call_rounded,
                color: Colors.white, size: 17),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // Item row
  // ────────────────────────────────────────────────────────────
  Widget _itemRow(OrderLineItem item) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: item.imageBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.medication_outlined,
              color: Color(0xFF6E86AE), size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text(item.subtitle,
                  style: const TextStyle(
                      fontSize: 10.2, color: AppColors.muted)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(formatTsh(item.price),
                style: const TextStyle(
                    fontSize: 12.5, fontWeight: FontWeight.w700)),
            const SizedBox(height: 3),
            Text('Qty ${item.qty}',
                style: const TextStyle(
                    fontSize: 10, color: AppColors.muted)),
          ],
        ),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────
  // Payment summary
  // ────────────────────────────────────────────────────────────
  Widget _paymentSummary() {
    const subtotal = 23.00;
    const delivery = 2.50;
    const discount = 1.00;
    final total = subtotal + delivery - discount;

    return _sectionCard(
      title: 'Payment Summary',
      child: Column(
        children: [
          _payRow('Subtotal', formatTsh(subtotal)),
          const SizedBox(height: 8),
          _payRow('Delivery Fee', formatTsh(delivery)),
          const SizedBox(height: 8),
          _payRow('Discount', '-${formatTsh(discount)}',
              valueColor: AppColors.green),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFF0F3F6)),
          ),
          Row(
            children: [
              const Text('Total Paid',
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w800)),
              const Spacer(),
              Text(formatTsh(total),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.green)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.phone_iphone_rounded,
                    size: 16, color: AppColors.muted),
                SizedBox(width: 8),
                Text('Paid via M-PESA',
                    style: TextStyle(
                        fontSize: 11.5, fontWeight: FontWeight.w600)),
                Spacer(),
                Text('Successful',
                    style: TextStyle(
                        fontSize: 10.5,
                        color: AppColors.green,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _payRow(String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11.5, color: AppColors.muted)),
        const Spacer(),
        Text(value,
            style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: valueColor ?? AppColors.text)),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────
  // Bottom actions
  // ────────────────────────────────────────────────────────────
  Widget _bottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 12,
              offset: const Offset(0, -3))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.headset_mic_outlined, size: 15),
              label: const Text('Support',
                  style:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.text,
                side: const BorderSide(color: Color(0xFFDDE3ED)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _reorder(context),
              icon: const Icon(Icons.replay_rounded, size: 15),
              label: const Text('Reorder',
                  style:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // Helpers
  // ────────────────────────────────────────────────────────────
  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 12.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
