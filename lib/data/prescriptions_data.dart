import '../models/prescription.dart';

final List<Prescription> mockPrescriptions = [
  Prescription(
    id: 'rx-001',
    name: "Dr. Smith's Rx",
    uploadedAt: 'Today, 09:30 AM',
    status: RxStatus.quotationReady,
    quotationPrice: 45.00,
    quotationPharmacy: 'City Pharmacy',
  ),
  Prescription(
    id: 'rx-002',
    name: 'Dermatologist Rx',
    uploadedAt: 'Yesterday',
    status: RxStatus.pendingReview,
    statusNote: 'Pharmacies are currently reviewing your prescription to provide quotes.',
  ),
  Prescription(
    id: 'rx-003',
    name: 'Monthly Refill',
    uploadedAt: 'Oct 12, 2023',
    status: RxStatus.verified,
    linkedOrderNumber: 'ORD-8478',
    linkedPharmacy: 'HealthPlus Pharmacy',
  ),
  Prescription(
    id: 'rx-004',
    name: 'Blurry Upload',
    uploadedAt: 'Oct 05, 2023',
    status: RxStatus.rejected,
    statusNote: 'Image was too blurry to read. Please re-upload.',
  ),
];
