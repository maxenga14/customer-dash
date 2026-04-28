import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({
    super.key,
    required this.orderNumber,
    required this.itemsTotal,
    required this.deliveryFee,
    required this.deliveryAddress,
    required this.paymentPhone,
    required this.isDelivery,
    this.onOrderPlaced,
  });

  final String orderNumber;
  final double itemsTotal;
  final double deliveryFee;
  final String deliveryAddress;
  final String paymentPhone;
  final bool isDelivery;
  final VoidCallback? onOrderPlaced; // clears the dashboard cart
  final VoidCallback? onGoHome;       // switches DashboardScreen to Home tab

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen>
    with TickerProviderStateMixin {
  // Pulsating ring controllers
  late final AnimationController _ring1;
  late final AnimationController _ring2;
  late final AnimationController _ring3;
  // Icon pop-in controller
  late final AnimationController _iconEntry;

  @override
  void initState() {
    super.initState();
    _ring1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat();
    _ring2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat();
    _ring3 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat();
    _iconEntry = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));

    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) _iconEntry.forward();
    });
    // Stagger ring animations
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _ring1.repeat();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _ring2.repeat();
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _ring3.repeat();
    });

    // Auto-dismiss: after 5 s clear cart and return to dashboard
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      widget.onOrderPlaced?.call();
      widget.onGoHome?.call();
      Navigator.of(context).popUntil((r) => r.isFirst);
    });
  }

  @override
  void dispose() {
    _ring1.dispose();
    _ring2.dispose();
    _ring3.dispose();
    _iconEntry.dispose();
    super.dispose();
  }

  double get total =>
      widget.itemsTotal + (widget.isDelivery ? widget.deliveryFee : 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 36),
                    _pulsatingCheck(),
                    const SizedBox(height: 20),
                    const Text(
                      'Order Confirmed!',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Your order has been placed successfully.\nWe've sent a receipt to your email.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11.5, color: AppColors.muted, height: 1.5),
                    ),
                    const SizedBox(height: 22),
                    _orderNumberRow(),
                    const SizedBox(height: 14),
                    if (widget.isDelivery)
                      _infoCard(
                        icon: Icons.local_shipping_outlined,
                        iconBg: const Color(0xFFE9FAF1),
                        iconColor: AppColors.green,
                        title: 'Estimated Delivery',
                        subtitle: 'Today, 2:30 PM – 3:00 PM',
                      ),
                    if (!widget.isDelivery)
                      _infoCard(
                        icon: Icons.storefront_outlined,
                        iconBg: const Color(0xFFEAF3FF),
                        iconColor: const Color(0xFF5B8FC9),
                        title: 'Ready for Pickup',
                        subtitle: 'MediCare Central Pharmacy · Uhuru Street',
                      ),
                    const SizedBox(height: 14),
                    _deliveryDetailsCard(),
                    const SizedBox(height: 14),
                    _receiptCard(),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onOrderPlaced?.call();
                          widget.onGoHome?.call();
                          Navigator.of(context).popUntil((r) => r.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                        ),
                        child: const Text('Back to Dashboard',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 13)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextButton(
                      onPressed: () {
                        widget.onOrderPlaced?.call();
                        widget.onGoHome?.call();
                        Navigator.of(context).popUntil((r) => r.isFirst);
                      },
                      child: const Text('Continue Shopping',
                          style: TextStyle(
                              fontSize: 12.5,
                              color: AppColors.text,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pulsatingCheck() {
    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          AnimatedBuilder(
            animation: _ring1,
            builder: (_, __) {
              final v = Tween<double>(begin: 0, end: 1)
                  .animate(
                    CurvedAnimation(parent: _ring1, curve: Curves.easeOut),
                  )
                  .value;
              return Opacity(
                opacity: (1 - v).clamp(0.0, 1.0),
                child: Container(
                  width: 60 + v * 60,
                  height: 60 + v * 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.green.withOpacity((1 - v) * 0.3),
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          ),
          // Middle ring
          AnimatedBuilder(
            animation: _ring2,
            builder: (_, __) {
              // final raw = (_ring2.value + 0.25) % 1.0;
              final v = Tween<double>(begin: 0, end: 1)
                  .animate(
                    CurvedAnimation(
                      parent: _ring2,
                      curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
                    ),
                  )
                  .value;
              return Opacity(
                opacity: (1 - v).clamp(0.0, 1.0),
                child: Container(
                  width: 55 + v * 50,
                  height: 55 + v * 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.green.withOpacity((1 - v) * 0.25),
                      width: 1.5,
                    ),
                  ),
                ),
              );
            },
          ),
          // Green check circle
          ScaleTransition(
            scale:
                CurvedAnimation(parent: _iconEntry, curve: Curves.elasticOut),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.green,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.green.withOpacity(.28),
                      blurRadius: 22,
                      spreadRadius: 2,
                      offset: const Offset(0, 6)),
                ],
              ),
              child: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 34),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderNumberRow() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ORDER NUMBER',
                  style: TextStyle(
                      fontSize: 9.2,
                      color: AppColors.muted,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .3)),
              const SizedBox(height: 5),
              Text(widget.orderNumber,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBCF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.pending_outlined, size: 12, color: AppColors.yellow),
                SizedBox(width: 4),
                Text('PROCESSING',
                    style: TextStyle(
                        fontSize: 9.2,
                        fontWeight: FontWeight.w700,
                        color: AppColors.yellow)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 19, color: iconColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.muted,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _deliveryDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Delivery Details',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 17, color: AppColors.muted),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Home Address',
                      style: TextStyle(fontSize: 10, color: AppColors.muted)),
                  const SizedBox(height: 3),
                  Text(widget.deliveryAddress,
                      style: const TextStyle(
                          fontSize: 11.6, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF0F3F6)),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.phone_iphone_rounded,
                  size: 17, color: AppColors.muted),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Payment Method',
                      style: TextStyle(fontSize: 10, color: AppColors.muted)),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                          widget.paymentPhone.isEmpty
                              ? 'M-Pesa (STK Push)'
                              : widget.paymentPhone,
                          style: const TextStyle(
                              fontSize: 11.6, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                            color: const Color(0xFFDDF6E9),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Text('Paid',
                            style: TextStyle(
                                fontSize: 9.2,
                                color: AppColors.green,
                                fontWeight: FontWeight.w700)),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _receiptCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Receipt Summary',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          _receiptLine(
              'Items (${(widget.itemsTotal / 14).ceil()})', widget.itemsTotal),
          if (widget.isDelivery) ...[
            const SizedBox(height: 8),
            _receiptLine('Delivery Fee', widget.deliveryFee),
          ],
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: Color(0xFFF0F3F6))),
          Row(
            children: [
              const Text('Total Paid',
                  style:
                      TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800)),
              const Spacer(),
              Text('\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.green)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _receiptLine(String label, double amount) {
    return Row(
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.muted,
                fontWeight: FontWeight.w500)),
        const Spacer(),
        Text('\$${amount.toStringAsFixed(2)}',
            style:
                const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
      ],
    );
  }

}
