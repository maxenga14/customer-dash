import 'package:flutter/material.dart';

// ── Screens ───────────────────────────────────────────────────────────
import 'screens/dashboard_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/order_details_screen.dart';
import 'screens/order_confirmation_screen.dart';
import 'screens/prescriptions_screen.dart';
import 'screens/upload_rx_screen.dart';
import 'screens/rx_details_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/saved_addresses_screen.dart';
import 'screens/checkout_screen.dart';
import 'models/prescription.dart';
import 'data/orders_data.dart';

// ── Named route constants ─────────────────────────────────────────────
class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const dashboard = '/dashboard';
  static const orders = '/orders';
  static const orderDetails = '/orders/details';
  static const orderConfirm = '/orders/confirm';
  static const checkout = '/checkout';
  static const prescriptions = '/prescriptions';
  static const uploadRx = '/prescriptions/upload';
  static const rxDetails = '/prescriptions/details';
  static const settings = '/settings';
  static const savedAddresses = '/settings/addresses';
}

// ── Route generator ───────────────────────────────────────────────────
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    // ── Splash / entry ─────────────────────────────────────────────
    case AppRoutes.splash:
      return _fadeRoute(const _SplashScreen());

    // ── Dashboard ──────────────────────────────────────────────────
    case AppRoutes.dashboard:
      return _fadeRoute(const DashboardScreen());

    // ── Orders ─────────────────────────────────────────────────────
    case AppRoutes.orders:
      return _fadeRoute(const OrdersScreen());

    case AppRoutes.orderDetails:
      final orderId = settings.arguments as String? ?? '';
      return _slideRoute(OrderDetailsScreen(
          order: mockOrders.firstWhere((o) => o.orderNumber == orderId)));

    case AppRoutes.orderConfirm:
      final args = settings.arguments as Map<String, dynamic>? ?? {};
      return _slideRoute(OrderConfirmationScreen(
        orderNumber: args['orderNumber'] as String? ?? 'UNK-000',
        itemsTotal: args['itemsTotal'] as double? ?? 0.0,
        deliveryFee: args['deliveryFee'] as double? ?? 0.0,
        deliveryAddress: args['deliveryAddress'] as String? ?? '',
        paymentPhone: args['paymentPhone'] as String? ?? '',
        isDelivery: args['isDelivery'] as bool? ?? true,
      ));

    // ── Checkout ───────────────────────────────────────────────────
    case AppRoutes.checkout:
      return _slideRoute(const CheckoutScreen(initialItems: []));

    // ── Prescriptions ──────────────────────────────────────────────
    case AppRoutes.prescriptions:
      return _fadeRoute(const PrescriptionsScreen());

    case AppRoutes.uploadRx:
      return _slideRoute(const UploadRxScreen());

    case AppRoutes.rxDetails:
      final rx = settings.arguments as Prescription?;
      if (rx == null) return _fadeRoute(const PrescriptionsScreen());
      return _slideRoute(RxDetailsScreen(rx: rx));

    // ── Settings ───────────────────────────────────────────────────
    case AppRoutes.settings:
      return _fadeRoute(const SettingsScreen());

    case AppRoutes.savedAddresses:
      return _slideRoute(const SavedAddressesScreen());

    // ── 404 fallback ───────────────────────────────────────────────
    default:
      return _fadeRoute(_NotFoundScreen(route: settings.name ?? ''));
  }
}

// ── Transition helpers ────────────────────────────────────────────────

/// Fade transition — used for top-level tab switches
PageRouteBuilder<T> _fadeRoute<T>(Widget page) => PageRouteBuilder<T>(
      settings: RouteSettings(name: page.runtimeType.toString()),
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        child: child,
      ),
    );

/// Slide-up transition — used for detail / sub-screens
PageRouteBuilder<T> _slideRoute<T>(Widget page) => PageRouteBuilder<T>(
      settings: RouteSettings(name: page.runtimeType.toString()),
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) => SlideTransition(
        position: Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
        child: child,
      ),
    );

// ── Splash screen ─────────────────────────────────────────────────────
class _SplashScreen extends StatefulWidget {
  const _SplashScreen();

  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _scale = Tween<double>(begin: .7, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _fade = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: const Interval(.0, .6)));
    _ctrl.forward();

    // Navigate to dashboard after splash
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17A772),
      body: Center(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App icon
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.18),
                          blurRadius: 32,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.health_and_safety_rounded,
                      size: 48,
                      color: Color(0xFF17A772),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Afya Hub',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Your health, our priority.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(.75),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Scanning indicator
                  _ScanningIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScanningIndicator extends StatefulWidget {
  @override
  State<_ScanningIndicator> createState() => _ScanningIndicatorState();
}

class _ScanningIndicatorState extends State<_ScanningIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => SizedBox(
            width: 160,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _ctrl.value,
                minHeight: 3,
                backgroundColor: Colors.white.withOpacity(.2),
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Finding pharmacies near you…',
          style: TextStyle(
            color: Colors.white.withOpacity(.65),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// ── 404 fallback ──────────────────────────────────────────────────────
class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen({required this.route});
  final String route;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map_outlined, size: 48, color: Color(0xFF8C97A8)),
            const SizedBox(height: 16),
            const Text('Page not found',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text('No route defined for "$route"',
                style:
                    const TextStyle(fontSize: 11.5, color: Color(0xFF8C97A8))),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.dashboard, (_) => false),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF17A772),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
