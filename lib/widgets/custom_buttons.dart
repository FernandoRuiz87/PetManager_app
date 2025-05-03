import 'package:flutter/material.dart';
import 'package:pet_manager_app/colors/app_colors.dart';

//Boton personalizable
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.buttonColor,
    required this.foregroundColor,
    required this.onPressed,
    required this.height,
  });

  final Color buttonColor;
  final String text;
  final Color foregroundColor;
  final VoidCallback onPressed; // Callback para la accion del boton
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 18),
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          side: BorderSide(color: buttonColor),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16, color: foregroundColor),
        ),
      ),
    );
  }
}

// Boton de agregar
class AddButton extends StatelessWidget {
  const AddButton({super.key, required this.onPressed});
  final VoidCallback onPressed; // Callback para la accion del boton

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          side: const BorderSide(color: AppColors.primary),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: AppColors.secondary, size: 20),
            SizedBox(width: 15),
            Text(
              'Añadir',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

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
