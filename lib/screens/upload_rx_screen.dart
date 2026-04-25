import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class UploadRxScreen extends StatefulWidget {
  const UploadRxScreen({super.key});

  @override
  State<UploadRxScreen> createState() => _UploadRxScreenState();
}

enum UploadMethod { camera, gallery }

class _UploadRxScreenState extends State<UploadRxScreen> {
  UploadMethod _method = UploadMethod.camera;
  final _patientController = TextEditingController();
  final _doctorController  = TextEditingController();
  final _notesController   = TextEditingController();
  bool _consent = false;
  bool _submitted = false; // for inline validation

  @override
  void dispose() {
    _patientController.dispose();
    _doctorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool get _canSubmit => _consent && _patientController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _appBar(context),
            _progressBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('Choose Upload Method'),
                    const SizedBox(height: 12),
                    _methodSelector(),
                    const SizedBox(height: 14),
                    _guidelinesCard(),
                    const SizedBox(height: 20),
                    _sectionLabel('Prescription Details'),
                    const SizedBox(height: 14),
                    _field(
                      label: 'Patient Name',
                      required: true,
                      controller: _patientController,
                      hint: 'Enter patient\'s full name',
                      error: _submitted && _patientController.text.trim().isEmpty
                          ? 'Patient name is required'
                          : null,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 14),
                    _field(
                      label: 'Doctor Name',
                      required: false,
                      controller: _doctorController,
                      hint: 'Enter prescribing doctor',
                    ),
                    const SizedBox(height: 14),
                    _field(
                      label: 'Additional Notes',
                      required: false,
                      controller: _notesController,
                      hint: 'Any additional information about this prescription...',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    _consentRow(),
                    const SizedBox(height: 24),
                    _submitButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── App bar ──────────────────────────────────────────────────────────
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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Upload Rx',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text)),
              SizedBox(height: 2),
              Text('Step 1 of 2',
                  style: TextStyle(fontSize: 10.5, color: AppColors.muted)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Progress bar ─────────────────────────────────────────────────────
  Widget _progressBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5EAF0),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section label ────────────────────────────────────────────────────
  Widget _sectionLabel(String text) {
    return Text(text,
        style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text));
  }

  // ── Upload method selector ────────────────────────────────────────────
  Widget _methodSelector() {
    return Row(
      children: [
        Expanded(child: _methodCard(UploadMethod.camera, Icons.camera_alt_outlined, 'Camera')),
        const SizedBox(width: 12),
        Expanded(child: _methodCard(UploadMethod.gallery, Icons.image_outlined, 'Gallery')),
      ],
    );
  }

  Widget _methodCard(UploadMethod method, IconData icon, String label) {
    final active = _method == method;
    return GestureDetector(
      onTap: () => setState(() => _method = method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFF0FAF5) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active ? AppColors.green : const Color(0xFFDDE3ED),
            width: active ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: active ? const Color(0xFFDDF6E9) : const Color(0xFFF0F3F7),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon,
                  size: 22,
                  color: active ? AppColors.green : AppColors.muted),
            ),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: active ? AppColors.green : AppColors.text)),
          ],
        ),
      ),
    );
  }

  // ── Image guidelines card ─────────────────────────────────────────────
  Widget _guidelinesCard() {
    const tips = [
      'Ensure good lighting and focus',
      'Capture all corners of the document',
      'Accepted: JPG, PNG, PDF (Max 5MB)',
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCCDCF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline_rounded, size: 15, color: Color(0xFF5B8FC9)),
              SizedBox(width: 7),
              Text('Image Guidelines',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2C5F9A))),
            ],
          ),
          const SizedBox(height: 10),
          ...tips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_rounded,
                        size: 13, color: AppColors.green),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(tip,
                          style: const TextStyle(
                              fontSize: 10.8,
                              color: Color(0xFF4A6FA5),
                              height: 1.4)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ── Form field ───────────────────────────────────────────────────────
  Widget _field({
    required String label,
    required bool required,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    String? error,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.text)),
            if (required)
              const Text(' *',
                  style: TextStyle(fontSize: 11.5, color: AppColors.green, fontWeight: FontWeight.w700)),
            if (!required)
              const Text('  (Optional)',
                  style: TextStyle(fontSize: 10.5, color: AppColors.muted)),
          ],
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          maxLines: maxLines,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 12.5, color: AppColors.text),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 12, color: AppColors.muted),
            errorText: error,
            errorStyle: const TextStyle(fontSize: 10.5),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide:
                  const BorderSide(color: AppColors.green, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Color(0xFFD14A4A)),
            ),
          ),
        ),
      ],
    );
  }

  // ── Consent checkbox ─────────────────────────────────────────────────
  Widget _consentRow() {
    return GestureDetector(
      onTap: () => setState(() => _consent = !_consent),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: _consent ? AppColors.green : Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _consent ? AppColors.green : const Color(0xFFCDD3DC),
                width: 1.5,
              ),
            ),
            child: _consent
                ? const Icon(Icons.check_rounded,
                    size: 13, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'I confirm this is a valid prescription and consent to pharmacies reviewing it to provide quotations.',
              style: TextStyle(fontSize: 11, color: AppColors.muted, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // ── Submit button ────────────────────────────────────────────────────
  Widget _submitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setState(() => _submitted = true);
          if (_canSubmit) {
            // TODO: Navigate to Step 2
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Proceeding to Step 2 — Review & Submit'),
                backgroundColor: AppColors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _consent ? AppColors.green : const Color(0xFFB5D5C8),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Submit for Verification',
                style:
                    TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}
