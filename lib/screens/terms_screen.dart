import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});
  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  int _tab = 0; // 0=Terms, 1=Privacy

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
          child: Column(children: [
        _bar(context),
        _tabRow(),
        Expanded(
            child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
          child: _tab == 0 ? _termsContent() : _privacyContent(),
        )),
      ])),
    );
  }

  Widget _bar(BuildContext context) => Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
      child: Row(children: [
        _backBtn(context),
        const SizedBox(width: 10),
        const Expanded(
            child: Text('Terms & Privacy Policy',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text))),
      ]));

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

  Widget _tabRow() => Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(children: [
        _tabBtn('Terms of Service', 0),
        const SizedBox(width: 10),
        _tabBtn('Privacy Policy', 1),
      ]));

  Widget _tabBtn(String label, int index) => GestureDetector(
      onTap: () => setState(() => _tab = index),
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
              color: _tab == index ? AppColors.green : AppColors.bg,
              borderRadius: BorderRadius.circular(20)),
          child: Text(label,
              style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: _tab == index ? Colors.white : AppColors.muted))));

  Widget _section(String title, String body) => Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: AppColors.text)),
        const SizedBox(height: 8),
        Text(body,
            style: const TextStyle(
                fontSize: 12.5, color: AppColors.muted, height: 1.7)),
      ]));

  Widget _termsContent() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: AppColors.lightGreen,
                borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              const Icon(Icons.info_outline_rounded,
                  size: 18, color: AppColors.green),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(
                      'By using Afya Hub, you agree to these terms. Last updated: April 2025.',
                      style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.green,
                          height: 1.5))),
            ])),
        const SizedBox(height: 20),
        _section('1. Acceptance of Terms',
            'By accessing or using Afya Hub, you agree to be bound by these Terms of Service. If you disagree with any part of the terms, you may not access the service.'),
        _section('2. Use of Service',
            'Afya Hub is a platform connecting users with licensed pharmacies. You must be at least 18 years old to use this service. You are responsible for maintaining the confidentiality of your account credentials.'),
        _section('3. Prescription Policy',
            'Uploading a fraudulent or altered prescription is illegal and will result in immediate account termination and may be reported to relevant authorities under the Pharmacy and Poisons Act.'),
        _section('4. Delivery & Fulfillment',
            'Delivery times are estimates and may vary. Afya Hub is not liable for delays caused by third-party logistics providers, natural disasters, or other events beyond our control.'),
        _section('5. Returns & Refunds',
            'Prescription medications are non-returnable once dispensed. Non-prescription items may be returned within 7 days in original, unopened condition.'),
        _section('6. Liability Limitation',
            'Afya Hub is not a medical provider. Always consult a licensed healthcare professional for medical advice. We are not liable for adverse reactions to medications dispensed by partner pharmacies.'),
        _section('7. Changes to Terms',
            'We reserve the right to modify these terms at any time. Continued use of the service after changes constitutes acceptance of the new terms.'),
      ]);

  Widget _privacyContent() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: const Color(0xFFEAF3FF),
                borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              const Icon(Icons.shield_outlined,
                  size: 18, color: Color(0xFF5B8FC9)),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(
                      'Your privacy matters. We comply with the Tanzania Data Protection Act 2019.',
                      style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF5B8FC9),
                          height: 1.5))),
            ])),
        const SizedBox(height: 20),
        _section('1. Data We Collect',
            'We collect information you provide (name, email, phone, address), prescription images, order history, device identifiers, and usage analytics to improve the service.'),
        _section('2. How We Use Your Data',
            'Your data is used to process orders, communicate updates, improve our platform, and comply with legal obligations. We do not sell your personal data to third parties.'),
        _section('3. Data Security',
            'All data is encrypted at rest (AES-256) and in transit (TLS 1.3). Prescription images are stored in isolated, access-controlled storage with audit logging.'),
        _section('4. Data Retention',
            'We retain your data for as long as your account is active. Prescription records are retained for 5 years as required by Tanzanian pharmacy regulations.'),
        _section('5. Your Rights',
            'You have the right to access, correct, or delete your personal data. Contact privacy@afyahub.co.tz to exercise these rights. We will respond within 30 days.'),
        _section('6. Cookies',
            'Our app uses session cookies for authentication and analytics cookies to understand usage patterns. You may disable analytics cookies in app settings.'),
        _section('7. Contact Us',
            'For privacy concerns, contact our Data Protection Officer at privacy@afyahub.co.tz or +255 700 987 654.'),
      ]);
}
