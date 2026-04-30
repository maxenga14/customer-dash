import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'change_password_screen.dart';
import 'contact_support_screen.dart';
import 'help_center_screen.dart';
import 'personal_info_screen.dart';
import 'saved_addresses_screen.dart';
import 'terms_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _smsAlerts = true;
  bool _twoFactor = false;
  bool _biometrics = true;

  void _push(Widget screen) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));

  void _confirmLogout() => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (_) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: const Color(0xFFDDE3ED),
                    borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 22),
            Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                    color: Color(0xFFFFEEEE), shape: BoxShape.circle),
                child: const Icon(Icons.logout_rounded,
                    size: 28, color: Color(0xFFD14A4A))),
            const SizedBox(height: 14),
            const Text('Log Out?',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('You will need to sign in again to access your account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12.5, color: AppColors.muted, height: 1.5)),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(
                  child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14))),
                      child: const Text('Cancel',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.text)))),
              const SizedBox(width: 12),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD14A4A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14))),
                      child: const Text('Log Out',
                          style: TextStyle(fontWeight: FontWeight.w700)))),
            ]),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _profileHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── ACCOUNT ──────────────────────────────────────────
                    _groupLabel('ACCOUNT'),
                    const SizedBox(height: 8),
                    _menuGroup([
                      _menuItem(
                          Icons.person_outline_rounded, 'Personal Information',
                          subtitle: 'Name, email, phone, gender',
                          onTap: () => _push(const PersonalInfoScreen())),
                      _menuItem(Icons.location_on_outlined, 'Saved Addresses',
                          subtitle: 'Manage delivery locations',
                          onTap: () => _push(const SavedAddressesScreen())),
                    ]),
                    const SizedBox(height: 22),

                    // ── NOTIFICATIONS ─────────────────────────────────────
                    _groupLabel('NOTIFICATIONS'),
                    const SizedBox(height: 8),
                    _menuGroup([
                      _menuItem(Icons.notifications_none_rounded,
                          'Push Notifications',
                          subtitle: 'Order updates & offers',
                          trailing: Switch(
                              value: _pushNotifications,
                              onChanged: (v) =>
                                  setState(() => _pushNotifications = v),
                              activeColor: AppColors.green,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap),
                          onTap: () => setState(
                              () => _pushNotifications = !_pushNotifications),
                          showChevron: false),
                      _menuItem(Icons.sms_outlined, 'SMS Alerts',
                          subtitle: 'Delivery confirmations via SMS',
                          trailing: Switch(
                              value: _smsAlerts,
                              onChanged: (v) => setState(() => _smsAlerts = v),
                              activeColor: AppColors.green,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap),
                          onTap: () => setState(() => _smsAlerts = !_smsAlerts),
                          showChevron: false,
                          isLast: true),
                    ]),
                    const SizedBox(height: 22),

                    // ── SECURITY ──────────────────────────────────────────
                    _groupLabel('SECURITY'),
                    const SizedBox(height: 8),
                    _menuGroup([
                      _menuItem(Icons.lock_outline_rounded, 'Change Password',
                          subtitle: 'Update your login password',
                          onTap: () => _push(const ChangePasswordScreen())),
                      _menuItem(Icons.fingerprint_rounded, 'Biometric Login',
                          subtitle: 'Use fingerprint or Face ID',
                          trailing: Switch(
                              value: _biometrics,
                              onChanged: (v) => setState(() => _biometrics = v),
                              activeColor: AppColors.green,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap),
                          onTap: () =>
                              setState(() => _biometrics = !_biometrics),
                          showChevron: false),
                      _menuItem(Icons.shield_outlined, 'Two-Factor Auth (2FA)',
                          subtitle: '6-digit code via SMS',
                          trailing: _twoFactorBadge(),
                          onTap: () => setState(() => _twoFactor = !_twoFactor),
                          showChevron: false,
                          isLast: true),
                    ]),
                    const SizedBox(height: 22),

                    // ── SUPPORT & LEGAL ───────────────────────────────────
                    _groupLabel('SUPPORT & LEGAL'),
                    const SizedBox(height: 8),
                    _menuGroup([
                      _menuItem(Icons.help_outline_rounded, 'Help Center',
                          subtitle: 'FAQs and guides',
                          onTap: () => _push(const HelpCenterScreen())),
                      _menuItem(Icons.headset_mic_outlined, 'Contact Support',
                          subtitle: 'Chat, call or email us',
                          onTap: () => _push(const ContactSupportScreen())),
                      _menuItem(
                          Icons.description_outlined, 'Terms & Privacy Policy',
                          subtitle: 'Legal documents',
                          onTap: () => _push(const TermsScreen()),
                          isLast: true),
                    ]),
                    const SizedBox(height: 22),

                    // ── DANGER ZONE ───────────────────────────────────────
                    _groupLabel('ACCOUNT ACTIONS'),
                    const SizedBox(height: 8),
                    _menuGroup([
                      _menuItem(Icons.logout_rounded, 'Log Out',
                          iconColor: const Color(0xFFD14A4A),
                          labelColor: const Color(0xFFD14A4A),
                          onTap: _confirmLogout,
                          isLast: true),
                    ]),
                    const SizedBox(height: 16),

                    Center(
                        child: Text('Afya Hub v2.4.1 · Made in Tanzania 🇹🇿',
                            style: TextStyle(
                                fontSize: 10, color: AppColors.muted))),
                    const SizedBox(height: 24),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileHeader() => ValueListenableBuilder<UserProfileData>(
        valueListenable: UserProfile.instance,
        builder: (context, profile, _) => GestureDetector(
          onTap: () => _push(const PersonalInfoScreen()),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [AppColors.greenDark, AppColors.green],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28)),
            ),
            child: Column(children: [
              const SizedBox(height: 20),
              Stack(alignment: Alignment.bottomRight, children: [
                Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: const Color(0xFFE2EAF5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3)),
                    child: profile.avatarBytes != null
                        ? ClipOval(
                            child: Image.memory(profile.avatarBytes!,
                                fit: BoxFit.cover, width: 80, height: 80))
                        : const Icon(Icons.person_rounded,
                            size: 42, color: Color(0xFF6E86AE))),
                Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.green, width: 2)),
                    child: const Icon(Icons.camera_alt_rounded,
                        size: 13, color: AppColors.green)),
              ]),
              const SizedBox(height: 10),
              Text(profile.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 3),
              Text(profile.phone,
                  style: const TextStyle(
                      color: Color(0xFFD0F5E8), fontSize: 11.5)),
              const SizedBox(height: 4),
              const Text('Tap to edit profile',
                  style: TextStyle(
                      color: Color(0xFFADE8CE),
                      fontSize: 10,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.12),
                      borderRadius: BorderRadius.circular(18)),
                  child: Row(children: [
                    _stat('12', 'Orders'),
                    _statDivider(),
                    _stat('4', 'Addresses'),
                    _statDivider(),
                    _stat('3', 'Rx Uploads'),
                    _statDivider(),
                    _stat('2 yrs', 'Member'),
                  ]),
                ),
              ),
              const SizedBox(height: 20),
            ]),
          ),
        ),
      );

  Widget _stat(String value, String label) => Expanded(
          child: Column(children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 3),
        Text(label,
            style: const TextStyle(color: Color(0xFFD0F5E8), fontSize: 9.5)),
      ]));

  Widget _statDivider() =>
      Container(width: 1, height: 28, color: Colors.white.withOpacity(.25));

  // ── Group label ─────────────────────────────────────────────────────
  Widget _groupLabel(String text) => Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(text,
          style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.muted,
              letterSpacing: .5)));

  // ── Menu group container ────────────────────────────────────────────
  Widget _menuGroup(List<Widget> items) =>
      Container(decoration: cardDecoration(), child: Column(children: items));

  // ── Single menu row ─────────────────────────────────────────────────
  Widget _menuItem(
    IconData icon,
    String label, {
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    bool showChevron = true,
    bool isLast = false,
    Color? iconColor,
    Color? labelColor,
  }) {
    final int index = 0; // just for border logic below
    return Column(children: [
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isLast ? 16 : 0).copyWith(
          topLeft: Radius.zero,
          topRight: Radius.zero,
          bottomLeft: isLast ? const Radius.circular(16) : Radius.zero,
          bottomRight: isLast ? const Radius.circular(16) : Radius.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
          child: Row(children: [
            Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    color: iconColor != null
                        ? iconColor.withOpacity(.08)
                        : AppColors.bg,
                    borderRadius: BorderRadius.circular(10)),
                child:
                    Icon(icon, size: 18, color: iconColor ?? AppColors.muted)),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: labelColor ?? AppColors.text)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.muted)),
                  ],
                ])),
            if (trailing != null) trailing,
            if (showChevron && trailing == null)
              const Icon(Icons.chevron_right_rounded,
                  size: 18, color: AppColors.muted),
          ]),
        ),
      ),
      if (!isLast)
        const Divider(height: 1, indent: 62, color: AppColors.border),
    ]);
  }

  Widget _twoFactorBadge() => AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: _twoFactor ? AppColors.lightGreen : AppColors.bg,
          borderRadius: BorderRadius.circular(20)),
      child: Text(_twoFactor ? 'On' : 'Off',
          style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: _twoFactor ? AppColors.green : AppColors.muted)));
}
