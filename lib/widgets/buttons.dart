import 'package:flutter/material.dart';
import 'package:pet_manager/styles/app_colors.dart';

/// Botón personalizable de alto específico y con bordes redondeados.
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.buttonColor,
    required this.foregroundColor,
    required this.onPressed,
    required this.height,
  });

  final String text;
  final Color buttonColor;
  final Color foregroundColor;
  final VoidCallback onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: foregroundColor,
          textStyle: const TextStyle(fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          side: BorderSide(color: buttonColor),
        ),
        child: Text(text),
      ),
    );
  }
}

/// Botón tipo "Añadir" con ícono de suma y estilo personalizado.
class GenericButton extends StatelessWidget {
  const GenericButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.text,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          side: const BorderSide(color: AppColors.primary),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.secondary, size: 20),
            SizedBox(width: 15),
            Text(
              text,
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Botón de texto con subrayado y estilo personalizable.
class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.textColor,
    required this.fontSize,
  });

  final String text;
  final VoidCallback onPressed;
  final Color textColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor,
        textStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
          decorationColor: textColor,
        ),
      ),
      child: Text(text),
    );
  }
}
