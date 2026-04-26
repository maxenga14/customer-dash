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
    with SingleTickerProviderStateMixin {
  late final AnimationController _cartController;

  @override
  void initState() {
    super.initState();
    _cartController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 320));
    if (widget.hasCart) _cartController.value = 1;
  }

  @override
  void didUpdateWidget(covariant AnimatedBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasCart != oldWidget.hasCart) {
      widget.hasCart ? _cartController.forward() : _cartController.reverse();
    }
  }

  @override
  void dispose() {
    _cartController.dispose();
    super.dispose();
  }

  // Nav items — cart sits in the CENTER (index 2), pushing Rx to 3, Settings to 4
  static const _items = [
    (Icons.home_filled,           Icons.home_outlined,            'Home',     false),
    (Icons.inventory_2_rounded,   Icons.inventory_2_outlined,     'Orders',   false),
    (Icons.shopping_cart_rounded, Icons.shopping_cart_outlined,   'Cart',     true ), // centre
    (Icons.receipt_long_rounded,  Icons.receipt_long_outlined,    'Rx',       false),
    (Icons.settings_rounded,      Icons.settings_outlined,        'Settings', false),
  ];

  // Map visual index (0-4) → tab index passed to onTap (cart taps open checkout)
  // Home=0, Orders=1, [cart opens checkout], Rx=2, Settings=3
  static const _tabMap = [0, 1, -1, 2, 3]; // -1 = cart action

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 24,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: List.generate(_items.length, (i) {
          final item       = _items[i];
          final isCart     = item.$4;
          final tabIndex   = _tabMap[i];
          final isSelected = !isCart && widget.selectedIndex == tabIndex;

          if (isCart) return _cartSlot();

          return Expanded(
            child: InkWell(
              onTap: () => widget.onTap(tabIndex),
              borderRadius: BorderRadius.circular(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: Icon(
                      isSelected ? item.$1 : item.$2,
                      key: ValueKey(isSelected),
                      size: 21,
                      color: isSelected
                          ? AppColors.green
                          : const Color(0xFFA8B1BE),
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 180),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? AppColors.green
                          : const Color(0xFFA8B1BE),
                    ),
                    child: Text(item.$3),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  /// Centre cart slot — plain icon when empty, green badge button when filled.
  /// Stays INSIDE the nav bar — never floats over content.
  Widget _cartSlot() {
    return Expanded(
      child: GestureDetector(
        onTap: widget.hasCart ? widget.onCheckoutTap : null,
        child: AnimatedBuilder(
          animation: _cartController,
          builder: (_, __) {
            final scale = Tween<double>(begin: 1.0, end: 1.18)
                .animate(CurvedAnimation(
                    parent: _cartController, curve: Curves.easeOutBack))
                .value;
            return Center(
              child: Transform.scale(
                scale: scale,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  width:  widget.hasCart ? 50 : 40,
                  height: widget.hasCart ? 50 : 40,
                  decoration: BoxDecoration(
                    color: widget.hasCart
                        ? AppColors.green
                        : const Color(0xFFF0FAF5),
                    shape: BoxShape.circle,
                    boxShadow: widget.hasCart
                        ? [
                            BoxShadow(
                                color: AppColors.green.withOpacity(.32),
                                blurRadius: 14,
                                offset: const Offset(0, 4))
                          ]
                        : [],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Center(
                        child: Icon(
                          Icons.shopping_cart_rounded,
                          size: widget.hasCart ? 22 : 20,
                          color: widget.hasCart
                              ? Colors.white
                              : const Color(0xFFA8B1BE),
                        ),
                      ),
                      if (widget.hasCart)
                        Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD166),
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 1.5),
                            ),
                            child: Center(
                              child: Text(
                                '${widget.totalItems > 9 ? "9+" : widget.totalItems}',
                                style: const TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF2D1A00)),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
