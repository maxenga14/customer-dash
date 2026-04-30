import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/user_profile.dart';
import '../data/orders_data.dart';
import '../models/cart_item.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_bottom_nav.dart';
import '../widgets/common.dart';
import '../widgets/product_mock_art.dart';
import 'checkout_screen.dart';
import 'orders_screen.dart';
import 'prescriptions_screen.dart';
import 'settings_screen.dart';
import 'order_details_screen.dart';
import 'upload_rx_screen.dart';

// ── Dashboard user state ──────────────────────────────────────────────────
// In a real app these come from backend/auth. Toggled here for demo.
class _AppState {
  static bool isNewUser = false; // true  → no orders/history
  static bool hasActiveOrder = true; // false → hide tracking card
  static bool hasPendingQuote = true; // false → hide quotation card
  static bool pharmacySelected = true; // false → show "find pharmacy" banner
}

// ── Category meta ─────────────────────────────────────────────────────────
class _Cat {
  const _Cat(this.label, this.icon);
  final String label;
  final IconData icon;
}

const _categories = [
  _Cat('All', Icons.apps_rounded),
  _Cat('Medicines', Icons.medication_outlined),
  _Cat('Vitamins', Icons.health_and_safety_outlined),
  _Cat('Baby Care', Icons.child_friendly_outlined),
  _Cat('Personal', Icons.spa_outlined),
];

