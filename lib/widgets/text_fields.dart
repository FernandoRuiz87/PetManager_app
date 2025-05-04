import 'package:flutter/material.dart';
import 'package:pet_manager/styles/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.fieldLabel,
    required this.defaultText,
    this.controller,
    this.validator,
    required this.isNumberField,
    this.isRequired = false,
  });

  final String fieldLabel;
  final String defaultText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool isNumberField;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FieldLabel(label: fieldLabel, isRequired: isRequired),
        const SizedBox(height: 5),
        TextFormField(
          keyboardType:
              isNumberField ? TextInputType.number : TextInputType.text,
          controller: controller,
          validator: validator,
          cursorColor: AppColors.primary,
          decoration: _buildInputDecoration(defaultText),
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
    this.controller,
    this.validator,
    this.isRequired = false,
  });

  final String fieldLabel;
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool isRequired;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _showPassword = true;

  void _toggleVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FieldLabel(label: widget.fieldLabel, isRequired: widget.isRequired),
        const SizedBox(height: 5),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          obscureText: _showPassword,
          cursorColor: AppColors.primary,
          decoration: _buildInputDecoration(
            widget.hintText,
            suffixIcon: IconButton(
              onPressed: _toggleVisibility,
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

class _FieldLabel extends StatelessWidget {
  final String label;
  final bool isRequired;

  const _FieldLabel({required this.label, required this.isRequired});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 18)),
        if (isRequired)
          const Text(' *', style: TextStyle(color: Colors.red, fontSize: 18)),
      ],
    );
  }
}

InputDecoration _buildInputDecoration(String hintText, {Widget? suffixIcon}) {
  return InputDecoration(
    hintText: hintText,
    filled: true,
    fillColor: AppColors.textSecondary,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.textFieldBorderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.alert),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.alert, width: 2),
    ),
    suffixIcon: suffixIcon,
  );
}
