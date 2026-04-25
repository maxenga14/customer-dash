import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'router.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Status bar style — transparent over the green header
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const CustomerDashApp());
}

class CustomerDashApp extends StatelessWidget {
  const CustomerDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediRun',
      theme: AppTheme.theme,

      // ── Entry point ────────────────────────────────────────────────
      initialRoute: AppRoutes.splash,

      // ── Centralised route generator ────────────────────────────────
      onGenerateRoute: generateRoute,

      // ── Global navigator key (useful for push from non-widget code) ─
      navigatorKey: AppNavigator.key,
    );
  }
}

// ── Global navigator access ───────────────────────────────────────────────
/// Use AppNavigator.push() / AppNavigator.pushNamed() from anywhere in the
/// app without needing a BuildContext.
class AppNavigator {
  AppNavigator._();
  static final key = GlobalKey<NavigatorState>();

  static NavigatorState get _nav => key.currentState!;

  static Future<T?> push<T>(Widget screen) => _nav.push(
      generateRoute(RouteSettings(name: screen.runtimeType.toString()))
          as Route<T>);

  static Future<T?> pushNamed<T>(String routeName, {Object? arguments}) =>
      _nav.pushNamed<T>(routeName, arguments: arguments);

  static void pop<T>([T? result]) => _nav.pop<T>(result);

  static void popToRoot() =>
      _nav.pushNamedAndRemoveUntil(AppRoutes.dashboard, (_) => false);
}
