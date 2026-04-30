import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/cart_item.dart';
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
  List<CartItem> _cart = [];

  static const _categories = [
    'All', 'Medicines', 'Vitamins', 'Baby Care', 'Personal',
  ];

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

  List<ProductData> get _results {
    final q = _queryCtrl.text.trim().toLowerCase();
    return allProducts.where((p) {
      final catMatch = _selectedCategory == 'All' || p.category == _selectedCategory;
      final qMatch = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.subtitle.toLowerCase().contains(q) ||
          p.tag.toLowerCase().contains(q);
      return catMatch && qMatch;
    }).toList();
  }

  void _addToCart(ProductData p) {
    setState(() {
      final idx = _cart.indexWhere((c) => c.name == p.name);
      if (idx >= 0) {
        _cart[idx].quantity++;
      } else {
        _cart.add(CartItem(
          name: p.name,
          subtitle: p.subtitle,
          price: p.price.toDouble(),
          quantity: 1,
          tag: p.tag,
        ));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${p.name} added to cart'),
      backgroundColor: AppColors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 1),
    ));
  }

  int _qtyInCart(ProductData p) {
    final idx = _cart.indexWhere((c) => c.name == p.name);
    return idx >= 0 ? _cart[idx].quantity : 0;
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(children: [
          // ── Search bar ────────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
            child: Row(children: [
              IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  color: AppColors.text,
                  onPressed: () => Navigator.pop(context, _cart)),
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
                    style: const TextStyle(fontSize: 13.5, color: AppColors.text),
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
            ]),
          ),

          // ── Category pills ────────────────────────────────────────────
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
                              color: sel ? AppColors.green : AppColors.border)),
                      child: Text(cat,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: sel ? Colors.white : AppColors.muted)),
                    ),
                  );
                },
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.border),

          // ── Results ───────────────────────────────────────────────────
          Expanded(
            child: results.isEmpty ? _emptyState() : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: results.length,
              itemBuilder: (_, i) => _resultCard(results[i]),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _resultCard(ProductData p) {
    final qty = _qtyInCart(p);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.03),
                blurRadius: 8, offset: const Offset(0, 2))
          ]),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          // Image placeholder
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
                color: p.imageBg, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.medication_liquid_outlined,
                size: 26, color: Colors.white70),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(p.name,
                  style: const TextStyle(
                      fontSize: 13.5, fontWeight: FontWeight.w700,
                      color: AppColors.text)),
              const SizedBox(height: 2),
              Text(p.subtitle,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.muted)),
              const SizedBox(height: 6),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: p.tagBg,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(p.tag,
                      style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w700,
                          color: p.tagText)),
                ),
                const Spacer(),
                Text(formatTsh(p.price.toDouble()),
                    style: const TextStyle(
                        fontSize: 13.5, fontWeight: FontWeight.w800,
                        color: AppColors.green)),
              ]),
            ]),
          ),
          const SizedBox(width: 10),
          // Cart control
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
                      onTap: () => setState(() {
                        final idx = _cart.indexWhere((c) => c.name == p.name);
                        if (_cart[idx].quantity > 1) {
                          _cart[idx].quantity--;
                        } else {
                          _cart.removeAt(idx);
                        }
                      }),
                      child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.remove_rounded,
                              size: 14, color: AppColors.green)),
                    ),
                    Text('$qty',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w800,
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
                  fontSize: 14, fontWeight: FontWeight.w700,
                  color: AppColors.text)),
          if (_queryCtrl.text.isNotEmpty) ...[
            const SizedBox(height: 6),
            const Text('Try a different name or category.',
                style: TextStyle(fontSize: 12.5, color: AppColors.muted)),
          ],
        ]),
      );
}
