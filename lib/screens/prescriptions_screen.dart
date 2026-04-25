import 'package:flutter/material.dart';
import '../data/prescriptions_data.dart';
import '../models/prescription.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'upload_rx_screen.dart';

class PrescriptionsScreen extends StatelessWidget {
  const PrescriptionsScreen({super.key});

  int get _needsAction =>
      mockPrescriptions.where((p) => p.status == RxStatus.quotationReady).length;
  int get _verified =>
      mockPrescriptions.where((p) => p.status == RxStatus.verified).length +
      mockPrescriptions.where((p) => p.status == RxStatus.quotationReady).length +
      mockPrescriptions.where((p) => p.status == RxStatus.pendingReview).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  _statsRow(),
                  const SizedBox(height: 14),
                  _uploadButton(),
                  const SizedBox(height: 18),
                  ...mockPrescriptions.map((rx) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _RxCard(rx: rx),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────
  Widget _header(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Prescriptions',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text)),
                SizedBox(height: 2),
                Text('Manage your Rx',
                    style: TextStyle(fontSize: 11, color: AppColors.muted)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UploadRxScreen())),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFE9FAF1),
                borderRadius: BorderRadius.circular(11),
              ),
              child:
                  const Icon(Icons.add_rounded, size: 18, color: AppColors.green),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats row ─────────────────────────────────────────────────────────
  Widget _statsRow() {
    return Row(
      children: [
        Expanded(child: _statCard(
          icon: Icons.description_outlined,
          iconBg: const Color(0xFFFFF5DE),
          iconColor: const Color(0xFFF0A529),
          label: 'NEEDS ACTION',
          value: '$_needsAction',
        )),
        const SizedBox(width: 12),
        Expanded(child: _statCard(
          icon: Icons.verified_outlined,
          iconBg: const Color(0xFFE9FAF1),
          iconColor: AppColors.green,
          label: 'VERIFIED',
          value: '$_verified',
        )),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration:
                BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(11)),
            child: Icon(icon, size: 19, color: iconColor),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 9, color: AppColors.muted, fontWeight: FontWeight.w700, letterSpacing: .3)),
              const SizedBox(height: 4),
              Text(value,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.text)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Upload button ─────────────────────────────────────────────────────
  Widget _uploadButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UploadRxScreen())),
        icon: const Icon(Icons.upload_rounded, size: 18),
        label: const Text('Upload New Prescription',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }
}

// ── Rx Card ───────────────────────────────────────────────────────────────
class _RxCard extends StatelessWidget {
  const _RxCard({required this.rx});
  final Prescription rx;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Container(
            width: 58,
            height: 68,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F3F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _thumb(),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(rx.name,
                          style: const TextStyle(
                              fontSize: 12.5, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 6),
                    _StatusBadge(status: rx.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Uploaded: ${rx.uploadedAt}',
                    style: const TextStyle(fontSize: 10.2, color: AppColors.muted)),
                const SizedBox(height: 6),
                _bodyContent(),
                const SizedBox(height: 10),
                _actions(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _thumb() {
    IconData icon;
    Color color;
    switch (rx.status) {
      case RxStatus.rejected:
        icon = Icons.broken_image_outlined;
        color = const Color(0xFFD14A4A);
        break;
      case RxStatus.verified:
        icon = Icons.task_alt_rounded;
        color = AppColors.green;
        break;
      default:
        icon = Icons.description_outlined;
        color = const Color(0xFF6E86AE);
    }
    return Icon(icon, size: 26, color: color);
  }

  Widget _bodyContent() {
    switch (rx.status) {
      case RxStatus.quotationReady:
        return RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 11, color: AppColors.muted, height: 1.4),
            children: [
              TextSpan(text: '${rx.quotationPharmacy} offered '),
              TextSpan(
                text: '\$${rx.quotationPrice!.toStringAsFixed(2)}',
                style: const TextStyle(
                    color: AppColors.green, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        );
      case RxStatus.pendingReview:
        return Text(rx.statusNote ?? '',
            style: const TextStyle(fontSize: 10.8, color: AppColors.muted, height: 1.45));
      case RxStatus.verified:
        return Text(
          'Order ${rx.linkedOrderNumber} completed via\n${rx.linkedPharmacy}',
          style: const TextStyle(fontSize: 10.8, color: AppColors.muted, height: 1.45),
        );
      case RxStatus.rejected:
        return Text(rx.statusNote ?? '',
            style: const TextStyle(fontSize: 10.8, color: Color(0xFFD14A4A), height: 1.45));
    }
  }

  Widget _actions(BuildContext context) {
    return Row(
      children: [
        // Quick View / Re-upload link
        GestureDetector(
          onTap: () {},
          child: Text(
            rx.status == RxStatus.rejected ? 'Re-upload' : 'Quick View',
            style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.green,
                fontWeight: FontWeight.w700),
          ),
        ),
        const Spacer(),
        // Right CTA — only for quotationReady and verified
        if (rx.status == RxStatus.quotationReady)
          _ctaButton(
            label: 'Review',
            onTap: () {},
            filled: true,
          ),
        if (rx.status == RxStatus.verified)
          _ctaButton(
            label: 'Reorder',
            onTap: () {},
            filled: false,
          ),
      ],
    );
  }

  Widget _ctaButton({
    required String label,
    required VoidCallback onTap,
    required bool filled,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: filled ? AppColors.green : Colors.transparent,
          border: filled ? null : Border.all(color: const Color(0xFFDDE3ED)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: filled ? Colors.white : AppColors.text,
          ),
        ),
      ),
    );
  }
}

// ── Status badge ──────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final RxStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: status.badgeBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.badgeIcon, size: 10, color: status.badgeColor),
          const SizedBox(width: 3),
          Text(
            status.label,
            style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: status.badgeColor),
          ),
        ],
      ),
    );
  }
}
