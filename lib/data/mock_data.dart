import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProductData {
  final String name;
  final String subtitle;
  final double price;
  final String tag;
  final Color tagBg;
  final Color tagText;
  final Color imageBg;

  const ProductData({
    required this.name,
    required this.subtitle,
    required this.price,
    required this.tag,
    required this.tagBg,
    required this.tagText,
    required this.imageBg,
  });
}

const featuredProducts = [
  ProductData(
    name: 'Daily Multivitamin',
    subtitle: '60 Gummies',
    price: 12.99,
    tag: 'In Stock',
    tagBg: Color(0xFFDDF6E9),
    tagText: AppColors.green,
    imageBg: Color(0xFFFFF1F1),
  ),
  ProductData(
    name: 'Paracetamol\n500mg',
    subtitle: 'Pack of 16',
    price: 4.50,
    tag: 'Low Stock',
    tagBg: Color(0xFFFFEBCF),
    tagText: AppColors.yellow,
    imageBg: Color(0xFFEAF3FF),
  ),
];
