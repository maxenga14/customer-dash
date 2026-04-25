import 'package:flutter/material.dart';

class ProductMockArt extends StatelessWidget {
  const ProductMockArt({super.key, required this.variant});
  final int variant;

  @override
  Widget build(BuildContext context) {
    if (variant == 0) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF6F6),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Positioned(
            top: 8,
            child: Container(
              width: 18,
              height: 26,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: const Color(0xFFF0D8D8)),
              ),
              child: Column(
                children: [
                  Container(height: 6, decoration: const BoxDecoration(color: Color(0xFFED6B72), borderRadius: BorderRadius.vertical(top: Radius.circular(4)))),
                  const SizedBox(height: 4),
                  Container(width: 8, height: 2, color: const Color(0xFFD9DDE5)),
                  const SizedBox(height: 2),
                  Container(width: 8, height: 2, color: const Color(0xFFD9DDE5)),
                ],
              ),
            ),
          ),
          Positioned(
            right: 6,
            bottom: 8,
            child: Transform.rotate(
              angle: -.25,
              child: Container(
                width: 14,
                height: 7,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8BE62),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF3FF),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        Positioned(
          top: 10,
          child: Container(
            width: 28,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFD6E2F4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 5, decoration: const BoxDecoration(color: Color(0xFFF2C14E), borderRadius: BorderRadius.vertical(top: Radius.circular(3)))),
                const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(height: 2, color: const Color(0xFFD4DBE8)),
                ),
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(height: 2, width: 10, color: const Color(0xFFD4DBE8)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
