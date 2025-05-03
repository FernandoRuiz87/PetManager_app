import 'package:pet_manager_app/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:io';

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
          child: Image.asset(
            "assets/images/logo.png",
            width: logoSize,
            height: logoSize,
          ),
        ),
        const SizedBox(height: 5),
        const Center(
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
        const SizedBox(height: 8),
        Material(
          color: Colors.transparent,
          child: const Text(
            'Tu asistente para el cuidado de mascotas',
            style: TextStyle(fontSize: 18, color: AppColors.textTertiary),
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

class PetPicture extends StatelessWidget {
  const PetPicture({super.key, required this.size, this.imagePath});

  final double size;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundColor: AppColors.background,
      child: ClipOval(
        child: SizedBox(
          width: size * 2,
          height: size * 2,
          child:
              imagePath != null
                  ? Image.file(
                    File(imagePath!),
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(color: AppColors.secondary),
                  )
                  : Image.asset(
                    "assets/images/default_pet.png",
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(color: AppColors.secondary),
                  ),
        ),
      ),
    );
  }
}

class NavBar extends StatelessWidget {
  final int currentIndex;

  const NavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Calendario',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Configuración',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: AppColors.primary,
      onTap: (index) {},
    );
  }
}
