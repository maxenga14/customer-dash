import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_profile.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});
  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  bool _saving = false;

  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _dob;
  late final TextEditingController _nin;
  late final TextEditingController _allergies;
  late final TextEditingController _chronic;
  late final TextEditingController _emergencyName;
  late final TextEditingController _emergencyPhone;
  late String _gender;
  late String _bloodType;
  Uint8List? _avatarBytes;

  static const _bloodTypes = [
    'A+',
    'A−',
    'B+',
    'B−',
    'AB+',
    'AB−',
    'O+',
    'O−',
    'Unknown'
  ];
  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  @override
  void initState() {
    super.initState();
    final p = UserProfile.instance.value;
    _name = TextEditingController(text: p.name);
    _phone = TextEditingController(text: p.phone);
    _email = TextEditingController(text: p.email);
    _dob = TextEditingController(text: p.dob);
    _nin = TextEditingController(text: p.nin);
    _allergies = TextEditingController(text: p.allergies);
    _chronic = TextEditingController(text: p.chronicConditions);
    _emergencyName = TextEditingController(text: p.emergencyName);
    _emergencyPhone = TextEditingController(text: p.emergencyPhone);
    _gender = p.gender;
    _bloodType = p.bloodType;
    _avatarBytes = p.avatarBytes;
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _phone,
      _email,
      _dob,
      _nin,
      _allergies,
      _chronic,
      _emergencyName,
      _emergencyPhone
    ]) c.dispose();
    super.dispose();
  }

  void _pickAvatar() => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (_) => SafeArea(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                    color: const Color(0xFFDDE3ED),
                    borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 18),
            const Text('Update Profile Photo',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text)),
            const SizedBox(height: 16),
            _sourceBtn(
                Icons.camera_alt_rounded, 'Take a Photo', ImageSource.camera),
            const SizedBox(height: 10),
            _sourceBtn(Icons.photo_library_outlined, 'Choose from Gallery',
                ImageSource.gallery),
            if (_avatarBytes != null) ...[
              const SizedBox(height: 10),
              ListTile(
                  leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFEEEE),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.delete_outline_rounded,
                          color: Color(0xFFD14A4A))),
                  title: const Text('Remove Photo',
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFD14A4A))),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _avatarBytes = null);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14))),
            ],
            const SizedBox(height: 8),
          ]),
        )),
      );

  Widget _sourceBtn(IconData icon, String label, ImageSource src) => ListTile(
      leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppColors.green, size: 20)),
      title: Text(label,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
      onTap: () async {
        Navigator.pop(context);
        final f = await _picker.pickImage(
            source: src, imageQuality: 80, maxWidth: 400);
        if (f != null) {
          final b = await f.readAsBytes();
          setState(() => _avatarBytes = b);
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)));

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    UserProfile.instance.update(UserProfile.instance.value.copyWith(
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      email: _email.text.trim(),
      dob: _dob.text.trim(),
      gender: _gender,
      bloodType: _bloodType,
      allergies:
          _allergies.text.trim().isEmpty ? 'None' : _allergies.text.trim(),
      chronicConditions:
          _chronic.text.trim().isEmpty ? 'None' : _chronic.text.trim(),
      nin: _nin.text.trim(),
      emergencyName: _emergencyName.text.trim(),
      emergencyPhone: _emergencyPhone.text.trim(),
      avatarBytes: _avatarBytes,
      clearAvatar: _avatarBytes == null,
    ));
    setState(() => _saving = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Profile updated ✓'),
        backgroundColor: AppColors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16)));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
            child: Column(children: [
          _bar(),
          Expanded(
              child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
            child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _avatarSection(),
                      const SizedBox(height: 28),
                      _sectionLabel('BASIC INFORMATION'),
                      const SizedBox(height: 8),
                      _card([
                        _field('Full Name', _name, Icons.person_outline_rounded,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Name is required'
                                : null),
                        _div(),
                        _field('Phone Number', _phone, Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            hint: '+255 7XX XXX XXX',
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Phone is required'
                                : null),
                        _div(),
                        _field('Email Address', _email, Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            hint: 'your@email.com'),
                        _div(),
                        _dobRow(),
                        _div(),
                        _genderRow(),
                      ]),
                      const SizedBox(height: 20),
                      _sectionLabel('NATIONAL ID'),
                      const SizedBox(height: 8),
                      _card([
                        _field('NIDA Number (NIN)', _nin, Icons.badge_outlined,
                            hint: 'XXXXXXXXXX-XXXXX-XXXXX-XX')
                      ]),
                      const SizedBox(height: 20),
                      _sectionLabel('MEDICAL INFORMATION'),
                      const SizedBox(height: 8),
                      _card([
                        _bloodTypeRow(),
                        _div(),
                        _field('Known Allergies', _allergies,
                            Icons.warning_amber_outlined,
                            hint: 'e.g. Penicillin, Ibuprofen'),
                        _div(),
                        _field('Chronic Conditions', _chronic,
                            Icons.monitor_heart_outlined,
                            hint: 'e.g. Hypertension, Diabetes'),
                      ]),
                      const SizedBox(height: 20),
                      _sectionLabel('EMERGENCY CONTACT'),
                      const SizedBox(height: 8),
                      _card([
                        _field('Contact Name', _emergencyName,
                            Icons.person_add_alt_1_outlined,
                            hint: 'Full name'),
                        _div(),
                        _field('Contact Phone', _emergencyPhone,
                            Icons.phone_forwarded_outlined,
                            keyboardType: TextInputType.phone,
                            hint: '+255 7XX XXX XXX'),
                      ]),
                      const SizedBox(height: 28),
                      _saveBtn(),
                    ])),
          )),
        ])),
      );

  Widget _bar() => Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2EAC0))),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: AppColors.green),
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
            child: Text('Personal Information',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text))),
      ]));

  Widget _avatarSection() => Center(
          child: Column(children: [
        GestureDetector(
            onTap: _pickAvatar,
            child: Stack(children: [
              Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.green, width: 2.5),
                      color: const Color(0xFFE2EAF5)),
                  child: _avatarBytes != null
                      ? ClipOval(
                          child: Image.memory(_avatarBytes!,
                              fit: BoxFit.cover, width: 96, height: 96))
                      : const Icon(Icons.person_rounded,
                          size: 50, color: Color(0xFF6E86AE))),
              Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: AppColors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.green.withOpacity(.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3))
                          ]),
                      child: const Icon(Icons.camera_alt_rounded,
                          size: 15, color: Colors.white))),
            ])),
        const SizedBox(height: 10),
        GestureDetector(
            onTap: _pickAvatar,
            child: const Text('Tap to change photo',
                style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.green,
                    fontWeight: FontWeight.w600))),
      ]));

  Widget _sectionLabel(String t) => Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(t,
          style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.muted,
              letterSpacing: .5)));

  Widget _card(List<Widget> children) => Container(
      decoration: cardDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: children));

  Widget _div() => const Divider(height: 1, color: AppColors.border);

  Widget _field(String label, TextEditingController c, IconData icon,
          {TextInputType? keyboardType,
          String? hint,
          String? Function(String?)? validator}) =>
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: TextFormField(
              controller: c,
              keyboardType: keyboardType,
              validator: validator,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text),
              decoration: InputDecoration(
                  labelText: label,
                  hintText: hint,
                  labelStyle:
                      const TextStyle(fontSize: 11, color: AppColors.muted),
                  hintStyle:
                      const TextStyle(fontSize: 12, color: AppColors.muted),
                  prefixIcon: Icon(icon, size: 18, color: AppColors.muted),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12))));

  Widget _dobRow() => GestureDetector(
      onTap: () async {
        final p = await showDatePicker(
            context: context,
            initialDate: DateTime(1990, 3, 15),
            firstDate: DateTime(1940),
            lastDate: DateTime.now(),
            builder: (ctx, child) => Theme(
                data: Theme.of(ctx).copyWith(
                    colorScheme:
                        const ColorScheme.light(primary: AppColors.green)),
                child: child!));
        if (p != null) _dob.text = '${p.day} ${_months[p.month - 1]} ${p.year}';
      },
      child: AbsorbPointer(
          child: TextFormField(
              controller: _dob,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  labelStyle: TextStyle(fontSize: 11, color: AppColors.muted),
                  prefixIcon: Icon(Icons.cake_outlined,
                      size: 18, color: AppColors.muted),
                  suffixIcon: Icon(Icons.calendar_today_outlined,
                      size: 15, color: AppColors.muted),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12)))));

  Widget _genderRow() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(children: [
        const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.wc_outlined, size: 18, color: AppColors.muted)),
        const Text('Gender',
            style: TextStyle(fontSize: 11, color: AppColors.muted)),
        const Spacer(),
        ...['Male', 'Female', 'Other'].map((g) => GestureDetector(
            onTap: () => setState(() => _gender = g),
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                margin: const EdgeInsets.only(left: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                    color: _gender == g ? AppColors.green : AppColors.bg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color:
                            _gender == g ? AppColors.green : AppColors.border)),
                child: Text(g,
                    style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color:
                            _gender == g ? Colors.white : AppColors.muted))))),
      ]));

  Widget _bloodTypeRow() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.bloodtype_outlined, size: 18, color: AppColors.muted),
          SizedBox(width: 16),
          Text('Blood Type',
              style: TextStyle(fontSize: 11, color: AppColors.muted)),
        ]),
        const SizedBox(height: 10),
        Padding(
            padding: const EdgeInsets.only(left: 34),
            child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _bloodTypes
                    .map((bt) => GestureDetector(
                        onTap: () => setState(() => _bloodType = bt),
                        child: AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                                color: _bloodType == bt
                                    ? const Color(0xFFE05454)
                                    : AppColors.bg,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: _bloodType == bt
                                        ? const Color(0xFFE05454)
                                        : AppColors.border)),
                            child: Text(bt,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: _bloodType == bt
                                        ? Colors.white
                                        : AppColors.muted)))))
                    .toList())),
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
              : const Text('Save Changes',
                  style:
                      TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700))));
}
