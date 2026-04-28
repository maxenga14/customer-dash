import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});
  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  String _category = 'Order Issue';
  bool _sending = false;
  bool _sent = false;

  final _categories = [
    'Order Issue', 'Prescription', 'Payment', 'Delivery', 'Account', 'Other',
  ];

  @override
  void dispose() { _subjectCtrl.dispose(); _messageCtrl.dispose(); super.dispose(); }

  Future<void> _send() async {
    if (_subjectCtrl.text.trim().isEmpty || _messageCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please fill in subject and message'),
        backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16)));
      return;
    }
    setState(() => _sending = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() { _sending = false; _sent = true; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(children: [
          _bar(context),
          Expanded(
            child: _sent ? _successView(context) : _formView(),
          ),
        ]),
      ),
    );
  }

  Widget _bar(BuildContext context) => Container(
    color: Colors.white,
    padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
    child: Row(children: [
      _backBtn(context), const SizedBox(width: 10),
      const Expanded(child: Text('Contact Support',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.text))),
    ]));

  Widget _formView() => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Channel cards
      _sectionLabel('REACH US VIA'),
      const SizedBox(height: 10),
      Row(children: [
        _channelCard(Icons.chat_bubble_outline_rounded, 'Live Chat', 'Avg. 2 min', AppColors.green, const Color(0xFFE9FAF1)),
        const SizedBox(width: 10),
        _channelCard(Icons.phone_outlined, 'Call Us', '+254 700 123 456', const Color(0xFF5B8FC9), const Color(0xFFEAF3FF)),
        const SizedBox(width: 10),
        _channelCard(Icons.email_outlined, 'Email', 'support@pharmaflow', const Color(0xFFF0A529), const Color(0xFFFFF5DE)),
      ]),
      const SizedBox(height: 26),
      _sectionLabel('SEND A MESSAGE'),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: cardDecoration(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Category chips
          const Text('Category',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.muted)),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: _categories.map((c) {
            final sel = c == _category;
            return GestureDetector(
              onTap: () => setState(() => _category = c),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: sel ? AppColors.green : AppColors.bg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: sel ? AppColors.green : AppColors.border)),
                child: Text(c, style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w600,
                    color: sel ? Colors.white : AppColors.muted)),
              ),
            );
          }).toList()),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 16),
          // Subject
          const Text('Subject',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.muted)),
          const SizedBox(height: 8),
          TextField(
            controller: _subjectCtrl,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Brief description of your issue',
              hintStyle: const TextStyle(fontSize: 12.5, color: AppColors.muted),
              filled: true, fillColor: AppColors.bg,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.green, width: 1.5))),
          ),
          const SizedBox(height: 14),
          const Text('Message',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.muted)),
          const SizedBox(height: 8),
          TextField(
            controller: _messageCtrl,
            maxLines: 5,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Describe your issue in detail...',
              hintStyle: const TextStyle(fontSize: 12.5, color: AppColors.muted),
              filled: true, fillColor: AppColors.bg,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.green, width: 1.5))),
          ),
        ]),
      ),
      const SizedBox(height: 24),
      SizedBox(width: double.infinity,
        child: ElevatedButton(
          onPressed: _sending ? null : _send,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green, foregroundColor: Colors.white,
            elevation: 0, padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
          child: _sending
              ? const SizedBox(width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Send Message',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
        )),
    ]),
  );

  Widget _channelCard(IconData icon, String title, String sub, Color color, Color bg) =>
    Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 8, offset: const Offset(0, 3))]),
      child: Column(children: [
        Container(width: 40, height: 40,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Icon(icon, size: 20, color: color)),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.text)),
        const SizedBox(height: 2),
        Text(sub, style: const TextStyle(fontSize: 9.5, color: AppColors.muted), textAlign: TextAlign.center),
      ]),
    ));

  Widget _sectionLabel(String t) => Text(t,
      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
          color: AppColors.muted, letterSpacing: .4));

  Widget _successView(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 80, height: 80,
          decoration: const BoxDecoration(color: AppColors.lightGreen, shape: BoxShape.circle),
          child: const Icon(Icons.check_circle_outline_rounded, size: 42, color: AppColors.green)),
        const SizedBox(height: 20),
        const Text('Message Sent!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.text)),
        const SizedBox(height: 10),
        const Text('We\'ve received your message and will\nget back to you within 2 hours.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.muted, height: 1.6)),
        const SizedBox(height: 32),
        SizedBox(width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green, foregroundColor: Colors.white,
                elevation: 0, padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
            child: const Text('Back to Settings',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)))),
      ]),
    ),
  );
}
