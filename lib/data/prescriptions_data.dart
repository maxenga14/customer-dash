import '../models/prescription.dart';

final List<Prescription> mockPrescriptions = [
  Prescription(
    id: 'rx-001',
    name: "Dr. Mwangi's Rx",
    uploadedAt: 'Today, 09:30 AM',
    status: RxStatus.approved,
    quotationPrice: 45000,
  ),
  Prescription(
    id: 'rx-002',
    name: 'Dermatologist Rx',
    uploadedAt: 'Yesterday',
    status: RxStatus.pending,
    statusNote: 'Pharmacies are currently reviewing your prescription to provide quotes.',
  ),
  Prescription(
    id: 'rx-003',
    name: 'Monthly Refill',
    uploadedAt: 'Oct 12, 2024',
    status: RxStatus.paid,
    linkedOrderNumber: 'ORD-8478',
  ),
  Prescription(
    id: 'rx-004',
    name: 'Blurry Upload',
    uploadedAt: 'Oct 05, 2024',
    status: RxStatus.rejected,
    statusNote: 'Image was too blurry to read. Please re-upload.',
  ),
];
