import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedBottomNav extends StatefulWidget {
  const AnimatedBottomNav({
    super.key,
    required this.selectedIndex,
    required this.hasCart,
    required this.totalItems,
    required this.onTap,
    required this.onCheckoutTap,
  });

  final int selectedIndex;
  final bool hasCart;
  final int totalItems;
  final ValueChanged<int> onTap;
  final VoidCallback onCheckoutTap;

  @override
  State<AnimatedBottomNav> createState() => _AnimatedBottomNavState();
}

class _AnimatedBottomNavState extends State<AnimatedBottomNav>
    with TickerProviderStateMixin {
  late final AnimationController _fabController;
  late final AnimationController _navController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
    _navController = AnimationController(vsync: this, duration: const Duration(milliseconds: 360));
    if (widget.hasCart) {
      _fabController.value = 1;
      _navController.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasCart != oldWidget.hasCart) {
      if (widget.hasCart) {
        _fabController.forward();
        _navController.forward();
      } else {
        _fabController.reverse();
        _navController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _fabController.dispose();
    _navController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_filled, 'Home'),
      (Icons.inventory_2_outlined, 'Orders'),
      (Icons.receipt_long_outlined, 'Rx'),
      (Icons.settings_outlined, 'Settings'),
    ];

    return SizedBox(
      height: 110,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 12,
            right: 12,
            bottom: 10,
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 24, offset: const Offset(0, 8)),
                ],
              ),
              child: AnimatedBuilder(
                animation: _navController,
                builder: (context, _) {
                  final gap = Tween<double>(begin: 0, end: 64).evaluate(CurvedAnimation(parent: _navController, curve: Curves.easeInOutCubic));
                  return Row(
                    children: [
                      _navItem(0, items[0].$1, items[0].$2),
                      _navItem(1, items[1].$1, items[1].$2),
                      SizedBox(width: gap),
                      _navItem(2, items[2].$1, items[2].$2),
                      _navItem(3, items[3].$1, items[3].$2),
                    ],
                  );
                },
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _fabController,
            builder: (context, _) {
              final curved = CurvedAnimation(parent: _fabController, curve: Curves.easeOutBack, reverseCurve: Curves.easeInCubic);
              final dy = Tween<double>(begin: 40, end: 0).evaluate(curved);
              return IgnorePointer(
                ignoring: _fabController.value == 0,
                child: Opacity(
                  opacity: _fabController.value,
                  child: Transform.translate(
                    offset: Offset(0, dy),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 26),
                      child: GestureDetector(
                        onTap: widget.onCheckoutTap,
                        child: Container(
                          height: 54,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(color: AppColors.green.withOpacity(.33), blurRadius: 22, offset: const Offset(0, 8)),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(color: Colors.white.withOpacity(.16), shape: BoxShape.circle),
                                child: const Icon(Icons.shopping_cart_checkout_rounded, color: Colors.white, size: 18),
                              ),
                              const SizedBox(width: 10),
                              const Text('Checkout', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                                child: Text('${widget.totalItems}', style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w800, fontSize: 10)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final selected = widget.selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => widget.onTap(index),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: selected ? 1.07 : 1,
              duration: const Duration(milliseconds: 220),
              child: Icon(icon, size: 21, color: selected ? AppColors.green : const Color(0xFFA8B1BE)),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.green : const Color(0xFFA8B1BE),
              ),
              child: Text(label),
            )
          ],
        ),
      ),
    );
  }
}
