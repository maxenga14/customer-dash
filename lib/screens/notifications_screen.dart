import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _NotifItem {
  _NotifItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
  });
  final IconData icon;
  final Color iconBg, iconColor;
  final String title, body, time;
  bool isRead;
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<_NotifItem> _today;
  late List<_NotifItem> _earlier;

  @override
  void initState() {
    super.initState();
    _today = [
      _NotifItem(
        icon: Icons.local_shipping_outlined,
        iconBg: AppColors.softYellow,
        iconColor: AppColors.yellow,
        title: 'Order #ORD-8478 is on the way',
        body: 'Your order has been picked up and is heading your way.',
        time: '10:45 AM',
      ),
      _NotifItem(
        icon: Icons.check_circle_outline_rounded,
        iconBg: AppColors.lightGreen,
        iconColor: AppColors.green,
        title: 'Prescription approved',
        body: "Dr. Mwangi's Rx has been reviewed. Quotation ready.",
        time: '09:30 AM',
        isRead: true,
      ),
    ];
    _earlier = [
      _NotifItem(
        icon: Icons.receipt_long_outlined,
        iconBg: AppColors.blueSoft,
        iconColor: const Color(0xFF5B8FC9),
        title: 'Order #ORD-8438 delivered',
        body: 'Your order was successfully delivered. Rate your experience.',
        time: 'Yesterday',
        isRead: true,
      ),
      _NotifItem(
        icon: Icons.savings_outlined,
        iconBg: AppColors.lightGreen,
        iconColor: AppColors.green,
        title: 'Generic alternative available',
        body: 'Amoxicillin 500mg has a cheaper generic option — Tsh 3,500 vs Tsh 7,500.',
        time: 'Yesterday',
        isRead: true,
      ),
      _NotifItem(
        icon: Icons.cancel_outlined,
        iconBg: const Color(0xFFFFEEEE),
        iconColor: const Color(0xFFD14A4A),
        title: 'Order #ORD-8402 cancelled',
        body: 'Your order was cancelled. Tap to see reason.',
        time: 'Oct 05',
        isRead: true,
      ),
    ];
  }

  int get _unreadCount =>
      _today.where((n) => !n.isRead).length +
      _earlier.where((n) => !n.isRead).length;

  void _markAllRead() => setState(() {
        for (final n in [..._today, ..._earlier]) n.isRead = true;
      });

  @override
  Widget build(BuildContext context) {
    final allEmpty = _today.isEmpty && _earlier.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(children: [
          // ── AppBar ────────────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
            child: Row(children: [
              IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  color: AppColors.text,
                  onPressed: () => Navigator.pop(context)),
              const Expanded(
                  child: Text('Notifications',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800,
                          color: AppColors.text))),
              if (_unreadCount > 0)
                TextButton(
                  onPressed: _markAllRead,
                  child: const Text('Mark all read',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.green,
                          fontWeight: FontWeight.w700)),
                ),
            ]),
          ),

          // ── Body ──────────────────────────────────────────────────────
          Expanded(
            child: allEmpty
                ? _emptyState()
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (_today.isNotEmpty) ...[
                        _groupLabel('Today'),
                        const SizedBox(height: 8),
                        ..._today.map((n) => _notifCard(n)),
                        const SizedBox(height: 16),
                      ],
                      if (_earlier.isNotEmpty) ...[
                        _groupLabel('Earlier'),
                        const SizedBox(height: 8),
                        ..._earlier.map((n) => _notifCard(n)),
                      ],
                    ],
                  ),
          ),
        ]),
      ),
    );
  }

  Widget _notifCard(_NotifItem n) => GestureDetector(
        onTap: () => setState(() => n.isRead = true),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: n.isRead ? AppColors.border : AppColors.green.withOpacity(.2)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.03),
                    blurRadius: 8, offset: const Offset(0, 2))
              ]),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                      color: n.iconBg, borderRadius: BorderRadius.circular(12)),
                  child: Icon(n.icon, size: 20, color: n.iconColor)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    Expanded(
                        child: Text(n.title,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: n.isRead ? FontWeight.w600 : FontWeight.w800,
                                color: AppColors.text))),
                    const SizedBox(width: 8),
                    if (!n.isRead)
                      Container(
                          width: 8, height: 8,
                          decoration: const BoxDecoration(
                              color: AppColors.green, shape: BoxShape.circle)),
                  ]),
                  const SizedBox(height: 3),
                  Text(n.body,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.muted, height: 1.4)),
                  const SizedBox(height: 4),
                  Text(n.time,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.muted)),
                ]),
              ),
            ]),
          ),
        ),
      );

  Widget _groupLabel(String label) => Text(label,
      style: const TextStyle(
          fontSize: 11, fontWeight: FontWeight.w700,
          color: AppColors.muted, letterSpacing: .6));

  Widget _emptyState() => Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                  color: AppColors.bg, borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.notifications_none_rounded,
                  size: 36, color: AppColors.muted)),
          const SizedBox(height: 16),
          const Text("You're all caught up",
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700,
                  color: AppColors.text)),
          const SizedBox(height: 6),
          const Text('No new notifications right now.',
              style: TextStyle(fontSize: 12.5, color: AppColors.muted)),
        ]),
      );
}
