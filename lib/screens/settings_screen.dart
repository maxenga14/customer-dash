import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'saved_addresses_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _twoFactor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _appBar(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  _profileCard(),
                  const SizedBox(height: 22),

                  // ── ACCOUNT ──────────────────────────────────────
                  _groupLabel('ACCOUNT'),
                  const SizedBox(height: 8),
                  _menuGroup([
                    _MenuItem(
                      icon: Icons.person_outline_rounded,
                      label: 'Personal Information',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.location_on_outlined,
                      label: 'Saved Addresses',
                      onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const SavedAddressesScreen())),
                    ),
                    _MenuItem(
                      icon: Icons.credit_card_outlined,
                      label: 'Payment Methods',
                      onTap: () {},
                      isLast: true,
                    ),
                  ]),
                  const SizedBox(height: 22),

                  // ── PREFERENCES & SECURITY ────────────────────────
                  _groupLabel('PREFERENCES & SECURITY'),
                  const SizedBox(height: 8),
                  _menuGroup([
                    _MenuItem(
                      icon: Icons.notifications_none_rounded,
                      label: 'Push Notifications',
                      subtitle: 'Order updates & offers',
                      trailing: Switch(
                        value: _pushNotifications,
                        onChanged: (v) => setState(() => _pushNotifications = v),
                        activeColor: AppColors.green,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onTap: () => setState(() => _pushNotifications = !_pushNotifications),
                      showChevron: false,
                    ),
                    _MenuItem(
                      icon: Icons.lock_outline_rounded,
                      label: 'Change Password',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.shield_outlined,
                      label: 'Two-Factor Auth (2FA)',
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _twoFactor
                              ? const Color(0xFFE9FAF1)
                              : const Color(0xFFF0F3F7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _twoFactor ? 'On' : 'Off',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: _twoFactor ? AppColors.green : AppColors.muted,
                          ),
                        ),
                      ),
                      onTap: () => setState(() => _twoFactor = !_twoFactor),
                      showChevron: false,
                      isLast: true,
                    ),
                  ]),
                  const SizedBox(height: 22),

                  // ── SUPPORT & LEGAL ───────────────────────────────
                  _groupLabel('SUPPORT & LEGAL'),
                  const SizedBox(height: 8),
                  _menuGroup([
                    _MenuItem(
                      icon: Icons.help_outline_rounded,
                      label: 'Help Center',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.headset_mic_outlined,
                      label: 'Contact Support',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.description_outlined,
                      label: 'Terms & Privacy Policy',
                      onTap: () {},
                      isLast: true,
                    ),
                  ]),
                  const SizedBox(height: 22),

                  // ── Log Out ───────────────────────────────────────
                  _logoutButton(context),
                  const SizedBox(height: 14),
                  const Center(
                    child: Text('App Version 2.4.1',
                        style: TextStyle(fontSize: 10, color: AppColors.muted)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── App bar ────────────────────────────────────────────────────────
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
          const SizedBox(width: 10),
          const Expanded(
            child: Text('Settings',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.text)),
          ),
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.notifications_none_rounded,
                size: 18, color: AppColors.muted),
          ),
        ],
      ),
    );
  }

  // ── Profile card ───────────────────────────────────────────────────
  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: cardDecoration(),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFE2EAF5),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFCDD8EA), width: 2),
            ),
            child: const Icon(Icons.person_rounded,
                size: 28, color: Color(0xFF6E86AE)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('John Doe',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                const Text('+1 (555) 123-4567',
                    style: TextStyle(fontSize: 11, color: AppColors.green, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFDDE3ED)),
              ),
              child: const Text('Edit Profile',
                  style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Group label ────────────────────────────────────────────────────
  Widget _groupLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(text,
          style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.muted,
              letterSpacing: .4)),
    );
  }

  // ── Menu group card ────────────────────────────────────────────────
  Widget _menuGroup(List<_MenuItem> items) {
    return Container(
      decoration: cardDecoration(),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          final isLast = i == items.length - 1;
          return Column(
            children: [
              InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.circular(isLast ? 0 : 0).copyWith(
                  topLeft: i == 0 ? const Radius.circular(16) : Radius.zero,
                  topRight: i == 0 ? const Radius.circular(16) : Radius.zero,
                  bottomLeft: isLast ? const Radius.circular(16) : Radius.zero,
                  bottomRight: isLast ? const Radius.circular(16) : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  child: Row(
                    children: [
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(item.icon, size: 16, color: AppColors.muted),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.label,
                                style: const TextStyle(
                                    fontSize: 12.5, fontWeight: FontWeight.w600)),
                            if (item.subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(item.subtitle!,
                                  style: const TextStyle(
                                      fontSize: 10, color: AppColors.muted)),
                            ],
                          ],
                        ),
                      ),
                      if (item.trailing != null) item.trailing!,
                      if (item.showChevron)
                        const Icon(Icons.chevron_right_rounded,
                            size: 18, color: AppColors.muted),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                const Padding(
                  padding: EdgeInsets.only(left: 58),
                  child: Divider(height: 1, color: Color(0xFFF0F3F6)),
                ),
            ],
          );
        }),
      ),
    );
  }

  // ── Logout button ──────────────────────────────────────────────────
  Widget _logoutButton(BuildContext context) {
    return InkWell(
      onTap: () => _confirmLogout(context),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEBD0D0)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, size: 16, color: Color(0xFFD14A4A)),
            SizedBox(width: 8),
            Text('Log Out',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFD14A4A))),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDE3ED),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEEEE),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout_rounded,
                  size: 26, color: Color(0xFFD14A4A)),
            ),
            const SizedBox(height: 14),
            const Text('Log Out?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('Are you sure you want to log out of your account?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.muted, height: 1.5)),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFDDE3ED)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(
                            color: AppColors.text,
                            fontWeight: FontWeight.w700,
                            fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).popUntil((r) => r.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD14A4A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Log Out',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Simple menu item data class ───────────────────────────────────────────
class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.showChevron = true,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? subtitle;
  final Widget? trailing;
  final bool showChevron;
  final bool isLast;
}
