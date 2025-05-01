import 'package:flutter/material.dart';
import 'package:pet_manager_app/colors/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.fieldLabel,
    required this.defaultText,
  });
  final String fieldLabel;
  final String defaultText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(fieldLabel, style: TextStyle(fontSize: 18)),
        const SizedBox(height: 5),
        TextField(
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: defaultText,
            filled: true,
            fillColor: AppColors.textSecondary,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textFieldBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.fieldLabel,
    required this.hintText,
  });

  final String fieldLabel;
  final String hintText;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _showPassword = true;

  void _changeVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.fieldLabel, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 5),
        TextField(
          obscureText: _showPassword,
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.textSecondary,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textFieldBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            hintText: widget.hintText,
            suffixIcon: IconButton(
              onPressed: _changeVisibility,
              icon: Icon(
                _showPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
