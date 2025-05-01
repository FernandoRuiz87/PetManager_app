import 'package:flutter/material.dart';
import 'package:pet_manager_app/colors/app_colors.dart';
import 'package:pet_manager_app/pages/register_page.dart';

// Header para el login y la pagina de registro
class Header extends StatelessWidget {
  const Header({super.key, required this.logoSize, this.subtitle});
  final double logoSize;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Hero(
            tag: 'logo_hero',
            child: Image.asset(
              "assets/images/logo.png",
              width: logoSize,
              height: logoSize,
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Center(
          child: Hero(
            tag: 'app_name_hero',
            child: Material(
              color: Colors.transparent,
              child: Text(
                'PetManager',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Hero(
          tag: 'subtitle_hero',
          child: Material(
            color: Colors.transparent,
            child: const Text(
              'Tu asistente para el cuidado de mascotas',
              style: TextStyle(fontSize: 18, color: AppColors.textTertiary),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonColor,
    required this.text,
    required this.foregroundColor,
    required this.route,
  });

  final Color buttonColor;
  final String text;
  final Color foregroundColor;
  final String route;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        if (route == 'back') {
          Navigator.pop(context); // Regresa a la pantalla anterior
        } else if (route == 'register_page') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterPage()),
          );
        }
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: const TextStyle(fontSize: 18),
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        side: BorderSide(color: buttonColor),
      ),
      child: Text(text, style: TextStyle(fontSize: 16, color: foregroundColor)),
    );
  }
}

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: AppColors.textTertiary, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'O bien',
            style: TextStyle(color: AppColors.textTertiary),
          ),
        ),
        Expanded(child: Divider(color: AppColors.textTertiary, thickness: 1)),
      ],
    );
  }
}
