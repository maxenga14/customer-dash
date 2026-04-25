import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const CustomerDashApp());
}

class CustomerDashApp extends StatelessWidget {
  const CustomerDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Customer Dash',
      theme: AppTheme.theme,
      home: const DashboardScreen(),
    );
  }
}