// ── Screen ────────────────────────────────────────────────────────────────
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;
  final List<CartItem> cart = [];
  String _selectedCategory = 'All';

  // ── One nested Navigator key per tab (including Home) ─────────────────
  // Index: 0=Home, 1=Orders, 2=Rx, 3=Settings
  final List<GlobalKey<NavigatorState>> _tabNavKeys = [
    GlobalKey<NavigatorState>(), // 0 Home
    GlobalKey<NavigatorState>(), // 1 Orders
    GlobalKey<NavigatorState>(), // 2 Rx
    GlobalKey<NavigatorState>(), // 3 Settings
  ];

  int get totalCartItems => cart.fold(0, (sum, item) => sum + item.quantity);

  void _addToCart(ProductData product) {
    final i = cart.indexWhere((e) => e.name == product.name);
    setState(() {
      if (i >= 0) {
        cart[i].quantity += 1;
      } else {
        cart.add(CartItem(
            name: product.name,
            subtitle: product.subtitle,
            price: product.price,
            quantity: 1,
            tag: product.tag));
      }
    });
  }

  Future<void> _openCheckout() async {
    if (cart.isEmpty) return;
    // Push checkout within the CURRENT tab's navigator so the
    // bottom nav bar stays visible throughout the checkout flow.
    _tabNavKeys[selectedIndex].currentState?.push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 320),
            reverseTransitionDuration: const Duration(milliseconds: 260),
            pageBuilder: (_, animation, __) => SlideTransition(
              position: Tween(begin: const Offset(1, 0), end: Offset.zero)
                  .animate(CurvedAnimation(
                      parent: animation, curve: Curves.easeOutCubic)),
              child: CheckoutScreen(
                initialItems: cart.map((e) => e.copy()).toList(),
                onOrderPlaced: () => setState(() => cart.clear()),
                onGoHome: () => setState(() => selectedIndex = 0),
              ),
            ),
          ),
        );
  }

  // ── Tab switching — NO Navigator.push, IndexedStack handles it ──────────
  void _navTo(int i) => setState(() => selectedIndex = i);

  @override
  Widget build(BuildContext context) {
    // Shell pattern: IndexedStack keeps all tabs alive & bottom nav
    // is a persistent overlay — never disappears on tab switch.
    return WillPopScope(
      // Android back: pop within the active tab's navigator first.
      // If at the tab root → switch back to Home tab.
      // If already on Home → let the OS handle (minimize/close).
      onWillPop: () async {
        // Try to pop within the active tab's nested navigator first
        final navKey = _tabNavKeys[selectedIndex];
        if (navKey.currentState?.canPop() == true) {
          navKey.currentState!.pop();
          return false; // handled — stay in app
        }
        if (selectedIndex != 0) {
          // At a tab's root — return to Home tab
          setState(() => selectedIndex = 0);
          return false;
        }
        return true; // on Home root → let OS handle (minimize / close)
      },
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: Stack(
          children: [
            // ── 4-tab IndexedStack ─────────────────────────────────────
            IndexedStack(
              index: selectedIndex,
              children: [
                // All 4 tabs use a nested Navigator + Padding so that ANY
                // Navigator.push from within the tab stays inside the tab's
                // Navigator — the bottom nav overlay is NEVER covered.
                _tabShell(0, SafeArea(bottom: false, child: _buildHomeTab())),
                _tabShell(1, const OrdersScreen()),
                _tabShell(2, const PrescriptionsScreen()),
                _tabShell(3, const SettingsScreen()),
              ],
            ),
            // ── Persistent bottom nav overlay ──────────────────────────
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedBottomNav(
                selectedIndex: selectedIndex,
                hasCart: cart.isNotEmpty,
                totalItems: totalCartItems,
                onTap: _navTo,
                onCheckoutTap: _openCheckout,
              ),
            ),
          ],
        ),
      ), // end Scaffold
    ); // end WillPopScope
  }

  /// Wraps each non-home tab in:
  ///   1. A nested Navigator (pushes stay within the tab → bottom nav
  ///      is NEVER covered by OrderDetailsScreen, UploadRxScreen, etc.)
  ///   2. A Padding constraint (physically shortens the subtree so the
  ///      Scaffold can't paint over the nav bar zone)
  ///
  /// [tabNavIndex]: 0=Home, 1=Orders, 2=Rx, 3=Settings
  Widget _tabShell(int tabNavIndex, Widget home) {
    final bottomInset = 82.0 + MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Navigator(
        key: _tabNavKeys[tabNavIndex],
        // Default route = the tab's home screen
        onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => home),
      ),
    );
  }

  /// Home tab body — extracted from build() for clarity.
  Widget _buildHomeTab() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _header()),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 12),
              _quickActions(),
              if (!_AppState.isNewUser && _AppState.hasActiveOrder) ...[
                const SizedBox(height: 12),
                _activeOrderCard(),
              ],
              if (!_AppState.isNewUser && _AppState.hasPendingQuote) ...[
                const SizedBox(height: 10),
                _quotationCard(),
              ],
              const SizedBox(height: 20),
              if (_AppState.isNewUser) ...[
                _newUserNudge(),
                const SizedBox(height: 20),
              ],
              if (!_AppState.isNewUser) ...[
                _buyAgainSection(),
                const SizedBox(height: 20),
              ],
              _categoryFilters(),
              const SizedBox(height: 14),
              _productGrid(),
            ]),
          ),
        ),
      ],
    );
  }

  // ── Header ─────────────────────────────────────────────────────────
  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [AppColors.greenDark, AppColors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(26), bottomRight: Radius.circular(26)),
      ),
      child: Column(
        children: [
          ValueListenableBuilder<UserProfileData>(
            valueListenable: UserProfile.instance,
            builder: (_, profile, __) => Row(children: [
              Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.18),
                      shape: BoxShape.circle),
                  child: profile.avatarBytes != null
                      ? ClipOval(
                          child: Image.memory(profile.avatarBytes!,
                              fit: BoxFit.cover, width: 36, height: 36))
                      : const Icon(Icons.person_rounded,
                          color: Colors.white, size: 18)),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const Text('Habari yako,',
                        style: TextStyle(
                            color: Color(0xFFD8FFF0), fontSize: 10.0)),
                    const SizedBox(height: 2),
                    Text(profile.name.trim().split(' ').first,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15.5)),
                  ])),
              Stack(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.16),
                        borderRadius: BorderRadius.circular(11)),
                    child: const Icon(Icons.notifications_none_rounded,
                        color: Colors.white, size: 17),
                  ),
                  if (!_AppState.isNewUser)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                            color: const Color(0xFFFFD166),
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: AppColors.green, width: 1.2)),
                      ),
                    ),
                ],
              ),
            ]),
          ),
          const SizedBox(height: 14),
          _pharmacyBanner(),
          const SizedBox(height: 14),
          // Search bar
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.17),
                  borderRadius: BorderRadius.circular(14)),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.white70, size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text('Search medicines, vitamins…',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ),
                  Icon(Icons.mic_none_rounded, color: Colors.white54, size: 17),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


    Widget _quickActions() {
    return Row(
      children: [
        Expanded(
            child: _actionCard(
          label: 'Upload Rx',
          icon: Icons.cloud_upload_rounded,
          bg: const Color(0xFFF2FAF6),
          onTap: () {
            _navTo(2); // switch to Rx tab
            // Small delay so the tab's Navigator is mounted before push
            Future.microtask(() => _tabNavKeys[2].currentState?.push(
                MaterialPageRoute(builder: (_) => const UploadRxScreen())));
          },
        )),
        const SizedBox(width: 12),
        Expanded(
            child: _actionCard(
          label: 'My Orders',
          icon: Icons.inventory_2_rounded,
          bg: const Color(0xFFFFF8E9),
          onTap: () => _navTo(1), // switch to Orders tab
        )),
      ],
    );
  }

  Widget _actionCard(
      {required String label,
      required IconData icon,
      required Color bg,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: cardDecoration(),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: bg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, size: 18, color: AppColors.green),
            ),
            const SizedBox(height: 10),
            Text(label,
                style: const TextStyle(
                    fontSize: 11.5, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ── Active order tracking card ────────────────────────────────────────
  Widget _activeOrderCard() {
    return GestureDetector(
      onTap: () {
        _navTo(1); // switch to Orders tab
        Future.microtask(() => _tabNavKeys[1].currentState?.push(
            MaterialPageRoute(
                builder: (_) => OrderDetailsScreen(order: mockOrders.first))));
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: AppColors.softYellow,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text('ON ROUTE',
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.yellow)),
                ),
                const SizedBox(width: 8),
                const Text('Order #ORD-8832',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 12.0)),
                const Spacer(),
                const Text('Est. 15 mins',
                    style: TextStyle(fontSize: 9.5, color: AppColors.muted)),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded,
                    size: 16, color: AppColors.muted),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Your order is out for delivery',
                style: TextStyle(fontSize: 10.5, color: AppColors.muted)),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const LinearProgressIndicator(
                  value: .62,
                  minHeight: 6,
                  backgroundColor: Color(0xFFE9EEF3),
                  color: AppColors.green),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _progressStep('Confirmed', true),
                _progressStep('Prepared', true),
                _progressStep('Picked Up', true),
                _progressStep('Delivered', false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressStep(String label, bool done) {
    return Row(
      children: [
        Icon(
          done
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          size: 11,
          color: done ? AppColors.green : AppColors.muted,
        ),
        const SizedBox(width: 3),
        Text(label,
            style: TextStyle(
                fontSize: 8.5,
                color: done ? AppColors.green : AppColors.muted,
                fontWeight: done ? FontWeight.w700 : FontWeight.w400)),
      ],
    );
  }

  // ── Quotation card ───────────────────────────────────────────────────
  Widget _quotationCard() {
    return GestureDetector(
      onTap: () => _navTo(2), // switch to Rx tab (PrescriptionsScreen is root)
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F8FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFCCDCF5)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: const Color(0xFFDDF6E9),
                  borderRadius: BorderRadius.circular(11)),
              child: const Icon(Icons.description_outlined,
                  size: 17, color: AppColors.green),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quotation Ready to Review',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  SizedBox(height: 3),
                  Text('Your prescription has been priced',
                      style: TextStyle(fontSize: 10, color: AppColors.muted)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(20)),
              child: const Text('Review',
                  style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // ── New user onboarding nudge ─────────────────────────────────────────
  Widget _newUserNudge() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF016A6F), Color(0xFF01878E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('First order?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                const Text(
                    'Upload your prescription and receive\na quotation within minutes.',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 10.5, height: 1.55)),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () {
                    _navTo(2);
                    Future.microtask(() => _tabNavKeys[2].currentState?.push(
                        MaterialPageRoute(
                            builder: (_) => const UploadRxScreen())));
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text('Upload Rx',
                        style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.green)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.medical_services_rounded,
              size: 54, color: Colors.white24),
        ],
      ),
    );
  }

  // ── Buy Again ──────────────────────────────────────────────────────
  Widget _buyAgainSection() {
    final items = buyAgainProducts;
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Buy Again'),
        const SizedBox(height: 10),
        ...items.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: cardDecoration(),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                          color: p.imageBg,
                          borderRadius: BorderRadius.circular(14)),
                      child: Icon(Icons.medical_services_outlined,
                          color: const Color(0xFF6E86AE), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.name,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 3),
                          Text(p.subtitle,
                              style: const TextStyle(
                                  fontSize: 10, color: AppColors.muted)),
                          const SizedBox(height: 4),
                          Text('\$${p.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: const Color(0xFFDDF6E9),
                                borderRadius: BorderRadius.circular(9)),
                            child: const Text('Reorder',
                                style: TextStyle(
                                    fontSize: 9.5,
                                    color: AppColors.green,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _addToCart(p),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                                color: AppColors.green,
                                borderRadius: BorderRadius.circular(9)),
                            child: const Icon(Icons.add,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  // ── Category filters ────────────────────────────────────────────────
  Widget _categoryFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('Browse Products',
                  style:
                      TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800)),
            ),
            Text(
              '${filteredProducts(_selectedCategory).length} items',
              style: const TextStyle(fontSize: 10, color: AppColors.muted),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: _categories.map((cat) {
              final isSelected = _selectedCategory == cat.label;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat.label),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.green : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.green
                            : const Color(0xFFDDE3ED),
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                  color: AppColors.green.withOpacity(.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3))
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        Icon(cat.icon,
                            size: 13,
                            color: isSelected ? Colors.white : AppColors.muted),
                        const SizedBox(width: 5),
                        Text(cat.label,
                            style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.text)),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ── Product grid (filtered) ──────────────────────────────────────────
  Widget _productGrid() {
    final products = filteredProducts(_selectedCategory);
    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              const Icon(Icons.search_off_rounded,
                  size: 40, color: AppColors.muted),
              const SizedBox(height: 10),
              Text('No $_selectedCategory items available',
                  style: const TextStyle(fontSize: 13, color: AppColors.muted)),
            ],
          ),
        ),
      );
    }

    // 2-column grid
    final rows = <Widget>[];
    for (int i = 0; i < products.length; i += 2) {
      final left = products[i];
      final right = i + 1 < products.length ? products[i + 1] : null;
      rows.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _productCard(left, i)),
          const SizedBox(width: 12),
          Expanded(
              child: right != null
                  ? _productCard(right, i + 1)
                  : const SizedBox.shrink()),
        ],
      ));
      if (i + 2 < products.length) rows.add(const SizedBox(height: 12));
    }

    return Column(children: rows);
  }

  Widget _productCard(ProductData p, int idx) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                    color: p.tagBg, borderRadius: BorderRadius.circular(7)),
                child: Text(p.tag,
                    style: TextStyle(
                        fontSize: 8.5,
                        color: p.tagText,
                        fontWeight: FontWeight.w700)),
              ),
              const Spacer(),
              // Category micro label
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(p.category,
                    style:
                        const TextStyle(fontSize: 7.5, color: AppColors.muted)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
                width: 56, height: 56, child: ProductMockArt(variant: idx % 6)),
          ),
          const SizedBox(height: 10),
          Text(p.name.replaceAll('\n', ' '),
              maxLines: 2,
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700, height: 1.2)),
          const SizedBox(height: 3),
          Text(p.subtitle,
              style: const TextStyle(fontSize: 9.5, color: AppColors.muted)),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('\$${p.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 13.5, fontWeight: FontWeight.w800)),
              const Spacer(),
              GestureDetector(
                onTap: () => _addToCart(p),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.add, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
