import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/mock_data.dart';
import '../models/cart_item.dart';
import '../screens/checkout_screen.dart';
import '../state/cart_notifier.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.initialQuery = ''});
  final String initialQuery;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _queryCtrl;
  final FocusNode _focus = FocusNode();
  String _selectedCategory = 'All';

  static const _categories = [
    'All', 'Medicines', 'Vitamins', 'Baby Care', 'Personal',
  ];

  // ── Fix 3: use ValueListenableBuilder so cart updates are instant ──────
  // (no manual addListener / setState needed for cart counts)

  @override
  void initState() {
    super.initState();
    _queryCtrl = TextEditingController(text: widget.initialQuery);
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
    _queryCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _queryCtrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  // ── Fix 1: smart back — clear query first, then category, then dismiss ─
  Future<bool> _onWillPop() async {
    if (_queryCtrl.text.isNotEmpty) {
      _queryCtrl.clear();
      _focus.requestFocus();
      return false; // stay on search
    }
    if (_selectedCategory != 'All') {
      setState(() => _selectedCategory = 'All');
      return false; // stay on search
    }
    return true; // nothing to clear → dismiss
  }

  List<ProductData> get _results {
    final q = _queryCtrl.text.trim().toLowerCase();
    return allProducts.where((p) {
      final catMatch =
          _selectedCategory == 'All' || p.category == _selectedCategory;
      final qMatch = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.subtitle.toLowerCase().contains(q) ||
          p.tag.toLowerCase().contains(q);
      return catMatch && qMatch;
    }).toList();
  }

  void _addToCart(ProductData p) {
    HapticFeedback.lightImpact();
    CartNotifier.instance.addProduct(
      name: p.name,
      subtitle: p.subtitle,
      price: p.price.toDouble(),
      tag: p.tag,
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${p.name} added'),
      backgroundColor: AppColors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 86),
      duration: const Duration(milliseconds: 900),
    ));
  }

  // ── Fix 2: cart button opens checkout (pushed within same tab navigator)
  void _openCartFromSearch() {
    if (CartNotifier.instance.value.isEmpty) return;
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 320),
        reverseTransitionDuration: const Duration(milliseconds: 260),
        pageBuilder: (_, animation, __) => SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: CheckoutScreen(
            initialItems: CartNotifier.instance.snapshot,
            onOrderPlaced: () {
              CartNotifier.instance.clear();
              // Pop checkout then pop search → back to dashboard home
              Navigator.of(context)
                ..pop() // checkout
                ..pop(); // search
            },
            onGoHome: () {
              Navigator.of(context)
                ..pop()
                ..pop();
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder guarantees instant rebuild on every cart change
    // — no manual listener, no setState race condition.
    return WillPopScope(
      onWillPop: _onWillPop,
      child: ValueListenableBuilder<List<CartItem>>(
        valueListenable: CartNotifier.instance,
        builder: (context, cartItems, _) {
          final cartCount = cartItems.fold(0, (s, e) => s + e.quantity);
          final results = _results;

          return Scaffold(
            backgroundColor: AppColors.bg,
            body: SafeArea(
              child: Column(children: [
                // ── Search header ─────────────────────────────────────
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(8, 10, 16, 12),
                  child: Row(children: [
                    // Back arrow — also respects smart-back logic
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                      color: AppColors.text,
                      onPressed: () async {
                        final shouldPop = await _onWillPop();
                        if (shouldPop && mounted) Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                            color: AppColors.bg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border)),
                        child: TextField(
                          controller: _queryCtrl,
                          focusNode: _focus,
                          style: const TextStyle(
                              fontSize: 13.5, color: AppColors.text),
                          decoration: InputDecoration(
                            hintText: 'Search medicines, vitamins...',
                            hintStyle: const TextStyle(
                                fontSize: 13, color: AppColors.muted),
                            prefixIcon: const Icon(Icons.search_rounded,
                                size: 18, color: AppColors.muted),
                            suffixIcon: _queryCtrl.text.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      _queryCtrl.clear();
                                      _focus.requestFocus();
                                    },
                                    child: const Icon(Icons.close_rounded,
                                        size: 16, color: AppColors.muted),
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 11),
                          ),
                        ),
                      ),
                    ),
                    // ── Fix 2: live cart badge — tappable, opens checkout
                    if (cartCount > 0) ...[
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _openCartFromSearch,
                        child: Stack(children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                                color: AppColors.lightGreen,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: AppColors.green.withOpacity(.25))),
                            child: const Icon(Icons.shopping_cart_outlined,
                                size: 20, color: AppColors.green),
                          ),
                          Positioned(
                            right: 4, top: 4,
                            child: Container(
                              width: 17, height: 17,
                              decoration: const BoxDecoration(
                                  color: AppColors.green,
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Text('$cartCount',
                                    style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ]),
                ),

                // ── Category pills ─────────────────────────────────────
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: SizedBox(
                    height: 32,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final cat = _categories[i];
                        final sel = _selectedCategory == cat;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                                color: sel ? AppColors.green : AppColors.bg,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color:
                                        sel ? AppColors.green : AppColors.border)),
                            child: Text(cat,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        sel ? Colors.white : AppColors.muted)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const Divider(height: 1, color: AppColors.border),

                // ── Results ───────────────────────────────────────────
                Expanded(
                  child: results.isEmpty
                      ? _emptyState()
                      : ListView.builder(
                          padding:
                              const EdgeInsets.fromLTRB(16, 12, 16, 16),
                          itemCount: results.length,
                          itemBuilder: (_, i) =>
                              _resultCard(results[i], cartItems),
                        ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }

  // Pass cartItems snapshot in so card quantities are always in sync
  Widget _resultCard(ProductData p, List<CartItem> cartItems) {
    final idx = cartItems.indexWhere((e) => e.name == p.name);
    final qty = idx >= 0 ? cartItems[idx].quantity : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.03),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ]),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
                color: p.imageBg,
                borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.medication_liquid_outlined,
                size: 26, color: Colors.white70),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(p.name,
                  style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text)),
              const SizedBox(height: 2),
              Text(p.subtitle,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.muted)),
              const SizedBox(height: 6),
              Row(children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: p.tagBg,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(p.tag,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: p.tagText)),
                ),
                const Spacer(),
                Text(formatTsh(p.price.toDouble()),
                    style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.green)),
              ]),
            ]),
          ),
          const SizedBox(width: 10),
          // ── Qty control ─────────────────────────────────────────────
          qty == 0
              ? GestureDetector(
                  onTap: () => _addToCart(p),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.add_rounded,
                        color: Colors.white, size: 20),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                      color: AppColors.lightGreen,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.green.withOpacity(.2))),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        CartNotifier.instance.decrement(p.name);
                      },
                      child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.remove_rounded,
                              size: 14, color: AppColors.green)),
                    ),
                    Text('$qty',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.green)),
                    GestureDetector(
                      onTap: () => _addToCart(p),
                      child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.add_rounded,
                              size: 14, color: AppColors.green)),
                    ),
                  ]),
                ),
        ]),
      ),
    );
  }

  Widget _emptyState() => Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.search_off_rounded,
                  size: 36, color: AppColors.muted)),
          const SizedBox(height: 16),
          Text(
              _queryCtrl.text.isEmpty
                  ? 'Start typing to search'
                  : 'No results for "${_queryCtrl.text}"',
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text)),
          if (_queryCtrl.text.isNotEmpty) ...[
            const SizedBox(height: 6),
            const Text('Try a different name or category.',
                style:
                    TextStyle(fontSize: 12.5, color: AppColors.muted)),
          ],
        ]),
      );
}
