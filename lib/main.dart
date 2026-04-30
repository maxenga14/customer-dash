import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'router.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
      title: 'Afya Hub',
      theme: AppTheme.theme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: generateRoute,
      navigatorKey: AppNav.key,
    );
  }
}

/// Global navigator — push named routes from anywhere without a BuildContext.
/// Renamed to [AppNav] to avoid collision with Flutter internals.
class AppNav {
  AppNav._();

  static final key = GlobalKey<NavigatorState>();

  static NavigatorState get _n => key.currentState!;

  static Future<T?> to<T>(String route, {Object? args}) =>
      _n.pushNamed<T>(route, arguments: args);

  static Future<T?> replace<T>(String route, {Object? args}) =>
      _n.pushReplacementNamed<T, dynamic>(route, arguments: args);

  static void back<T>([T? result]) => _n.pop<T>(result);

  static void home() =>
      _n.pushNamedAndRemoveUntil(AppRoutes.dashboard, (_) => false);
}
