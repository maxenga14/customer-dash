import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/cart_item.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_bottom_nav.dart';
import '../widgets/common.dart';
import '../widgets/product_mock_art.dart';
import 'checkout_screen.dart';
import 'orders_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;
  final List<CartItem> cart = [];

  int get totalCartItems => cart.fold(0, (sum, item) => sum + item.quantity);

  void addToCart(ProductData product) {
    final i = cart.indexWhere((e) => e.name == product.name);
    setState(() {
      if (i >= 0) {
        cart[i].quantity += 1;
      } else {
        cart.add(CartItem(name: product.name, subtitle: product.subtitle, price: product.price, quantity: 1, tag: product.tag));
      }
    });
  }

  Future<void> openCheckout() async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 320),
        reverseTransitionDuration: const Duration(milliseconds: 260),
        pageBuilder: (_, animation, __) => SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: CheckoutScreen(initialItems: cart.map((e) => e.copy()).toList()),
        ),
      ),
    );

    if (result is List<CartItem>) {
      setState(() {
        cart
          ..clear()
          ..addAll(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 120),
                    child: Column(
                      children: [
                        _header(),
                        Transform.translate(
                          offset: const Offset(0, -20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _topCards(),
                                const SizedBox(height: 12),
                                _routeCard(),
                                const SizedBox(height: 12),
                                _quotationCard(),
                                const SizedBox(height: 18),
                                _categories(),
                                const SizedBox(height: 18),
                                _featuredProducts(),
                                const SizedBox(height: 18),
                                _buyAgain(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 88),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedBottomNav(
                selectedIndex: selectedIndex,
                hasCart: cart.isNotEmpty,
                totalItems: totalCartItems,
                onTap: (i) {
                  setState(() => selectedIndex = i);
                  if (i == 1) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (_, animation, __) => FadeTransition(
                          opacity: animation,
                          child: const OrdersScreen(),
                        ),
                      ),
                    );
                  }
                },
                onCheckoutTap: openCheckout,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 34),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.greenDark, AppColors.green], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(26), bottomRight: Radius.circular(26)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: Colors.white.withOpacity(.18), shape: BoxShape.circle),
                child: const Icon(Icons.person_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Good Morning,', style: TextStyle(color: Color(0xFFD8FFF0), fontSize: 10.0)),
                    SizedBox(height: 2),
                    Text('Alex Johnson', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15.5)),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: Colors.white.withOpacity(.16), borderRadius: BorderRadius.circular(11)),
                child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 17),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(color: Colors.white.withOpacity(.17), borderRadius: BorderRadius.circular(14)),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.white70, size: 18),
                SizedBox(width: 10),
                Expanded(child: Text('Search medicines, health products...', style: TextStyle(color: Colors.white70, fontSize: 12))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _topCards() {
    return Row(
      children: [
        Expanded(child: _smallAction('Upload Rx', Icons.cloud_upload_rounded, const Color(0xFFF2FAF6))),
        const SizedBox(width: 12),
        Expanded(child: _smallAction('My Orders', Icons.inventory_2_rounded, const Color(0xFFFFF8E9))),
      ],
    );
  }

  Widget _smallAction(String title, IconData icon, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: cardDecoration(),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(11)),
            child: Icon(icon, size: 18, color: AppColors.green),
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 11.4, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _routeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.softYellow, borderRadius: BorderRadius.circular(8)),
                child: const Text('ON ROUTE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.yellow)),
              ),
              const Spacer(),
              const Text('Est. 15 mins', style: TextStyle(fontSize: 9.6, color: AppColors.muted)),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Order #ORD-8832', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.0)),
          const SizedBox(height: 6),
          const Text('Your order is preparing for delivery', style: TextStyle(fontSize: 10.0, color: AppColors.muted)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const LinearProgressIndicator(value: .62, minHeight: 6, backgroundColor: Color(0xFFE9EEF3), color: AppColors.green),
          )
        ],
      ),
    );
  }

  Widget _quotationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: cardDecoration(),
      child: const Row(
        children: [
          CircleAvatar(radius: 17, backgroundColor: AppColors.blueSoft, child: Icon(Icons.description_outlined, size: 17, color: Color(0xFF7A8DAA))),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quotation Ready', style: TextStyle(fontSize: 11.4, fontWeight: FontWeight.w700)),
                SizedBox(height: 3),
                Text('Review prices for your prescription', style: TextStyle(fontSize: 10.0, color: AppColors.muted)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Color(0xFF97A2B5))
        ],
      ),
    );
  }

  Widget _categories() {
    const cats = [
      (Icons.medication_outlined, 'Medicines'),
      (Icons.health_and_safety_outlined, 'Vitamins'),
      (Icons.child_friendly_outlined, 'Baby Care'),
      (Icons.spa_outlined, 'Personal'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Categories', trailing: Text('See All', style: TextStyle(fontSize: 10.0, color: AppColors.green, fontWeight: FontWeight.w600))),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: cats.map((cat) {
            return Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(.035), blurRadius: 10, offset: const Offset(0, 4))]),
                  child: Icon(cat.$1, color: const Color(0xFF6C7888), size: 18),
                ),
                const SizedBox(height: 7),
                Text(cat.$2, style: const TextStyle(fontSize: 9.2, color: Color(0xFF6C7888))),
              ],
            );
          }).toList(),
        )
      ],
    );
  }

  Widget _featuredProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Featured Products'),
        const SizedBox(height: 12),
        Row(
          children: featuredProducts.map((product) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: featuredProducts.last == product ? 0 : 12),
                padding: const EdgeInsets.all(12),
                decoration: cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                      decoration: BoxDecoration(color: product.tagBg, borderRadius: BorderRadius.circular(8)),
                      child: Text(product.tag, style: TextStyle(fontSize: 8.7, color: product.tagText, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: SizedBox(width: 54, height: 54, child: ProductMockArt(variant: featuredProducts.indexOf(product))),
                    ),
                    const SizedBox(height: 10),
                    Text(product.name, maxLines: 2, style: const TextStyle(fontSize: 10.9, fontWeight: FontWeight.w700, height: 1.18)),
                    const SizedBox(height: 4),
                    Text(product.subtitle, style: const TextStyle(fontSize: 9.6, color: AppColors.muted)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w700)),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => addToCart(product),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(color: AppColors.green, borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.add, color: Colors.white, size: 15),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget _buyAgain() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Buy Again'),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: cardDecoration(),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(color: const Color(0xFFEAF3FF), borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.medical_services_outlined, color: Color(0xFF6E86AE), size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Salbutamol Inhaler', style: TextStyle(fontSize: 11.4, fontWeight: FontWeight.w700)),
                    SizedBox(height: 3),
                    Text('100mcg - 200 doses', style: TextStyle(fontSize: 9.8, color: AppColors.muted)),
                    SizedBox(height: 5),
                    Text('\$15.00', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(color: AppColors.lightGreen, borderRadius: BorderRadius.circular(8)),
                    child: const Text('Reorder', style: TextStyle(fontSize: 9.3, color: AppColors.green, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(color: AppColors.green, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.add, size: 15, color: Colors.white),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
