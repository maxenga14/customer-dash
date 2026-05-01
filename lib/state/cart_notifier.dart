import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

/// Singleton cart shared across DashboardScreen, SearchScreen, and CheckoutScreen.
/// Any widget that calls [CartNotifier.instance] reads the same list.
class CartNotifier extends ValueNotifier<List<CartItem>> {
  CartNotifier._() : super([]);
  static final CartNotifier instance = CartNotifier._();

  // ── Computed ────────────────────────────────────────────────────────────
  int get totalItems => value.fold(0, (s, e) => s + e.quantity);
  double get totalPrice => value.fold(0.0, (s, e) => s + e.price * e.quantity);

  // ── Mutations ───────────────────────────────────────────────────────────
  void add(CartItem item) {
    final idx = value.indexWhere((e) => e.name == item.name);
    final next = List<CartItem>.from(value);
    if (idx >= 0) {
      next[idx].quantity++;
    } else {
      next.add(item);
    }
    value = next;
  }

  void addProduct({
    required String name,
    required String subtitle,
    required double price,
    required String tag,
  }) {
    add(CartItem(name: name, subtitle: subtitle,
        price: price, quantity: 1, tag: tag));
  }

  void increment(String name) {
    final idx = value.indexWhere((e) => e.name == name);
    if (idx < 0) return;
    final next = List<CartItem>.from(value);
    next[idx].quantity++;
    value = next;
  }

  void decrement(String name) {
    final idx = value.indexWhere((e) => e.name == name);
    if (idx < 0) return;
    final next = List<CartItem>.from(value);
    if (next[idx].quantity > 1) {
      next[idx].quantity--;
    } else {
      next.removeAt(idx);
    }
    value = next;
  }

  void remove(String name) {
    value = value.where((e) => e.name != name).toList();
  }

  void clear() => value = [];

  int quantityOf(String name) {
    final idx = value.indexWhere((e) => e.name == name);
    return idx >= 0 ? value[idx].quantity : 0;
  }

  /// Return a snapshot copy (for passing to CheckoutScreen).
  List<CartItem> get snapshot => value.map((e) => e.copy()).toList();
}
