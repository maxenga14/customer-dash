import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

// ── Address model ─────────────────────────────────────────────────────────
class SavedAddress {
  SavedAddress({
    required this.id,
    required this.label,
    required this.iconData,
    required this.name,
    required this.line1,
    required this.line2,
    required this.phone,
    this.isDefault = false,
  });

  final String id;
  final String label;
  final IconData iconData;
  final String name;
  final String line1;
  final String line2;
  final String phone;
  bool isDefault;
}

// ── Screen ────────────────────────────────────────────────────────────────
class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  final List<SavedAddress> _addresses = [
    SavedAddress(
      id: 'home',
      label: 'Home',
      iconData: Icons.home_outlined,
      name: 'John Doe',
      line1: '123 Wellness Avenue, Apt 4B',
      line2: 'Kinondoni, Dar es Salaam',
      phone: '+255 712 345 678',
      isDefault: true,
    ),
    SavedAddress(
      id: 'office',
      label: 'Office',
      iconData: Icons.business_outlined,
      name: 'John Doe',
      line1: 'Tech Hub Tower, Floor 12',
      line2: 'Kariakoo, Dar es Salaam',
      phone: '+255 798 765 432',
      isDefault: false,
    ),
  ];

  void _setDefault(String id) {
    setState(() {
      for (final a in _addresses) {
        a.isDefault = a.id == id;
      }
    });
  }

  void _deleteAddress(String id) {
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
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDE3ED),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEEEE),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_outline_rounded,
                  size: 26, color: Color(0xFFD14A4A)),
            ),
            const SizedBox(height: 14),
            const Text('Delete Address?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('This address will be permanently removed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12, color: AppColors.muted, height: 1.5)),
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
                      setState(() => _addresses.removeWhere((a) => a.id == id));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD14A4A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Delete',
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

  void _showAddressForm({SavedAddress? editing}) {
    final labelCtrl = TextEditingController(text: editing?.label ?? '');
    final nameCtrl = TextEditingController(text: editing?.name ?? '');
    final line1Ctrl = TextEditingController(text: editing?.line1 ?? '');
    final line2Ctrl = TextEditingController(text: editing?.line2 ?? '');
    final phoneCtrl = TextEditingController(text: editing?.phone ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDE3ED),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(editing == null ? 'Add New Address' : 'Edit Address',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 18),
            _sheetField(labelCtrl, 'Address Label', 'e.g. Home, Office'),
            const SizedBox(height: 12),
            _sheetField(nameCtrl, 'Full Name', 'Recipient full name'),
            const SizedBox(height: 12),
            _sheetField(line1Ctrl, 'Address Line 1', 'Street, building, apt'),
            const SizedBox(height: 12),
            _sheetField(line2Ctrl, 'Address Line 2', 'City, postal code'),
            const SizedBox(height: 12),
            _sheetField(phoneCtrl, 'Phone Number', '+255 7XX XXX XXX'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  if (editing == null) {
                    setState(() => _addresses.add(SavedAddress(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          label: labelCtrl.text.isEmpty
                              ? 'New Address'
                              : labelCtrl.text,
                          iconData: Icons.location_on_outlined,
                          name: nameCtrl.text,
                          line1: line1Ctrl.text,
                          line2: line2Ctrl.text,
                          phone: phoneCtrl.text,
                        )));
                  } else {
                    setState(() {
                      editing = SavedAddress(
                        id: editing!.id,
                        label: editing!.label,
                        iconData: editing!.iconData,
                        name: editing!.name,
                        line1: line1Ctrl.text,
                        line2: line2Ctrl.text,
                        phone: phoneCtrl.text,
                        isDefault: editing!.isDefault,
                      );
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  editing == null ? 'Save Address' : 'Update Address',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetField(TextEditingController ctrl, String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: AppColors.text)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          style: const TextStyle(fontSize: 12.5),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 12, color: AppColors.muted),
            filled: true,
            fillColor: AppColors.bg,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFDDE3ED))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFDDE3ED))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.green, width: 1.5)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _appBar(context),
            Expanded(
              child: _addresses.isEmpty
                  ? _emptyState()
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      children: [
                        _addNewCard(),
                        const SizedBox(height: 16),
                        ..._addresses.map((addr) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _AddressCard(
                                address: addr,
                                onSetDefault: () => _setDefault(addr.id),
                                onEdit: () => _showAddressForm(editing: addr),
                                onDelete: () => _deleteAddress(addr.id),
                              ),
                            )),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
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
          const SizedBox(width: 10),
          const Expanded(
            child: Text('Saved Addresses',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text)),
          ),
        ],
      ),
    );
  }

  Widget _addNewCard() {
    return GestureDetector(
      onTap: () => _showAddressForm(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FAF5),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.green.withOpacity(.3),
            width: 1.5,
            // dashed effect via CustomPainter not needed — subtle solid works
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.green,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.green.withOpacity(.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4)),
                ],
              ),
              child:
                  const Icon(Icons.add_rounded, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 10),
            const Text('Add New Address',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.green)),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_off_outlined,
              size: 48, color: AppColors.muted),
          const SizedBox(height: 14),
          const Text('No addresses saved',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text('Add your first delivery address',
              style: TextStyle(fontSize: 11.5, color: AppColors.muted)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _showAddressForm(),
            icon: const Icon(Icons.add_rounded, size: 16),
            label: const Text('Add Address',
                style: TextStyle(fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Address card ──────────────────────────────────────────────────────────
class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.onSetDefault,
    required this.onEdit,
    required this.onDelete,
  });

  final SavedAddress address;
  final VoidCallback onSetDefault;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: address.isDefault
              ? AppColors.green.withOpacity(.4)
              : const Color(0xFFE5EAF0),
          width: address.isDefault ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: icon + label + default badge + edit + delete
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: address.isDefault
                        ? const Color(0xFFDDF6E9)
                        : AppColors.bg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(address.iconData,
                      size: 17,
                      color: address.isDefault
                          ? AppColors.green
                          : AppColors.muted),
                ),
                const SizedBox(width: 8),
                Text(address.label,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w800)),
                if (address.isDefault) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('DEFAULT',
                        style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: .4)),
                  ),
                ],
                const Spacer(),
                // Edit icon
                InkWell(
                  onTap: onEdit,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(Icons.edit_outlined,
                        size: 15, color: AppColors.muted),
                  ),
                ),
                const SizedBox(width: 6),
                // Delete icon
                InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEEE),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(Icons.delete_outline_rounded,
                        size: 15, color: Color(0xFFD14A4A)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Address details
            Text(address.name,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text)),
            const SizedBox(height: 3),
            Text(address.line1,
                style: const TextStyle(fontSize: 11.2, color: AppColors.muted)),
            Text(address.line2,
                style: const TextStyle(fontSize: 11.2, color: AppColors.muted)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone_outlined,
                    size: 13, color: AppColors.muted),
                const SizedBox(width: 5),
                Text(address.phone,
                    style: const TextStyle(
                        fontSize: 11.2, color: AppColors.muted)),
              ],
            ),

            // ── Set as default link (only for non-default)
            if (!address.isDefault) ...[
              const SizedBox(height: 10),
              const Divider(height: 1, color: Color(0xFFF0F3F6)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: onSetDefault,
                child: const Text('Set as Default',
                    style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.green)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
