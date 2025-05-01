import 'package:flutter/material.dart';
import 'package:pet_manager_app/colors/app_colors.dart';

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

//Divisor para botones
class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Divider(color: AppColors.textFieldBorderColor, thickness: 1.5),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'O bien',
            style: TextStyle(color: AppColors.textTertiary),
          ),
        ),
        Expanded(
          child: Divider(color: AppColors.textFieldBorderColor, thickness: 1.5),
        ),
      ],
    );
  }
}
