import 'package:flutter/material.dart';

import 'package:pet_manager/styles/app_colors.dart';

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

// Widget para mostrar la foto de la mascota
class PetPicture extends StatelessWidget {
  const PetPicture({super.key, required this.size, this.imagePath});

  final double size;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: imagePath ?? 'default',
      child: CircleAvatar(
        radius: size,
        backgroundColor: AppColors.background,
        child: ClipOval(
          child: SizedBox(
            width: size * 2,
            height: size * 2,
            child:
                imagePath != null && imagePath!.isNotEmpty
                    ? Image.network(
                      imagePath!,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => Container(color: AppColors.secondary),
                    )
                    : Image.asset(
                      "assets/images/logo.png", // Cambiar por una imagen por defecto
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => Container(color: AppColors.secondary),
                    ),
          ),
        ),
      ),
    );
  }
}

// Modal de confirmacion
class ConfirmationModal extends StatelessWidget {
  const ConfirmationModal({
    super.key,
    required this.title,
    required this.content,
    required this.confirmationMessage,
    required this.confirmationColor,
    required this.onConfirm,
  });

  final String title;
  final String content;
  final String confirmationMessage;
  final Color confirmationColor;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 25),
      ),
      content: Text(
        content,
        style: const TextStyle(fontSize: 16, color: AppColors.textTertiary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: AppColors.primary, fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          child: Text(
            confirmationMessage,
            style: TextStyle(color: confirmationColor, fontSize: 16),
          ),
        ),
      ],
    );
  }
}

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmationMessage;
  final Color confirmationColor;
  final VoidCallback onConfirm;
  final String successMessage;
  final Color successColor;

  const ConfirmationDialog({
    key,
    required this.title,
    required this.content,
    required this.confirmationMessage,
    required this.confirmationColor,
    required this.onConfirm,
    this.successMessage = 'Operación completada correctamente.',
    this.successColor = AppColors.good,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cierra el modal
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            onConfirm(); // Ejecuta la acción
            Navigator.of(context).pop(); // Cierra el modal
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  successMessage,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: successColor,
                behavior: SnackBarBehavior.floating,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 3),
              ),
            );
          },
          child: Text(
            confirmationMessage,
            style: TextStyle(color: confirmationColor),
          ),
        ),
      ],
    );
  }
}
