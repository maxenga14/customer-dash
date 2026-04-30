import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../theme/app_theme.dart';

class MedicalProfileScreen extends StatefulWidget {
  const MedicalProfileScreen({super.key});
  @override
  State<MedicalProfileScreen> createState() => _MedicalProfileScreenState();
}

class _MedicalProfileScreenState extends State<MedicalProfileScreen> {
  late TextEditingController _allergiesCtrl;
  late TextEditingController _conditionsCtrl;
  late TextEditingController _medicationsCtrl;
  late String _bloodType;
  bool _preferGenerics = false;
  bool _saving = false;

  static const _bloodTypes = [
    'A+', 'A−', 'B+', 'B−', 'AB+', 'AB−', 'O+', 'O−', 'Unknown'
  ];

  @override
  void initState() {
    super.initState();
    final p = UserProfile.instance.value;
    _allergiesCtrl = TextEditingController(text: p.allergies);
    _conditionsCtrl = TextEditingController(text: p.chronicConditions);
    _medicationsCtrl = TextEditingController(text: '');
    _bloodType = p.bloodType;
  }

  @override
  void dispose() {
    _allergiesCtrl.dispose();
    _conditionsCtrl.dispose();
    _medicationsCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 600));
    UserProfile.instance.update(UserProfile.instance.value.copyWith(
      allergies: _allergiesCtrl.text.trim(),
      chronicConditions: _conditionsCtrl.text.trim(),
      bloodType: _bloodType,
    ));
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Medical profile updated'),
          backgroundColor: AppColors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(children: [
          // ── AppBar ────────────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
            child: Row(children: [
              IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  color: AppColors.text,
                  onPressed: () => Navigator.pop(context)),
              const Expanded(
                  child: Text('Medical Profile',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800,
                          color: AppColors.text))),
            ]),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ── Blood type ────────────────────────────────────────
                _card(children: [
                  _sectionLabel('Blood Type'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: _bloodTypes.map((bt) {
                      final sel = _bloodType == bt;
                      return GestureDetector(
                        onTap: () => setState(() => _bloodType = bt),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                              color: sel ? AppColors.green : AppColors.bg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: sel ? AppColors.green : AppColors.border)),
                          child: Text(bt,
                              style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: sel ? Colors.white : AppColors.muted)),
                        ),
                      );
                    }).toList(),
                  ),
                ]),
                const SizedBox(height: 12),

                // ── Allergies ─────────────────────────────────────────
                _card(children: [
                  _sectionLabel('Known Allergies'),
                  const SizedBox(height: 6),
                  const Text(
                      'List any medications, foods, or substances you are allergic to.',
                      style: TextStyle(fontSize: 12, color: AppColors.muted, height: 1.4)),
                  const SizedBox(height: 10),
                  _textArea(_allergiesCtrl, 'e.g. Penicillin, Aspirin, or None'),
                ]),
                const SizedBox(height: 12),

                // ── Chronic conditions ────────────────────────────────
                _card(children: [
                  _sectionLabel('Chronic Conditions'),
                  const SizedBox(height: 6),
                  const Text(
                      'e.g. Diabetes, Hypertension, Asthma.',
                      style: TextStyle(fontSize: 12, color: AppColors.muted, height: 1.4)),
                  const SizedBox(height: 10),
                  _textArea(_conditionsCtrl, 'e.g. Type 2 Diabetes, or None'),
                ]),
                const SizedBox(height: 12),

                // ── Current medications ───────────────────────────────
                _card(children: [
                  _sectionLabel('Current Medications'),
                  const SizedBox(height: 6),
                  const Text(
                      'Medications you take regularly — helps pharmacists check for interactions.',
                      style: TextStyle(fontSize: 12, color: AppColors.muted, height: 1.4)),
                  const SizedBox(height: 10),
                  _textArea(_medicationsCtrl, 'e.g. Metformin 850mg daily, or None'),
                ]),
                const SizedBox(height: 12),

                // ── Suggest generics toggle ───────────────────────────
                _card(children: [
                  Row(children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        const Text('Suggest Cheaper Alternatives',
                            style: TextStyle(
                                fontSize: 13.5, fontWeight: FontWeight.w700,
                                color: AppColors.text)),
                        const SizedBox(height: 3),
                        const Text(
                            'Show generic equivalents at checkout when available. Same active ingredient, lower cost.',
                            style: TextStyle(
                                fontSize: 11.5, color: AppColors.muted,
                                height: 1.4)),
                      ]),
                    ),
                    const SizedBox(width: 12),
                    Switch(
                        value: _preferGenerics,
                        onChanged: (v) => setState(() => _preferGenerics = v),
                        activeColor: AppColors.green,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  ]),
                  if (_preferGenerics) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: AppColors.lightGreen,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        const Icon(Icons.savings_outlined,
                            size: 14, color: AppColors.green),
                        const SizedBox(width: 8),
                        const Expanded(
                            child: Text(
                                'Generic suggestions will appear at checkout when your pharmacy stocks them.',
                                style: TextStyle(
                                    fontSize: 11.5, color: AppColors.green,
                                    height: 1.4))),
                      ]),
                    ),
                  ],
                ]),
                const SizedBox(height: 24),

                // ── Save button ───────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14))),
                    child: _saving
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Text('Save Medical Profile',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14)),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _card({required List<Widget> children}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.04),
                  blurRadius: 12, offset: const Offset(0, 4))
            ]),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: children),
      );

  Widget _sectionLabel(String label) => Text(label,
      style: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text));

  Widget _textArea(TextEditingController ctrl, String hint) => TextField(
        controller: ctrl,
        maxLines: 3,
        style: const TextStyle(fontSize: 13, color: AppColors.text),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 13, color: AppColors.muted),
          filled: true,
          fillColor: AppColors.bg,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.green, width: 1.5)),
        ),
      );
}
