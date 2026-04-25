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

  CartItem copy() => CartItem(
        name: name,
        subtitle: subtitle,
        price: price,
        quantity: quantity,
        tag: tag,
      );
}
