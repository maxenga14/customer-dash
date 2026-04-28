import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class _FAQ {
  const _FAQ(this.q, this.a);
  final String q, a;
}

const _faqs = [
  _FAQ('How do I upload a prescription?',
      'Go to the Rx tab and tap "Upload Prescription". You can take a photo or pick from your gallery. Once submitted, a pharmacist reviews it within 30 minutes.'),
  _FAQ('How long does delivery take?',
      'Standard delivery takes 1–3 hours within Nairobi. You can track your order in real-time from the Orders tab.'),
  _FAQ('Can I reorder a previous prescription?',
      'Yes. Open any past order in the Orders tab and tap "Reorder". Items will be pre-filled in your cart.'),
  _FAQ('How do I change or cancel an order?',
      'You can request changes while the order is in "Pending" status. Open the order and tap "Request Changes". Once dispatched, cancellation is not possible.'),
  _FAQ('What payment methods are accepted?',
      'We accept M-Pesa (STK Push), Visa, and Mastercard. Manage your payment methods in Settings → Payment Methods.'),
  _FAQ('Is my health data secure?',
      'All prescription data is encrypted at rest and in transit. We comply with Kenya Data Protection Act 2019. We never share your data with third parties.'),
  _FAQ('How do I set a default delivery address?',
      'Go to Settings → Saved Addresses and tap "Set as Default" under any address.'),
];

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});
  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final _search = TextEditingController();
  String _query = '';
  final Set<int> _expanded = {};

  List<_FAQ> get _filtered => _faqs
      .where((f) =>
          _query.isEmpty ||
          f.q.toLowerCase().contains(_query.toLowerCase()) ||
          f.a.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _bar(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  _searchBox(),
                  const SizedBox(height: 20),
                  _quickLinks(),
                  const SizedBox(height: 24),
                  _sectionLabel('FREQUENTLY ASKED QUESTIONS'),
                  const SizedBox(height: 10),
                  ..._filtered
                      .asMap()
                      .entries
                      .map((e) => _faqTile(e.key, e.value)),
                  if (_filtered.isEmpty) _emptySearch(),
                  const SizedBox(height: 24),
                  _contactBanner(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bar(BuildContext context) => Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
        child: Row(children: [
          _backBtn(context),
          const SizedBox(width: 10),
          const Expanded(
              child: Text('Help Center',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text))),
        ]),
      );

  Widget _backBtn(BuildContext context) => InkWell(
        onTap: () => Navigator.pop(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
              color: AppColors.bg, borderRadius: BorderRadius.circular(11)),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 15, color: AppColors.text),
        ),
      );

  Widget _searchBox() => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4))
            ]),
        child: TextField(
          controller: _search,
          onChanged: (v) => setState(() => _query = v),
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Search for help...',
            hintStyle: const TextStyle(fontSize: 13, color: AppColors.muted),
            prefixIcon: const Icon(Icons.search_rounded,
                size: 20, color: AppColors.muted),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded,
                        size: 18, color: AppColors.muted),
                    onPressed: () {
                      _search.clear();
                      setState(() => _query = '');
                    })
                : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      );

  Widget _quickLinks() {
    final links = [
      (
        Icons.local_shipping_outlined,
        'Track Order',
        AppColors.green,
        const Color(0xFFE9FAF1)
      ),
      (
        Icons.assignment_return_outlined,
        'Returns',
        const Color(0xFF5B8FC9),
        const Color(0xFFEAF3FF)
      ),
      (
        Icons.receipt_long_outlined,
        'Billing',
        const Color(0xFFF0A529),
        const Color(0xFFFFF5DE)
      ),
      (
        Icons.shield_outlined,
        'Privacy',
        const Color(0xFF9B6FDF),
        const Color(0xFFF3EEFF)
      ),
    ];
    return Row(
      children: links
          .map((l) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3))
                          ]),
                      child: Column(children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                              color: l.$4, shape: BoxShape.circle),
                          child: Icon(l.$1, size: 18, color: l.$3),
                        ),
                        const SizedBox(height: 8),
                        Text(l.$2,
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.text)),
                      ]),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _sectionLabel(String t) => Text(t,
      style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.muted,
          letterSpacing: .4));

  Widget _faqTile(int index, _FAQ faq) {
    final open = _expanded.contains(index);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: open ? AppColors.green.withOpacity(.3) : AppColors.border),
          boxShadow: [
            if (open)
              BoxShadow(
                  color: AppColors.green.withOpacity(.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4))
          ]),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(
                () => open ? _expanded.remove(index) : _expanded.add(index)),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                        color: open ? AppColors.lightGreen : AppColors.bg,
                        shape: BoxShape.circle),
                    child: Icon(Icons.help_outline_rounded,
                        size: 15,
                        color: open ? AppColors.green : AppColors.muted),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(faq.q,
                        style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: open ? AppColors.green : AppColors.text)),
                  ),
                  Icon(
                      open
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: AppColors.muted),
                ],
              ),
            ),
          ),
          if (open) ...[
            const Divider(height: 1, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.fromLTRB(54, 12, 16, 16),
              child: Text(faq.a,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.muted, height: 1.6)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _emptySearch() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(children: [
          Icon(Icons.search_off_rounded,
              size: 48, color: AppColors.muted.withOpacity(.4)),
          const SizedBox(height: 12),
          const Text('No results found',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.muted)),
          const SizedBox(height: 4),
          const Text('Try different keywords or contact support',
              style: TextStyle(fontSize: 11.5, color: AppColors.muted)),
        ]),
      );

  Widget _contactBanner(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF17A772), Color(0xFF118B62)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20)),
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text('Still need help?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                const Text('Our support team is online\n24/7 to assist you.',
                    style: TextStyle(
                        color: Color(0xFFD0F5E8), fontSize: 11.5, height: 1.5)),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.green,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text('Contact Support',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ])),
          const SizedBox(width: 12),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(.15), shape: BoxShape.circle),
            child: const Icon(Icons.support_agent_rounded,
                color: Colors.white, size: 28),
          ),
        ]),
      );
}
