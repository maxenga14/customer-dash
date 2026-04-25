import 'package:flutter/material.dart';
import '../models/prescription.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class RxLineItem {
  const RxLineItem({
    required this.name,
    required this.subtitle,
    required this.price,
    required this.inStock,
  });
  final String name;
  final String subtitle;
  final double price;
  final bool inStock;
}

class RxDetailsScreen extends StatelessWidget {
  const RxDetailsScreen({super.key, required this.rx});
  final Prescription rx;

  static const _items = [
    RxLineItem(name: 'Amoxicillin 500mg', subtitle: 'Capsules • Qty: 20', price: 12.50, inStock: true),
    RxLineItem(name: 'Benylin Expectorant', subtitle: 'Syrup 100ml • Qty: 1', price: 8.00, inStock: true),
  ];

  static const _subtotal   = 20.50;
  static const _serviceFee = 2.00;
  static const _total      = 22.50;

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _rxImageHero(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _quotationReadyBanner(),
                          const SizedBox(height: 16),
                          _quotationBreakdown(),
                          const SizedBox(height: 16),
                          _pharmacistNote(),
                          const SizedBox(height: 80), // bottom action padding
                        ],
                      ),
                    ),
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

  // ── App bar ──────────────────────────────────────────────────────────
  Widget _appBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 15, color: AppColors.text),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Rx Details',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.text)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 6, height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0A529), shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text('Action Required',
                        style: TextStyle(fontSize: 10, color: Color(0xFFF0A529), fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(Icons.more_vert_rounded, size: 18, color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }

  // ── Prescription image hero ──────────────────────────────────────────
  Widget _rxImageHero() {
    return Stack(
      children: [
        // Image placeholder — dark blurred document feel
        Container(
          width: double.infinity,
          height: 190,
          color: const Color(0xFF2A2A2A),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Faint lined-paper texture via custom painter
              CustomPaint(painter: _PaperTexturePainter()),
              // Prescription text mock
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 90, height: 8, decoration: BoxDecoration(color: Colors.white.withOpacity(.6), borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 8),
                    ...List.generate(7, (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Container(
                        width: double.infinity * (0.6 + (i % 3) * 0.1),
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.25 + (i % 2) * 0.1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              // Gradient overlay bottom
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(.65)],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Bottom-left label overlay
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('John Doe',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text('Dr. iacuri, #RX16  •  Oct 24, 2023',
                              style: TextStyle(color: Colors.white.withOpacity(.8), fontSize: 9.5)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.fullscreen_rounded, color: Colors.white, size: 17),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Quotation ready banner ───────────────────────────────────────────
  Widget _quotationReadyBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCCDCF5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30, height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFFDDF6E9),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(Icons.description_outlined, size: 15, color: AppColors.green),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quotation Ready',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.text)),
                SizedBox(height: 3),
                Text('Pharmacy has reviewed\nand priced items.',
                    style: TextStyle(fontSize: 10.5, color: AppColors.muted, height: 1.45)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5DE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Pending Approval',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFFF0A529))),
          ),
        ],
      ),
    );
  }

  // ── Quotation breakdown ──────────────────────────────────────────────
  Widget _quotationBreakdown() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Quotation Breakdown',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('City Care Pharmacy',
                    style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: Color(0xFF5B8FC9))),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ..._items.map((item) => _itemRow(item)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFF0F3F6)),
          ),
          _summaryLine('Subtotal', '\$${_subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _summaryLine('Service Fee', '\$${_serviceFee.toStringAsFixed(2)}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFF0F3F6)),
          ),
          Row(
            children: [
              const Text('Total Quotation',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
              const Spacer(),
              Text('\$${_total.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.green)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemRow(RxLineItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.medication_outlined, size: 20, color: Color(0xFF5B8FC9)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(item.subtitle,
                    style: const TextStyle(fontSize: 10.2, color: AppColors.muted)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: item.inStock ? const Color(0xFFE9FAF1) : const Color(0xFFFFEEEE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.inStock ? '• In Stock' : '• Out of Stock',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: item.inStock ? AppColors.green : const Color(0xFFD14A4A),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryLine(String label, String value) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 11.5, color: AppColors.muted)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
      ],
    );
  }

  // ── Pharmacist note ──────────────────────────────────────────────────
  Widget _pharmacistNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pharmacist Note',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAF8),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: const Color(0xFFE0EBE3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    '"We substituted the generic Amoxicillin as requested in your profile preferences to save costs. All items are ready for immediate pickup or delivery."',
                    style: TextStyle(
                        fontSize: 11.2,
                        color: AppColors.text,
                        fontStyle: FontStyle.italic,
                        height: 1.55),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom actions ───────────────────────────────────────────────────
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
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.text,
                side: const BorderSide(color: Color(0xFFDDE3ED)),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Request Changes',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Approve & Checkout',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Paper texture painter ─────────────────────────────────────────────────
class _PaperTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(.05)
      ..strokeWidth = 1;
    for (double y = 20; y < size.height; y += 14) {
      canvas.drawLine(Offset(16, y), Offset(size.width - 16, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
