import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/prescription.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'checkout_screen.dart';
import '../utils/formatters.dart';


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
    RxLineItem(
        name: 'Amoxicillin 500mg',
        subtitle: 'Capsules • Qty: 20',
        price: 12500,
        inStock: true),
    RxLineItem(
        name: 'Benylin Expectorant',
        subtitle: 'Syrup 100ml • Qty: 1',
        price: 8000,
        inStock: true),
  ];

  static const _subtotal = 20.50;
  static const _serviceFee = 2.00;
  static const _total = 22.50;

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Rx Details',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0A529),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text('Action Required',
                        style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFFF0A529),
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(Icons.more_vert_rounded,
                  size: 18, color: AppColors.text),
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
                    Container(
                        width: 90,
                        height: 8,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.6),
                            borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 8),
                    ...List.generate(
                        7,
                        (i) => Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Container(
                                width: double.infinity * (0.6 + (i % 3) * 0.1),
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.white
                                      .withOpacity(.25 + (i % 2) * 0.1),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            )),
                  ],
                ),
              ),
              // Gradient overlay bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(.65)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Bottom-left label overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('John Doe',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text('Dr. iacuri, #RX16  •  Oct 24, 2023',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(.8),
                                  fontSize: 9.5)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.fullscreen_rounded,
                      color: Colors.white, size: 17),
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
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFFDDF6E9),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(Icons.description_outlined,
                size: 15, color: AppColors.green),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quotation Ready',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text)),
                SizedBox(height: 3),
                Text('Pharmacy has reviewed\nand priced items.',
                    style: TextStyle(
                        fontSize: 10.5, color: AppColors.muted, height: 1.45)),
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
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFF0A529))),
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
                  style:
                      TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('City Care Pharmacy',
                    style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5B8FC9))),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ..._items.map((item) => _itemRow(item)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFF0F3F6)),
          ),
          _summaryLine('Subtotal', formatTsh(_subtotal)),
          const SizedBox(height: 8),
          _summaryLine('Service Fee', formatTsh(_serviceFee)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFF0F3F6)),
          ),
          Row(
            children: [
              const Text('Total Quotation',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
              const Spacer(),
              Text(formatTsh(_total),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.green)),
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
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.medication_outlined,
                size: 20, color: Color(0xFF5B8FC9)),
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
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: item.inStock
                      ? const Color(0xFFE9FAF1)
                      : const Color(0xFFFFEEEE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.inStock ? '• In Stock' : '• Out of Stock',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: item.inStock
                        ? AppColors.green
                        : const Color(0xFFD14A4A),
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
        Text(label,
            style: const TextStyle(fontSize: 11.5, color: AppColors.muted)),
        const Spacer(),
        Text(value,
            style:
                const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
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
  // ── Converts quotation line items into CartItems for CheckoutScreen ──
  List<CartItem> _toCartItems() => _items
      .map((i) => CartItem(name: i.name, subtitle: i.subtitle, price: i.price))
      .toList();

  // ── Approve & Checkout ────────────────────────────────────────────────
  void _goToCheckout(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 320),
        reverseTransitionDuration: const Duration(milliseconds: 260),
        pageBuilder: (_, animation, __) => SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: CheckoutScreen(initialItems: _toCartItems()),
        ),
      ),
    );
  }

  // ── Request Changes bottom sheet ──────────────────────────────────────
  void _openRequestChanges(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RequestChangesSheet(
        onSent: () {
          Navigator.pop(context); // close sheet
          // Pop RxDetails back to prescription list with a snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(children: [
                Icon(Icons.check_circle_outline, color: Colors.white, size: 17),
                SizedBox(width: 10),
                Text('Change request sent — pharmacy will review shortly',
                    style: TextStyle(fontSize: 12)),
              ]),
              backgroundColor: AppColors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
          Navigator.pop(context); // pop RxDetails → back to Rx list
        },
      ),
    );
  }

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
              onPressed: () => _openRequestChanges(context),
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
              onPressed: () => _goToCheckout(context),
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
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
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

// ════════════════════════════════════════════════════════════════════════════
// Request Changes — bottom sheet
// ════════════════════════════════════════════════════════════════════════════
class _RequestChangesSheet extends StatefulWidget {
  const _RequestChangesSheet({required this.onSent});
  final VoidCallback onSent;

  @override
  State<_RequestChangesSheet> createState() => _RequestChangesSheetState();
}

class _RequestChangesSheetState extends State<_RequestChangesSheet> {
  final _msgCtrl = TextEditingController();
  final _focusNode = FocusNode();
  int? _selectedReason; // index into _reasons list

  static const _reasons = [
    ('Too expensive', Icons.price_change_outlined),
    ('Wrong medication', Icons.medication_outlined),
    ('Need generic brand', Icons.swap_horiz_rounded),
    ('Remove an item', Icons.remove_circle_outline),
    ('Other / custom note', Icons.edit_note_rounded),
  ];

  bool get _canSend =>
      _selectedReason != null || _msgCtrl.text.trim().isNotEmpty;

  @override
  void dispose() {
    _msgCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Push sheet up when keyboard appears
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle ────────────────────────────────────────────────
            const SizedBox(height: 10),
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDE3ED),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 18),

            // ── Header ────────────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Request Changes',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.text)),
                        SizedBox(height: 3),
                        Text('Tell the pharmacy what you\'d like updated',
                            style: TextStyle(
                                fontSize: 11, color: AppColors.muted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Divider(height: 1, color: Color(0xFFF0F3F7)),
            const SizedBox(height: 14),

            // ── Quick reasons ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(_reasons.length, (i) {
                  final selected = _selectedReason == i;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedReason = selected ? null : i);
                      if (i == 4) {
                        // "Other" → focus text field
                        Future.delayed(const Duration(milliseconds: 120),
                            () => _focusNode.requestFocus());
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFFE9FAF1)
                            : const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? AppColors.green
                              : const Color(0xFFDDE3ED),
                          width: selected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(
                          _reasons[i].$2,
                          size: 13,
                          color: selected ? AppColors.green : AppColors.muted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _reasons[i].$1,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: selected ? AppColors.green : AppColors.text,
                          ),
                        ),
                      ]),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            // ── Custom message field ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _msgCtrl,
                focusNode: _focusNode,
                maxLines: 3,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(fontSize: 12.5, color: AppColors.text),
                decoration: InputDecoration(
                  hintText: 'Describe the change you need, e.g. "Please use a '
                      'generic version of Amoxicillin to reduce cost"',
                  hintStyle: const TextStyle(
                      fontSize: 11.5, color: AppColors.muted, height: 1.45),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  contentPadding: const EdgeInsets.all(13),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFDDE3ED))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFDDE3ED))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          const BorderSide(color: AppColors.green, width: 1.5)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Send button ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _canSend ? widget.onSent : null,
                  icon: const Icon(Icons.send_rounded, size: 16),
                  label: const Text('Send Request',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFE0EAE6),
                    disabledForegroundColor: AppColors.muted,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
