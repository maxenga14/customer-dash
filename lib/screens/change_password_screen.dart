import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _showCurrent = false, _showNew = false, _showConfirm = false;
  bool _saving = false;

  bool get _hasMinLength => _newCtrl.text.length >= 8;
  bool get _hasNumber => _newCtrl.text.contains(RegExp(r'\d'));
  bool get _hasUpper => _newCtrl.text.contains(RegExp(r'[A-Z]'));
  bool get _passwordsMatch =>
      _newCtrl.text == _confirmCtrl.text && _newCtrl.text.isNotEmpty;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_currentCtrl.text.isEmpty ||
        _newCtrl.text.isEmpty ||
        _confirmCtrl.text.isEmpty) {
      _snack('Please fill in all fields', isError: true);
      return;
    }
    if (!_hasMinLength || !_hasNumber || !_hasUpper) {
      _snack('New password does not meet requirements', isError: true);
      return;
    }
    if (!_passwordsMatch) {
      _snack('Passwords do not match', isError: true);
      return;
    }
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() => _saving = false);
    _snack('Password updated successfully');
    Navigator.pop(context);
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: isError ? const Color(0xFFD14A4A) : AppColors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
          child: Column(children: [
        _bar(context),
        Expanded(
            child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
          child: Column(children: [
            _lockIcon(),
            const SizedBox(height: 24),
            _fieldsCard(),
            const SizedBox(height: 16),
            _strengthCard(),
            const SizedBox(height: 24),
            _saveBtn(),
          ]),
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
            child: Text('Change Password',
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

  Widget _lockIcon() => Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
          color: AppColors.lightGreen,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: AppColors.green.withOpacity(.15),
                blurRadius: 20,
                offset: const Offset(0, 8))
          ]),
      child: const Icon(Icons.lock_outline_rounded,
          size: 34, color: AppColors.green));

  Widget _fieldsCard() => Container(
      padding: const EdgeInsets.all(16),
      decoration: cardDecoration(),
      child: Column(children: [
        _passwordField('Current Password', _currentCtrl, _showCurrent,
            () => setState(() => _showCurrent = !_showCurrent)),
        const Divider(height: 1, color: AppColors.border),
        _passwordField('New Password', _newCtrl, _showNew,
            () => setState(() => _showNew = !_showNew),
            onChange: (_) => setState(() {})),
        const Divider(height: 1, color: AppColors.border),
        _passwordField('Confirm New Password', _confirmCtrl, _showConfirm,
            () => setState(() => _showConfirm = !_showConfirm),
            onChange: (_) => setState(() {})),
      ]));

  Widget _passwordField(String label, TextEditingController ctrl, bool show,
          VoidCallback toggleShow, {void Function(String)? onChange}) =>
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: TextField(
              controller: ctrl,
              obscureText: !show,
              onChanged: onChange,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                  labelText: label,
                  labelStyle:
                      const TextStyle(fontSize: 11, color: AppColors.muted),
                  prefixIcon: const Icon(Icons.lock_outline_rounded,
                      size: 18, color: AppColors.muted),
                  suffixIcon: IconButton(
                      icon: Icon(
                          show
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: AppColors.muted),
                      onPressed: toggleShow),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10))));

  Widget _strengthCard() => Container(
      padding: const EdgeInsets.all(16),
      decoration: cardDecoration(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Password Requirements',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.text)),
        const SizedBox(height: 12),
        _requirement('At least 8 characters', _hasMinLength),
        _requirement('Contains a number (0-9)', _hasNumber),
        _requirement('Contains an uppercase letter', _hasUpper),
        _requirement('Passwords match', _passwordsMatch),
      ]));

  Widget _requirement(String label, bool met) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: met ? AppColors.green : AppColors.bg,
                border: Border.all(
                    color: met ? AppColors.green : AppColors.border,
                    width: 1.5)),
            child: met
                ? const Icon(Icons.check_rounded, size: 12, color: Colors.white)
                : null),
        const SizedBox(width: 10),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: met ? AppColors.green : AppColors.muted)),
      ]));

  Widget _saveBtn() => SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: _saving ? null : _save,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18))),
          child: _saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : const Text('Update Password',
                  style:
                      TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700))));
}
