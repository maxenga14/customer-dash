import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ── Product data model ────────────────────────────────────────────────────
class ProductData {
  const ProductData({
    required this.name,
    required this.subtitle,
    required this.price,
    required this.tag,
    required this.tagBg,
    required this.tagText,
    required this.imageBg,
    required this.category,
    this.isPopular = false,
    this.isBuyAgain = false,
  });

  final String name;
  final String subtitle;
  final double price;
  final String tag;
  final Color tagBg;
  final Color tagText;
  final Color imageBg;
  final String category; // 'Medicines' | 'Vitamins' | 'Baby Care' | 'Personal'
  final bool isPopular;
  final bool isBuyAgain;
}

// ── Mock pharmacy ─────────────────────────────────────────────────────────
class PharmacyData {
  const PharmacyData({
    required this.name,
    required this.distance,
    required this.address,
    required this.isOpen,
    required this.rating,
  });
  final String name;
  final String distance;
  final String address;
  final bool isOpen;
  final double rating;
}

const nearbyPharmacy = PharmacyData(
  name: 'Dawa Plus Pharmacy',
  distance: '0.8 km',
  address: 'Kariakoo, Dar es Salaam',
  isOpen: true,
  rating: 4.8,
);

// ── Product catalogue (all from selected pharmacy) ────────────────────────
const allProducts = [
  // ── Medicines
  ProductData(
    name: 'Amoxicillin 500mg',
    subtitle: 'Capsules • Pack of 20',
    price: 7500,
    tag: 'In Stock',
    tagBg: Color(0xFFDDF6E9), tagText: AppColors.green,
    imageBg: Color(0xFFEAF3FF),
    category: 'Medicines', isPopular: true,
  ),
  ProductData(
    name: 'Paracetamol 500mg',
    subtitle: 'Tablets • Pack of 16',
    price: 2500,
    tag: 'In Stock',
    tagBg: Color(0xFFDDF6E9), tagText: AppColors.green,
    imageBg: Color(0xFFF0F8FF),
    category: 'Medicines', isPopular: true,
  ),
  ProductData(
    name: 'Salbutamol Inhaler',
    subtitle: '100mcg • 200 doses',
    price: 18000,
    tag: 'In Stock',
    tagBg: Color(0xFFDDF6E9), tagText: AppColors.green,
    imageBg: Color(0xFFF5EEFF),
    category: 'Medicines', isBuyAgain: true,
  ),
  ProductData(
    name: 'Ibuprofen 400mg',
    subtitle: 'Tablets • Pack of 24',
    price: 4500,
    tag: 'Low Stock',
    tagBg: Color(0xFFFFEBCF), tagText: AppColors.yellow,
    imageBg: Color(0xFFFFF3E0),
    category: 'Medicines',
  ),
  ProductData(
    name: 'Metformin 850mg',
    subtitle: 'Tablets • Pack of 30',
    price: 6000,
    tag: 'In Stock',
    tagBg: Color(0xFFDDF6E9), tagText: AppColors.green,
    imageBg: Color(0xFFEAF3FF),
    category: 'Medicines',
  ),

  // ── Vitamins
  ProductData(
    name: 'Daily Multivitamin',
    subtitle: 'Gummies • 60 count',
    price: 12000,
    tag: 'In Stock',
    tagBg: Color(0xFFDDF6E9), tagText: AppColors.green,
    imageBg: Color(0xFFFFF1F1),
    category: 'Vitamins', isPopular: true,
  ),
  ProductData(
    name: 'Vitamin D3 2000IU',
    subtitle: 'Softgels • 90 count',
    price: 9500,
    tag: 'In Stock',
    tagBg: Color(0xFFDDF6E9), tagText: AppColors.green,
    imageBg: Color(0xFFFFFAE0),
    category: 'Vitamins', isBuyAgain: true,
  ),
  ProductData(
    name: 'Vitamin C 1000mg',
    subtitle: 'Effervescent • 20 tablets',
    price: 5500,
    tag: 'In Stock',
    tagBg: Color(0xFFDDF6E9), tagText: AppColors.green,
    imageBg: Color(0xFFFFF3E0),
    category: 'Vitamins',
  ),
  ProductData(
    name: 'Omega-3 Fish Oil',
    subtitle: 'Softgels • 60 count',
    price: 14500,
    tag: 'Low Stock',
    tagBg: Color(0xFFFFEBCF), tagText: AppColors.yellow,
    imageBg: Color(0xFFE8F5FF),
    category: 'Vitamins',
  ),

  // ── Baby Care
  ProductData(
    name: 'Johnson\'s Baby Powder',
    subtitle: 'Talc-free • 200g',
    price: 7000,
    tag: 'In Stock',
    tagBg: Color(0xFFDDF6E9), tagText: AppColors.green,
    imageBg: Color(0xFFF5F0FF),
    category: 'Baby Care', isPopular: true,
  ),
  ProductData(
    name: 'Gripe Water',
    subtitle: 'Relief drops • 150ml',
    price: 5500,
    tag: 'In Stock',
    tagBg: Color(0xFFDDF6E9), tagText: AppColors.green,
    imageBg: Color(0xFFE8F8F0),
    category: 'Baby Care',
  ),
  ProductData(
    name: 'Infant Paracetamol',
    subtitle: 'Suspension • 100ml',
    price: 4500,
    tag: 'In Stock',
    tagBg: Color(0xFFDDF6E9), tagText: AppColors.green,
    imageBg: Color(0xFFEAF3FF),
    category: 'Baby Care',
  ),

  // ── Personal Care
  ProductData(
    name: 'Cetaphil Face Wash',
    subtitle: 'Gentle • 250ml',
    price: 18500,
    tag: 'In Stock',
    tagBg: Color(0xFFDDF6E9), tagText: AppColors.green,
    imageBg: Color(0xFFF0F8FF),
    category: 'Personal', isPopular: true,
  ),
  ProductData(
    name: 'Eucerin Body Lotion',
    subtitle: 'Urea 5% • 400ml',
    price: 22000,
    tag: 'In Stock',
    tagBg: Color(0xFFDDF6E9), tagText: AppColors.green,
    imageBg: Color(0xFFFFF5F0),
    category: 'Personal',
  ),
  ProductData(
    name: 'Oral B Toothpaste',
    subtitle: 'Whitening • 75ml',
    price: 4000,
    tag: 'In Stock',
    tagBg: Color(0xFFDDF6E9), tagText: AppColors.green,
    imageBg: Color(0xFFE8F5FF),
    category: 'Personal',
  ),
];

List<ProductData> get featuredProducts =>
    allProducts.where((p) => p.isPopular).toList();

List<ProductData> get buyAgainProducts =>
    allProducts.where((p) => p.isBuyAgain).toList();

List<ProductData> filteredProducts(String category) =>
    category == 'All' ? allProducts : allProducts.where((p) => p.category == category).toList();
