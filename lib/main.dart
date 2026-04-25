import 'package:flutter/material.dart';

void main() {
  runApp(const CustomerDashApp());
}

class CustomerDashApp extends StatelessWidget {
  const CustomerDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Customer Dash',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F7F9),
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF17A772),
          primary: const Color(0xFF17A772),
          surface: Colors.white,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class CartItem {
  CartItem({
    required this.name,
    required this.subtitle,
    required this.price,
    this.quantity = 1,
    this.tag,
  });

  final String name;
  final String subtitle;
  final double price;
  int quantity;
  final String? tag;
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;
  final List<CartItem> cart = [];

  final List<Map<String, dynamic>> featuredProducts = [
    {
      'name': 'Daily Multivitamin',
      'subtitle': '60 Gummies',
      'price': 12.99,
      'tag': 'In Stock',
      'tagColor': const Color(0xFFDDF6E9),
      'tagTextColor': const Color(0xFF17A772),
      'color': const Color(0xFFFFF1F1),
    },
    {
      'name': 'Paracetamol\n500mg',
      'subtitle': 'Pack of 16',
      'price': 4.50,
      'tag': 'Low Stock',
      'tagColor': const Color(0xFFFFEBCF),
      'tagTextColor': const Color(0xFFF0A529),
      'color': const Color(0xFFEAF3FF),
    },
  ];

  void addToCart(Map<String, dynamic> product) {
    final index = cart.indexWhere((item) => item.name == product['name']);
    setState(() {
      if (index >= 0) {
        cart[index].quantity += 1;
      } else {
        cart.add(
          CartItem(
            name: product['name'],
            subtitle: product['subtitle'],
            price: product['price'],
            quantity: 1,
            tag: product['tag'],
          ),
        );
      }
    });
  }

  int get totalCartItems => cart.fold(0, (sum, item) => sum + item.quantity);

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
                        _buildHeader(),
                        Transform.translate(
                          offset: const Offset(0, -24),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                _buildQuickActions(),
                                const SizedBox(height: 12),
                                _buildOnRouteCard(),
                                const SizedBox(height: 12),
                                _buildQuotationCard(),
                                const SizedBox(height: 18),
                                _buildCategories(),
                                const SizedBox(height: 18),
                                _buildFeaturedProducts(),
                                const SizedBox(height: 18),
                                _buildBuyAgain(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 86),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _AnimatedBottomBar(
                selectedIndex: selectedIndex,
                hasCart: cart.isNotEmpty,
                onTap: (index) {
                  setState(() => selectedIndex = index);
                },
                onCartTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CheckoutScreen(initialItems: List<CartItem>.from(cart.map((e) => CartItem(name: e.name, subtitle: e.subtitle, price: e.price, quantity: e.quantity, tag: e.tag)))),
                    ),
                  );
                  if (result is List<CartItem>) {
                    setState(() {
                      cart
                        ..clear()
                        ..addAll(result);
                    });
                  }
                },
                totalItems: totalCartItems,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 36),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        gradient: LinearGradient(
          colors: [Color(0xFF118B62), Color(0xFF1DB77D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Good Morning,', style: TextStyle(color: Color(0xFFD9FFF0), fontSize: 11)),
                    SizedBox(height: 2),
                    Text('Alex Johnson', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                  ],
                ),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.16),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.white70, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Search medicines, health products...',
                    style: TextStyle(color: Colors.white70, fontSize: 12.5),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(child: _quickActionCard('Upload Rx', Icons.cloud_upload_outlined, const Color(0xFFF2FAF6))),
        const SizedBox(width: 12),
        Expanded(child: _quickActionCard('My Orders', Icons.inventory_2_outlined, const Color(0xFFFFF8E9))),
      ],
    );
  }

  Widget _quickActionCard(String title, IconData icon, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, size: 18, color: const Color(0xFF17A772)),
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildOnRouteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFFFF4DE), borderRadius: BorderRadius.circular(8)),
                child: const Text('ON ROUTE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFFF0A529))),
              ),
              const Spacer(),
              const Text('Est. 15 mins', style: TextStyle(fontSize: 10, color: Color(0xFF8B95A7))),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Order #ORD-8832', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 7),
          const Text('Your order is preparing for delivery', style: TextStyle(fontSize: 11, color: Color(0xFF8B95A7))),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const LinearProgressIndicator(value: .62, minHeight: 6, backgroundColor: Color(0xFFE9EEF3), color: Color(0xFF17A772)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFF0F5FF),
            child: Icon(Icons.description_outlined, size: 18, color: Color(0xFF7A8DAA)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quotation Ready', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                SizedBox(height: 3),
                Text('Review prices for your prescription', style: TextStyle(fontSize: 11, color: Color(0xFF8B95A7))),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Color(0xFF97A2B5))
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final cats = [
      {'icon': Icons.medication_outlined, 'label': 'Medicines'},
      {'icon': Icons.health_and_safety_outlined, 'label': 'Vitamins'},
      {'icon': Icons.child_friendly_outlined, 'label': 'Baby Care'},
      {'icon': Icons.spa_outlined, 'label': 'Personal'},
    ];
    return Column(
      children: [
        Row(
          children: [
            const Text('Categories', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            const Spacer(),
            Text('See All', style: TextStyle(fontSize: 11, color: Colors.green.shade600, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: cats.map((cat) {
            return Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.035), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Icon(cat['icon'] as IconData, color: const Color(0xFF697586), size: 18),
                ),
                const SizedBox(height: 8),
                Text(cat['label'] as String, style: const TextStyle(fontSize: 10.5, color: Color(0xFF697586))),
              ],
            );
          }).toList(),
        )
      ],
    );
  }

  Widget _buildFeaturedProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Featured Products', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Row(
          children: featuredProducts.map((product) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: featuredProducts.last == product ? 0 : 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                      decoration: BoxDecoration(
                        color: product['tagColor'] as Color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(product['tag'], style: TextStyle(fontSize: 8.8, fontWeight: FontWeight.w700, color: product['tagTextColor'] as Color)),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        height: 58,
                        width: 58,
                        decoration: BoxDecoration(color: product['color'] as Color, borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.medication_liquid_outlined, color: Color(0xFF7A8DAA)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(product['name'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12), maxLines: 2),
                    const SizedBox(height: 4),
                    Text(product['subtitle'], style: const TextStyle(fontSize: 10.5, color: Color(0xFF8B95A7))),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text('\$${(product['price'] as double).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        const Spacer(),
                        InkWell(
                          onTap: () => addToCart(product),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(color: const Color(0xFF17A772), borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.add, size: 16, color: Colors.white),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBuyAgain() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Buy Again', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 12, offset: const Offset(0, 4))],
          ),
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
                    Text('Salbutamol Inhaler', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                    SizedBox(height: 3),
                    Text('100mcg - 200 doses', style: TextStyle(fontSize: 10.5, color: Color(0xFF8B95A7))),
                    SizedBox(height: 5),
                    Text('\$15.00', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(color: const Color(0xFFE8FAF1), borderRadius: BorderRadius.circular(8)),
                    child: const Text('Reorder', style: TextStyle(fontSize: 9.5, color: Color(0xFF17A772), fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(color: const Color(0xFF17A772), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.add, size: 16, color: Colors.white),
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

class _AnimatedBottomBar extends StatelessWidget {
  const _AnimatedBottomBar({
    required this.selectedIndex,
    required this.hasCart,
    required this.onTap,
    required this.onCartTap,
    required this.totalItems,
  });

  final int selectedIndex;
  final bool hasCart;
  final ValueChanged<int> onTap;
  final VoidCallback onCartTap;
  final int totalItems;

  @override
  Widget build(BuildContext context) {
    final items = const [
      {'icon': Icons.home_filled, 'label': 'Home'},
      {'icon': Icons.inventory_2_outlined, 'label': 'Orders'},
      {'icon': Icons.receipt_long_outlined, 'label': 'Rx'},
      {'icon': Icons.settings_outlined, 'label': 'Settings'},
    ];

    return SizedBox(
      height: 102,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 12,
            right: 12,
            bottom: 10,
            child: Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(.07), blurRadius: 24, offset: const Offset(0, 6))],
              ),
              child: Row(
                children: List.generate(items.length, (index) {
                  final beforeGap = hasCart && index == 2;
                  return Expanded(
                    child: AnimatedPadding(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.only(left: beforeGap ? 44 : 0),
                      child: InkWell(
                        onTap: () => onTap(index),
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              items[index]['icon'] as IconData,
                              size: 21,
                              color: selectedIndex == index ? const Color(0xFF17A772) : const Color(0xFFA3ACBA),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              items[index]['label'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: selectedIndex == index ? FontWeight.w700 : FontWeight.w500,
                                color: selectedIndex == index ? const Color(0xFF17A772) : const Color(0xFFA3ACBA),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: hasCart ? 28 : -80,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: hasCart ? 1 : 0,
              child: GestureDetector(
                onTap: onCartTap,
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF17A772),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: const Color(0xFF17A772).withOpacity(.35), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.shopping_cart_checkout_rounded, color: Colors.white, size: 22),
                          Positioned(
                            right: -8,
                            top: -8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: Text('$totalItems', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF17A772))),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: 10),
                      Text('Checkout', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.initialItems});

  final List<CartItem> initialItems;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late List<CartItem> items;
  bool isDelivery = true;
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final double deliveryFee = 5.50;

  @override
  void initState() {
    super.initState();
    items = widget.initialItems;
    addressController.text = 'House 21, Makole Road, Dodoma';
  }

  double get subtotal => items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get grandTotal => isDelivery ? subtotal + deliveryFee : subtotal;

  void changeQty(int index, int delta) {
    setState(() {
      items[index].quantity += delta;
      if (items[index].quantity <= 0) {
        items.removeAt(index);
      }
    });
    if (items.isEmpty) {
      Navigator.pop(context, items);
    }
  }

  void placeOrder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order placed successfully')),
    );
    Navigator.pop(context, <CartItem>[]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
                gradient: LinearGradient(colors: [Color(0xFF118B62), Color(0xFF1DB77D)]),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context, items),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(.15), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 17),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Checkout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _segmentSwitcher(),
                    const SizedBox(height: 16),
                    if (!isDelivery) ...[
                      _infoCard(
                        title: 'Pharmacy Location',
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('MediCare Central Pharmacy', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            SizedBox(height: 6),
                            Row(children: [Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF728093)), SizedBox(width: 6), Expanded(child: Text('Uhuru Street, Dodoma City Center', style: TextStyle(fontSize: 11.5, color: Color(0xFF728093))))]),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _infoCard(
                        title: 'Contact Person',
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Janeth Msuya', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            SizedBox(height: 6),
                            Row(children: [Icon(Icons.call_outlined, size: 16, color: Color(0xFF728093)), SizedBox(width: 6), Text('+255 742 300 222', style: TextStyle(fontSize: 11.5, color: Color(0xFF728093)))]),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                    const Text('Order Items', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    const SizedBox(height: 10),
                    ...List.generate(items.length, (index) {
                      final item = items[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 12, offset: const Offset(0, 4))],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(color: const Color(0xFFF4F7FB), borderRadius: BorderRadius.circular(14)),
                              child: const Icon(Icons.medication_outlined, color: Color(0xFF6E86AE)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                                  const SizedBox(height: 4),
                                  Text(item.subtitle, style: const TextStyle(fontSize: 10.5, color: Color(0xFF8B95A7))),
                                  const SizedBox(height: 6),
                                  Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(color: const Color(0xFFF4F7FB), borderRadius: BorderRadius.circular(14)),
                              child: Row(
                                children: [
                                  IconButton(onPressed: () => changeQty(index, -1), icon: const Icon(Icons.remove, size: 16)),
                                  Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                  IconButton(onPressed: () => changeQty(index, 1), icon: const Icon(Icons.add, size: 16, color: Color(0xFF17A772))),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    _summaryRow('Subtotal', subtotal),
                    const SizedBox(height: 8),
                    if (isDelivery) ...[
                      _summaryRow('Delivery', deliveryFee),
                      const SizedBox(height: 14),
                      const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: addressController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Enter delivery address',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.all(14),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 118,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE8FAF1),
                                foregroundColor: const Color(0xFF17A772),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              onPressed: () {
                                setState(() {
                                  addressController.text = 'Current Location: Ntyuka, Dodoma';
                                });
                              },
                              child: const Text('Use Current\nLocation', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11)),
                            ),
                          )
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        children: [
                          _summaryRow('Items Total', subtotal, compact: true),
                          if (isDelivery) ...[
                            const SizedBox(height: 8),
                            _summaryRow('Delivery Fee', deliveryFee, compact: true),
                          ],
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(height: 1),
                          ),
                          _summaryRow('Grand Total', grandTotal, emphasize: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Payment Phone Number', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter phone number',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF17A772),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        onPressed: placeOrder,
                        child: const Text('Place Order & Buy', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _segmentSwitcher() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: const Color(0xFFEFF4F7), borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Expanded(child: _segmentItem('Delivery', isDelivery, () => setState(() => isDelivery = true))),
          Expanded(child: _segmentItem('Pick Up', !isDelivery, () => setState(() => isDelivery = false))),
        ],
      ),
    );
  }

  Widget _segmentItem(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: active ? [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 10, offset: const Offset(0, 3))] : [],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: active ? const Color(0xFF12202F) : const Color(0xFF8B95A7),
          ),
        ),
      ),
    );
  }

  Widget _infoCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF8B95A7))),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _summaryRow(String label, double value, {bool emphasize = false, bool compact = false}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: compact ? 11.5 : 12.5,
            color: emphasize ? const Color(0xFF12202F) : const Color(0xFF728093),
            fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: compact ? 11.5 : 12.5,
            color: emphasize ? const Color(0xFFF0A529) : const Color(0xFF12202F),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
