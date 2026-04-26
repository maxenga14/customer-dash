import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'order_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    super.key,
    required this.initialItems,
    this.onOrderPlaced,  // called after order confirmed → clears dashboard cart
  });
  final List<CartItem> initialItems;
  final VoidCallback? onOrderPlaced;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late List<CartItem> items;
  bool isDelivery = true;
  final addressController = TextEditingController(text: 'House 21, Makole Road, Dodoma');
  final phoneController = TextEditingController();
  final double deliveryFee = 5.50;

  @override
  void initState() {
    super.initState();
    items = widget.initialItems.map((e) => e.copy()).toList();
  }

  double get subtotal => items.fold(0, (p, e) => p + e.price * e.quantity);
  double get total => isDelivery ? subtotal + deliveryFee : subtotal;

  void changeQty(int i, int delta) {
    setState(() {
      items[i].quantity += delta;
      if (items[i].quantity <= 0) items.removeAt(i);
    });
    if (items.isEmpty) Navigator.pop(context, items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.greenDark, AppColors.green]),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context, items),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(.16), borderRadius: BorderRadius.circular(11)),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 15),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('Checkout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15.0)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _toggle(),
                    const SizedBox(height: 12),
                    if (!isDelivery) ...[
                      _pickupCard('Pharmacy', 'MediCare Central Pharmacy', 'Uhuru Street, Dodoma City Center', Icons.location_on_outlined),
                      const SizedBox(height: 10),
                      _pickupCard('Contact Person', 'Janeth Msuya', '+255 742 300 222', Icons.call_outlined),
                      const SizedBox(height: 12),
                    ],
                    const Text('Order Items', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.4)),
                    const SizedBox(height: 10),
                    ...items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(11),
                        decoration: cardDecoration(),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(color: const Color(0xFFF4F7FB), borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.medication_outlined, color: Color(0xFF7188AD), size: 20),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.2)),
                                  const SizedBox(height: 3),
                                  Text(item.subtitle, style: const TextStyle(fontSize: 9.5, color: AppColors.muted)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.2)),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(color: const Color(0xFFF4F7FB), borderRadius: BorderRadius.circular(12)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(onTap: () => changeQty(index, -1), child: const Padding(padding: EdgeInsets.all(7), child: Icon(Icons.remove, size: 15))),
                                      Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.0)),
                                      InkWell(onTap: () => changeQty(index, 1), child: const Padding(padding: EdgeInsets.all(7), child: Icon(Icons.add, size: 15, color: AppColors.green))),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 4),
                    _line('Subtotal', subtotal),
                    const SizedBox(height: 8),
                    if (isDelivery) ...[
                      _line('Delivery', deliveryFee),
                      const SizedBox(height: 12),
                      const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.4)),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: addressController,
                              maxLines: 3,
                              style: const TextStyle(fontSize: 12),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Enter delivery address',
                                contentPadding: const EdgeInsets.all(14),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 106,
                            child: ElevatedButton(
                              onPressed: () => setState(() => addressController.text = 'Current Location: Ntyuka, Dodoma'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.lightGreen,
                                foregroundColor: AppColors.green,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              ),
                              child: const Text('Use Current\nLocation', textAlign: TextAlign.center, style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w700)),
                            ),
                          )
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: cardDecoration(),
                      child: Column(
                        children: [
                          _line('Items Total', subtotal, compact: true),
                          if (isDelivery) ...[
                            const SizedBox(height: 8),
                            _line('Delivery Fee', deliveryFee, compact: true),
                          ],
                          const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1)),
                          _line('Grand Total', total, emphasize: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Payment Phone Number', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.0)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Enter phone number',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 380),
                            pageBuilder: (_, animation, __) => FadeTransition(
                              opacity: animation,
                              child: OrderConfirmationScreen(
                                orderNumber: '#ORD-${DateTime.now().millisecondsSinceEpoch % 90000 + 10000}',
                                itemsTotal: subtotal,
                                deliveryFee: deliveryFee,
                                deliveryAddress: addressController.text,
                                paymentPhone: phoneController.text.isEmpty ? 'M-Pesa (STK Push)' : phoneController.text,
                                isDelivery: isDelivery,
                                onOrderPlaced: widget.onOrderPlaced,
                              ),
                            ),
                          ),
                        );
                      },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        child: const Text('Place Order & Buy', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.0)),
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

  Widget _toggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: const Color(0xFFEFF4F7), borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Expanded(child: _toggleItem('Delivery', isDelivery, () => setState(() => isDelivery = true))),
          Expanded(child: _toggleItem('Pick Up', !isDelivery, () => setState(() => isDelivery = false))),
        ],
      ),
    );
  }

  Widget _toggleItem(String text, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: active ? [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 10, offset: const Offset(0, 4))] : [],
        ),
        child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 11.6, fontWeight: FontWeight.w700, color: active ? AppColors.text : AppColors.muted)),
      ),
    );
  }

  Widget _pickupCard(String title, String main, String sub, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 10.0, color: AppColors.muted, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(main, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.4)),
          const SizedBox(height: 6),
          Row(children: [Icon(icon, size: 15, color: AppColors.muted), const SizedBox(width: 6), Expanded(child: Text(sub, style: const TextStyle(fontSize: 11, color: AppColors.muted)))]),
        ],
      ),
    );
  }

  Widget _line(String label, double amount, {bool emphasize = false, bool compact = false}) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: compact ? 11.2 : 12.2, color: emphasize ? AppColors.text : AppColors.muted, fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600)),
        const Spacer(),
        Text('\$${amount.toStringAsFixed(2)}', style: TextStyle(fontSize: compact ? 11.2 : 12.2, color: emphasize ? AppColors.yellow : AppColors.text, fontWeight: FontWeight.w800)),
      ],
    );
  }
}
