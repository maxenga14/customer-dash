class CartItem {
  CartItem({
    this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    this.quantity = 1,
    this.tag,
  });

  /// Inventory item ID — null for mock data, populated when connected to backend.
  /// Used for deduplication and order creation in Supabase.
  final String? id;

  final String name;
  final String subtitle;
  final double price;
  int quantity;
  final String? tag;

  CartItem copy() => CartItem(
        id: id,
        name: name,
        subtitle: subtitle,
        price: price,
        quantity: quantity,
        tag: tag,
      );
}
