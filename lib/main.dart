import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Hope3App());
}

class Hope3App extends StatelessWidget {
  const Hope3App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HOPE3 Volunteer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
