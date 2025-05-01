import 'package:flutter/material.dart';
import 'package:pet_manager_app/colors/app_colors.dart';
import 'package:pet_manager_app/pages/home_page.dart';
import 'package:pet_manager_app/pages/login_page.dart';
import 'package:pet_manager_app/pages/pet_page.dart';
import 'package:pet_manager_app/pages/register_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/pet',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/pet': (context) => const PetPage(),
      },
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          toolbarHeight: 70,
        ),
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Inter'),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
