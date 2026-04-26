import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';

class UploadRxScreen extends StatefulWidget {
  const UploadRxScreen({super.key});

  @override
  State<UploadRxScreen> createState() => _UploadRxScreenState();
}

enum UploadMethod { camera, gallery }

class _UploadRxScreenState extends State<UploadRxScreen>
    with SingleTickerProviderStateMixin {
  // ── State ────────────────────────────────────────────────────────────
  UploadMethod _method      = UploadMethod.camera;
  XFile?       _pickedFile;          // the chosen image/pdf
  bool         _isLoading   = false; // while picker is open
  bool         _submitted   = false;

  final _patientController = TextEditingController();
  final _doctorController  = TextEditingController();
  final _notesController   = TextEditingController();
  bool _consent = false;

  // Preview pop-in animation
  late final AnimationController _previewCtrl;
  late final Animation<double>   _previewScale;

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _previewCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 420));
    _previewScale = CurvedAnimation(
        parent: _previewCtrl, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _previewCtrl.dispose();
    _patientController.dispose();
    _doctorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool get _hasImage   => _pickedFile != null;
  bool get _canSubmit  => _hasImage && _consent &&
      _patientController.text.trim().isNotEmpty;

  // ── Image picking ─────────────────────────────────────────────────────
  Future<void> _pickImage(ImageSource source) async {
    setState(() => _isLoading = true);
    try {
      final file = await _picker.pickImage(
        source: source,
        imageQuality: 88,          // balance quality vs upload size
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (file != null && mounted) {
        setState(() => _pickedFile = file);
        _previewCtrl.forward(from: 0); // pop-in animation
      }
    } catch (e) {
      if (mounted) _showError('Could not access ${source == ImageSource.camera ? "camera" : "gallery"}. Please check app permissions in Settings.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _removeImage() {
    _previewCtrl.reverse().then((_) {
      if (mounted) setState(() => _pickedFile = null);
    });
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontSize: 12.5)),
      backgroundColor: const Color(0xFFD14A4A),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  // ── Submit ────────────────────────────────────────────────────────────
  void _submit() {
    setState(() => _submitted = true);
    if (!_hasImage) {
      _showError('Please attach a prescription image first.');
      return;
    }
    if (_patientController.text.trim().isEmpty) return;
    if (!_consent) return;

    // TODO Step 2: pass _pickedFile + form data to review screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(children: [
          Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
          SizedBox(width: 10),
          Text('Prescription uploaded — proceeding to review',
              style: TextStyle(fontSize: 12.5)),
        ]),
        backgroundColor: AppColors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════════════════
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
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Method selector ─────────────────────────────
                    _sectionLabel('Choose Upload Method'),
                    const SizedBox(height: 12),
                    _methodSelector(),
                    const SizedBox(height: 16),

                    // ── Pick button + preview ────────────────────────
                    _pickArea(),
                    const SizedBox(height: 20),

                    // ── Guidelines (only shown when no image yet) ────
                    if (!_hasImage) ...[
                      _guidelinesCard(),
                      const SizedBox(height: 20),
                    ],

                    // ── Details form ────────────────────────────────
                    _sectionLabel('Prescription Details'),
                    const SizedBox(height: 14),
                    _field(
                      label: 'Patient Name', required: true,
                      controller: _patientController,
                      hint: 'Enter patient\'s full name',
                      error: _submitted && _patientController.text.trim().isEmpty
                          ? 'Patient name is required' : null,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 14),
                    _field(
                      label: 'Doctor / Facility', required: false,
                      controller: _doctorController,
                      hint: 'Prescribing doctor or facility name',
                    ),
                    const SizedBox(height: 14),
                    _field(
                      label: 'Additional Notes', required: false,
                      controller: _notesController,
                      hint: 'Allergies, urgency, specific brand requests…',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    _consentRow(),
                    const SizedBox(height: 26),
                    _submitButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── App bar ───────────────────────────────────────────────────────────
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
              width: 34, height: 34,
              decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(11)),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 15, color: AppColors.text),
            ),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Upload Prescription',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800,
                      color: AppColors.text)),
              SizedBox(height: 2),
              Text('Step 1 of 2 — Attach & Describe',
                  style: TextStyle(fontSize: 10.5, color: AppColors.muted)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Progress bar ──────────────────────────────────────────────────────
  Widget _progressBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Row(children: [
        Expanded(child: Container(height: 4,
            decoration: BoxDecoration(color: AppColors.green,
                borderRadius: BorderRadius.circular(4)))),
        const SizedBox(width: 6),
        Expanded(child: Container(height: 4,
            decoration: BoxDecoration(color: const Color(0xFFE5EAF0),
                borderRadius: BorderRadius.circular(4)))),
      ]),
    );
  }

  // ── Section label ─────────────────────────────────────────────────────
  Widget _sectionLabel(String text) => Text(text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
          color: AppColors.text));

  // ── Method selector cards ─────────────────────────────────────────────
  Widget _methodSelector() {
    return Row(children: [
      Expanded(child: _methodCard(UploadMethod.camera,
          Icons.camera_alt_rounded, 'Camera', 'Take a photo')),
      const SizedBox(width: 12),
      Expanded(child: _methodCard(UploadMethod.gallery,
          Icons.photo_library_rounded, 'Gallery', 'Choose file')),
    ]);
  }

  Widget _methodCard(UploadMethod m, IconData icon, String label, String sub) {
    final active = _method == m;
    return GestureDetector(
      onTap: () => setState(() => _method = m),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFF0FAF5) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active ? AppColors.green : const Color(0xFFDDE3ED),
            width: active ? 2 : 1,
          ),
        ),
        child: Column(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: active ? const Color(0xFFDDF6E9) : const Color(0xFFF0F3F7),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, size: 22,
                color: active ? AppColors.green : AppColors.muted),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: active ? AppColors.green : AppColors.text)),
          const SizedBox(height: 2),
          Text(sub, style: const TextStyle(fontSize: 9.5,
              color: AppColors.muted)),
        ]),
      ),
    );
  }

  // ── Pick area — button OR image preview ───────────────────────────────
  Widget _pickArea() {
    if (_isLoading) {
      return Container(
        width: double.infinity, height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFDDE3ED)),
        ),
        child: const Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            CircularProgressIndicator(color: AppColors.green, strokeWidth: 2.5),
            SizedBox(height: 14),
            Text('Opening…', style: TextStyle(fontSize: 12, color: AppColors.muted)),
          ]),
        ),
      );
    }

    if (_hasImage) return _imagePreview();

    // ── Empty pick button ──────────────────────────────────────────────
    return GestureDetector(
      onTap: () => _pickImage(
          _method == UploadMethod.camera
              ? ImageSource.camera
              : ImageSource.gallery),
      child: Container(
        width: double.infinity, height: 180,
        decoration: BoxDecoration(
          color: const Color(0xFFF0FAF5),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: AppColors.green.withOpacity(.35), width: 1.5,
              strokeAlign: BorderSide.strokeAlignInside),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFDDF6E9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _method == UploadMethod.camera
                  ? Icons.camera_alt_rounded
                  : Icons.photo_library_rounded,
              size: 26, color: AppColors.green,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _method == UploadMethod.camera
                ? 'Tap to take a photo'
                : 'Tap to choose from gallery',
            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700,
                color: AppColors.green),
          ),
          const SizedBox(height: 4),
          const Text('JPG, PNG · Max 5MB',
              style: TextStyle(fontSize: 10.5, color: AppColors.muted)),
        ]),
      ),
    );
  }

  // ── Image preview card ────────────────────────────────────────────────
  Widget _imagePreview() {
    return ScaleTransition(
      scale: _previewScale,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.green.withOpacity(.4)),
          boxShadow: [
            BoxShadow(color: AppColors.green.withOpacity(.08),
                blurRadius: 18, offset: const Offset(0, 6)),
          ],
        ),
        child: Column(children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
            child: Image.file(
              File(_pickedFile!.path),
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),
          // Action row
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              const Icon(Icons.check_circle_rounded,
                  size: 16, color: AppColors.green),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _pickedFile!.name,
                  style: const TextStyle(fontSize: 11.5,
                      fontWeight: FontWeight.w600, color: AppColors.text),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              // Retake button
              TextButton.icon(
                onPressed: () => _pickImage(
                    _method == UploadMethod.camera
                        ? ImageSource.camera
                        : ImageSource.gallery),
                icon: const Icon(Icons.refresh_rounded, size: 14),
                label: const Text('Retake',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
              ),
              // Remove button
              TextButton.icon(
                onPressed: _removeImage,
                icon: const Icon(Icons.delete_outline_rounded, size: 14),
                label: const Text('Remove',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFD14A4A),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  // ── Guidelines card ───────────────────────────────────────────────────
  Widget _guidelinesCard() {
    const tips = [
      'Ensure good lighting and a sharp focus',
      'Capture all four corners of the document',
      'Accepted formats: JPG, PNG (max 5 MB)',
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCCDCF5)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.info_outline_rounded, size: 15, color: Color(0xFF5B8FC9)),
          SizedBox(width: 7),
          Text('Image Guidelines',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                  color: Color(0xFF2C5F9A))),
        ]),
        const SizedBox(height: 10),
        ...tips.map((tip) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.check_rounded, size: 13, color: AppColors.green),
            const SizedBox(width: 7),
            Expanded(child: Text(tip,
                style: const TextStyle(fontSize: 10.8,
                    color: Color(0xFF4A6FA5), height: 1.4))),
          ]),
        )),
      ]),
    );
  }

  // ── Form field ────────────────────────────────────────────────────────
  Widget _field({
    required String label,
    required bool required,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    String? error,
    ValueChanged<String>? onChanged,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(label, style: const TextStyle(fontSize: 11.5,
            fontWeight: FontWeight.w700, color: AppColors.text)),
        if (required)
          const Text(' *', style: TextStyle(fontSize: 11.5,
              color: AppColors.green, fontWeight: FontWeight.w700)),
        if (!required)
          const Text('  (Optional)',
              style: TextStyle(fontSize: 10.5, color: AppColors.muted)),
      ]),
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
              borderSide: const BorderSide(color: Color(0xFFDDE3ED))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Color(0xFFDDE3ED))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: AppColors.green, width: 1.5)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Color(0xFFD14A4A))),
        ),
      ),
    ]);
  }

  // ── Consent checkbox ──────────────────────────────────────────────────
  Widget _consentRow() {
    return GestureDetector(
      onTap: () => setState(() => _consent = !_consent),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 20, height: 20,
          decoration: BoxDecoration(
            color: _consent ? AppColors.green : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: _consent ? AppColors.green : const Color(0xFFCDD3DC),
              width: 1.5,
            ),
          ),
          child: _consent
              ? const Icon(Icons.check_rounded, size: 13, color: Colors.white)
              : null,
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            'I confirm this is a valid prescription and consent to pharmacies reviewing it to provide quotations.',
            style: TextStyle(fontSize: 11, color: AppColors.muted, height: 1.5),
          ),
        ),
      ]),
    );
  }

  // ── Submit / Continue button ──────────────────────────────────────────
  Widget _submitButton() {
    final ready = _canSubmit;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _submit,
        icon: Icon(
          _hasImage ? Icons.arrow_forward_rounded : Icons.upload_rounded,
          size: 18,
        ),
        label: Text(
          _hasImage ? 'Continue to Review' : 'Attach Prescription First',
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: ready
              ? AppColors.green
              : _hasImage
                  ? const Color(0xFFB5D5C8)
                  : const Color(0xFFE8ECF0),
          foregroundColor: ready ? Colors.white : AppColors.muted,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }
}
