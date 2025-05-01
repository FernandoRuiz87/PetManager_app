import 'package:flutter/material.dart';
import 'package:pet_manager_app/colors/app_colors.dart';
import 'package:pet_manager_app/pages/login_page.dart';
import 'package:pet_manager_app/pages/register_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'login_page',
      routes: {
        'login_page': (context) => const LoginPage(),
        'register_page': (context) => const RegisterPage(),
      },
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Inter'),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
