import 'package:flutter/material.dart';
import '../data/orders_data.dart';
import '../data/prescriptions_data.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'checkout_screen.dart';
import 'order_details_screen.dart';
import 'rx_details_screen.dart';
import '../widgets/product_mock_art.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();
  String _query = '';

  static const tabs = ['All Orders', 'Active', 'Delivered', 'Needs Action'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Order> get _filtered {
    final all = mockOrders;
    List<Order> list;
    switch (_tabController.index) {
      case 1:
        list = all.where((o) => o.status == OrderStatus.onRoute || o.status == OrderStatus.needsAction).toList();
        break;
      case 2:
        list = all.where((o) => o.status == OrderStatus.delivered).toList();
        break;
      case 3:
        list = all.where((o) => o.status == OrderStatus.needsAction).toList();
        break;
      default:
        list = all;
    }
    if (_query.isNotEmpty) {
      list = list.where((o) => o.orderNumber.toLowerCase().contains(_query.toLowerCase())).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _filtered.isEmpty
                  ? _emptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) =>
                          _OrderCard(order: _filtered[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                const Expanded(
                  child: Text('Orders',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text)),
                ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(Icons.notifications_none_rounded,
                      size: 18, color: AppColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded,
                            size: 17, color: AppColors.muted),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v) => setState(() => _query = v),
                            style: const TextStyle(fontSize: 11.5),
                            decoration: const InputDecoration(
                              hintText: 'Search by Order ID...',
                              hintStyle: TextStyle(
                                  fontSize: 11.5, color: AppColors.muted),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(Icons.filter_list_rounded,
                      size: 18, color: AppColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final active = _tabController.index == index;
                return GestureDetector(
                  onTap: () {
                    _tabController.animateTo(index);
                    setState(() {});
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? AppColors.green : AppColors.bg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: active ? Colors.white : AppColors.muted,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF0F3F6)),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inventory_2_outlined,
              size: 48, color: AppColors.muted),
          const SizedBox(height: 14),
          const Text('No orders found',
              style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.text)),
          const SizedBox(height: 6),
          Text(
            _query.isNotEmpty
                ? 'Try a different order ID'
                : 'Your orders will appear here',
            style:
                const TextStyle(fontSize: 11.5, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(13),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── top row: order number + status badge
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ORDER ${order.orderNumber}',
                      style: const TextStyle(
                          fontSize: 9.2,
                          color: AppColors.muted,
                          fontWeight: FontWeight.w700,
                          letterSpacing: .3)),
                  const SizedBox(height: 3),
                  Text(order.date,
                      style: const TextStyle(
                          fontSize: 11.8, fontWeight: FontWeight.w700)),
                ],
              ),
              const Spacer(),
              _StatusBadge(status: order.status),
            ],
          ),

          const SizedBox(height: 12),

          // ── quotation card (needsAction only)
          if (order.status == OrderStatus.needsAction &&
              order.quotationNote != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F8FF),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: const Color(0xFFDDE8F8)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: const Color(0xFFDDE8F8)),
                    ),
                    child: const Icon(Icons.description_outlined,
                        size: 16, color: Color(0xFF5B8FC9)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(order.quotationNote!,
                        style: const TextStyle(
                            fontSize: 11.2,
                            color: AppColors.text,
                            height: 1.45)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Find the first quotationReady prescription and
                  // deep-link directly to its RxDetailsScreen
                  final rx = mockPrescriptions.firstWhere(
                    (p) => p.status.name == 'quotationReady',
                    orElse: () => mockPrescriptions.first,
                  );
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration:
                          const Duration(milliseconds: 320),
                      reverseTransitionDuration:
                          const Duration(milliseconds: 260),
                      pageBuilder: (_, animation, __) =>
                          SlideTransition(
                        position: Tween(
                                begin: const Offset(1, 0),
                                end: Offset.zero)
                            .animate(CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutCubic)),
                        child: RxDetailsScreen(rx: rx),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B8FC9),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Review Quotation',
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ),
          ] else ...[
            // ── product art + summary row
            Row(
              children: [
                if (order.productImageVariant != null)
                  SizedBox(
                    width: 46,
                    height: 46,
                    child:
                        ProductMockArt(variant: order.productImageVariant!),
                  ),
                if (order.productImageVariant != null)
                  const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${order.itemCount} ${order.itemCount == 1 ? 'Item' : 'Items'} • ${order.isDelivery ? 'Delivery' : 'Pickup'}',
                        style: const TextStyle(
                            fontSize: 10.5, color: AppColors.muted),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${order.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.text),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // ── action buttons
            _actionRow(order),
          ],
        ],
      ),
    );
  }

  Widget _actionRow(Order order) {
    if (order.status == OrderStatus.onRoute) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFDDE3ED)),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Track Driver',
                  style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () => Navigator.push(
                  ctx,
                  MaterialPageRoute(
                    builder: (_) => OrderDetailsScreen(
                      order: order,
                      hasPrescription: order.orderNumber == '#ORD-8478',
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('View Details',
                    style: TextStyle(
                        fontSize: 11.5, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      );
    }

    if (order.status == OrderStatus.delivered) {
      return Row(
        children: [
          Expanded(
            child: Builder(
              builder: (ctx) => OutlinedButton(
                onPressed: () {
                  // Build CartItems from this order's line items and send
                  // the customer straight to checkout pre-filled
                  final cartItems = OrderDetailsScreen.itemsForOrder(order);
                  Navigator.push(
                    ctx,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 320),
                      reverseTransitionDuration:
                          const Duration(milliseconds: 260),
                      pageBuilder: (_, animation, __) => SlideTransition(
                        position: Tween(
                                begin: const Offset(1, 0), end: Offset.zero)
                            .animate(CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutCubic)),
                        child: CheckoutScreen(initialItems: cartItems),
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFDDE3ED)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Reorder',
                    style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () => Navigator.push(
                  ctx,
                  MaterialPageRoute(
                    builder: (_) => OrderDetailsScreen(
                      order: order,
                      hasPrescription: false,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('View Details',
                    style: TextStyle(
                        fontSize: 11.5, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      );
    }

    // cancelled — no actions, just show total
    return const SizedBox.shrink();
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.badgeBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.badgeIcon, size: 11, color: status.badgeColor),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: status.badgeColor,
            ),
          ),
        ],
      ),
    );
  }
}
