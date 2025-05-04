import 'package:flutter/material.dart';
import 'package:pet_manager/pages/feed_configuration_page.dart';
import 'package:pet_manager/pages/home_page.dart';
import 'package:pet_manager/pages/login_page.dart';
import 'package:pet_manager/pages/pets/add_pet_page.dart';
import 'package:pet_manager/pages/pets/pet_page.dart';
import 'package:pet_manager/pages/register_page.dart';
import 'package:pet_manager/pages/vaccines/add_vaccine_page.dart';
import 'package:pet_manager/styles/app_colors.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/pet': (context) => const PetPage(),
        '/newPet': (context) => const AddPetPage(),
        '/newVaccine': (context) => const AddVaccinePage(),
        '/feedConfiguration': (context) => const FeedConfigurationPage(),
        // '/editPet': (context) => const EditPetPage(), //
        // '/updateVaccine': (context) => const EditVaccinePage(), //
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
