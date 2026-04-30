import 'package:flutter/material.dart';
import '../data/family_data.dart';
import '../models/family_member.dart';
import '../theme/app_theme.dart';

class FamilyManagementScreen extends StatefulWidget {
  const FamilyManagementScreen({super.key});
  @override
  State<FamilyManagementScreen> createState() => _FamilyManagementScreenState();
}

class _FamilyManagementScreenState extends State<FamilyManagementScreen> {
  final List<FamilyMember> _members = List.from(mockFamilyMembers);

  void _openSheet({FamilyMember? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '');
    final dobCtrl = TextEditingController(text: existing?.dob ?? '');
    final allergyCtrl = TextEditingController(text: existing?.allergies ?? 'None');
    String rel = existing?.relationship ?? FamilyMember.relationships.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 32),
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(4))),
              ),
              const SizedBox(height: 18),
              Text(existing == null ? 'Add Family Member' : 'Edit Member',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800,
                      color: AppColors.text)),
              const SizedBox(height: 18),
              _field(nameCtrl, 'Full Name', 'e.g. Amina Juma'),
              const SizedBox(height: 14),
              // Relationship picker
              const Text('Relationship',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                      color: AppColors.muted)),
              const SizedBox(height: 6),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: FamilyMember.relationships.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final r = FamilyMember.relationships[i];
                    final sel = rel == r;
                    return GestureDetector(
                      onTap: () => setS(() => rel = r),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                            color: sel ? AppColors.green : AppColors.bg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: sel ? AppColors.green : AppColors.border)),
                        child: Text(r,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: sel ? Colors.white : AppColors.muted)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              _field(phoneCtrl, 'Phone Number', '+255 7XX XXX XXX',
                  type: TextInputType.phone),
              const SizedBox(height: 14),
              _field(dobCtrl, 'Date of Birth (optional)', 'e.g. 10 Jan 2018'),
              const SizedBox(height: 14),
              _field(allergyCtrl, 'Known Allergies', 'e.g. Penicillin, or None'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameCtrl.text.trim().isEmpty) return;
                    setState(() {
                      if (existing != null) {
                        existing.name = nameCtrl.text.trim();
                        existing.relationship = rel;
                        existing.phone = phoneCtrl.text.trim();
                        existing.dob = dobCtrl.text.trim();
                        existing.allergies = allergyCtrl.text.trim();
                      } else {
                        _members.add(FamilyMember(
                          id: 'fm-${DateTime.now().millisecondsSinceEpoch}',
                          name: nameCtrl.text.trim(),
                          relationship: rel,
                          phone: phoneCtrl.text.trim(),
                          dob: dobCtrl.text.trim(),
                          allergies: allergyCtrl.text.trim(),
                        ));
                      }
                    });
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14))),
                  child: Text(existing == null ? 'Add Member' : 'Save Changes',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(FamilyMember m) => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (_) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 22),
            Container(
                width: 56, height: 56,
                decoration: const BoxDecoration(
                    color: Color(0xFFFFEEEE), shape: BoxShape.circle),
                child: const Icon(Icons.person_remove_outlined,
                    size: 26, color: Color(0xFFD14A4A))),
            const SizedBox(height: 14),
            Text('Remove ${m.name}?',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text(
                'This member will be removed from your family list.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.5, color: AppColors.muted, height: 1.5)),
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
                      onPressed: () {
                        setState(() => _members.remove(m));
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD14A4A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14))),
                      child: const Text('Remove',
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
                  child: Text('Family Members',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text))),
            ]),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ── Add card ─────────────────────────────────────────
                GestureDetector(
                  onTap: () => _openSheet(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        color: AppColors.lightGreen,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppColors.green.withOpacity(.3),
                            style: BorderStyle.solid)),
                    child: Column(children: [
                      Container(
                          width: 40, height: 40,
                          decoration: const BoxDecoration(
                              color: AppColors.green, shape: BoxShape.circle),
                          child: const Icon(Icons.add_rounded,
                              color: Colors.white, size: 22)),
                      const SizedBox(height: 8),
                      const Text('Add Family Member',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.green)),
                    ]),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Info note ─────────────────────────────────────────
                if (_members.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(children: [
                      const Icon(Icons.info_outline_rounded,
                          size: 14, color: AppColors.muted),
                      const SizedBox(width: 6),
                      const Expanded(
                          child: Text(
                              'You can order medications on behalf of these members at checkout.',
                              style: TextStyle(
                                  fontSize: 11.5, color: AppColors.muted,
                                  height: 1.4))),
                    ]),
                  ),

                // ── Member cards ──────────────────────────────────────
                ..._members.map((m) => _memberCard(m)),

                // ── Empty state ───────────────────────────────────────
                if (_members.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Column(children: [
                      Container(
                          width: 72, height: 72,
                          decoration: BoxDecoration(
                              color: AppColors.bg,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Icon(Icons.group_outlined,
                              size: 36, color: AppColors.muted)),
                      const SizedBox(height: 16),
                      const Text('No family members yet',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700,
                              color: AppColors.text)),
                      const SizedBox(height: 6),
                      const Text(
                          'Add members to order medications on their behalf.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12.5, color: AppColors.muted,
                              height: 1.5)),
                    ]),
                  ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _memberCard(FamilyMember m) {
    final initial = m.name.isNotEmpty ? m.name[0].toUpperCase() : '?';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.04),
                blurRadius: 12, offset: const Offset(0, 4))
          ]),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Avatar
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
                color: AppColors.green.withOpacity(.12),
                shape: BoxShape.circle),
            child: Center(
                child: Text(initial,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w800,
                        color: AppColors.green))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Row(children: [
                Text(m.name,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700,
                        color: AppColors.text)),
                const SizedBox(width: 8),
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        color: AppColors.lightGreen,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(m.relationship,
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w700,
                            color: AppColors.green))),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.phone_outlined,
                    size: 12, color: AppColors.muted),
                const SizedBox(width: 4),
                Text(m.phone,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.muted)),
              ]),
              if (m.allergies.isNotEmpty && m.allergies != 'None') ...[
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.warning_amber_rounded,
                      size: 12, color: Color(0xFFF0A529)),
                  const SizedBox(width: 4),
                  Text('Allergic: ${m.allergies}',
                      style: const TextStyle(
                          fontSize: 11.5, color: Color(0xFFF0A529),
                          fontWeight: FontWeight.w600)),
                ]),
              ],
            ]),
          ),
          // Actions
          Row(mainAxisSize: MainAxisSize.min, children: [
            GestureDetector(
              onTap: () => _openSheet(existing: m),
              child: Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.edit_outlined,
                      size: 15, color: AppColors.muted)),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _confirmDelete(m),
              child: Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFEEEE),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.delete_outline_rounded,
                      size: 15, color: Color(0xFFD14A4A))),
            ),
          ]),
        ]),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, String hint,
      {TextInputType type = TextInputType.text}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.muted)),
      const SizedBox(height: 6),
      TextField(
        controller: ctrl,
        keyboardType: type,
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
              borderSide:
                  const BorderSide(color: AppColors.green, width: 1.5)),
        ),
      ),
    ]);
  }
}
