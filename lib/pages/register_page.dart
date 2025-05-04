import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pet_manager/styles/app_colors.dart';
import 'package:pet_manager/widgets/buttons.dart';
import 'package:pet_manager/widgets/common_widgets.dart';
import 'package:pet_manager/widgets/text_fields.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _acceptedTerms = false;

  void _submitForm() {
    final formIsValid = _formKey.currentState!.validate();

    if (!formIsValid) {
      // Mostrar mensaje genérico de error de campos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Por favor completa todos los campos correctamente.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.alert,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Debes aceptar los términos y condiciones para continuar.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.alert,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    // Todo está validado, proceder
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.only(
          top: padding.top,
          left: padding.left,
          right: padding.right,
          bottom: padding.bottom,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                const Header(logoSize: 100),
                const SizedBox(height: 30),
                _NameField(controller: _nameController),
                const SizedBox(height: 20),
                _EmailField(controller: _emailController),
                const SizedBox(height: 20),
                _PasswordField(controller: _passwordController),
                const SizedBox(height: 20),
                _ConfirmPasswordField(
                  controller: _confirmPasswordController,
                  passwordController: _passwordController,
                ),
                const SizedBox(height: 10),
                _TermsCheckbox(
                  value: _acceptedTerms,
                  onChanged: (bool value) {
                    setState(() => _acceptedTerms = value);
                  },
                ),
                const SizedBox(height: 20),
                _RegisterButton(onPressed: _submitForm),
                const SizedBox(height: 20),
                const SectionDivider(),
                const SizedBox(height: 20),
                const _LoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      fieldLabel: 'Nombre completo',
      defaultText: 'Ingrese su nombre',
      controller: controller,
      isNumberField: false,
      isRequired: true,
      validator:
          (value) =>
              value == null || value.trim().isEmpty
                  ? 'Campo obligatorio'
                  : null,
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      fieldLabel: 'Correo electrónico',
      defaultText: 'correo@example.com',
      isNumberField: false,
      controller: controller,
      isRequired: true,
      validator:
          (value) =>
              value == null || value.trim().isEmpty ? 'Correo requerido' : null,
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return PasswordTextField(
      fieldLabel: 'Contraseña',
      hintText: 'Ingresa una contraseña',
      controller: controller,
      isRequired: true,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo requerido';
        if (value.length < 6) return 'Debe tener al menos 6 caracteres';
        return null;
      },
    );
  }
}

class _ConfirmPasswordField extends StatelessWidget {
  const _ConfirmPasswordField({
    required this.controller,
    required this.passwordController,
  });

  final TextEditingController controller;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return PasswordTextField(
      fieldLabel: 'Confirmar contraseña',
      hintText: 'Vuelve a ingresar tu contraseña',
      controller: controller,
      isRequired: true,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo requerido';
        if (value != passwordController.text) {
          return 'Las contraseñas no coinciden';
        }
        return null;
      },
    );
  }
}

class _TermsCheckbox extends StatelessWidget {
  const _TermsCheckbox({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          activeColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          side: BorderSide(color: AppColors.textFieldBorderColor, width: 1.5),
          onChanged: (val) => onChanged(val ?? false),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: "He leído y acepto los ",
              style: const TextStyle(fontSize: 15, color: Colors.black),
              children: [
                TextSpan(
                  text: "términos y condiciones",
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          // Mostrar T&C
                        },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Crear cuenta',
      buttonColor: AppColors.primary,
      foregroundColor: AppColors.textSecondary,
      height: 50,
      onPressed: onPressed,
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Iniciar sesión',
      buttonColor: AppColors.secondary,
      foregroundColor: AppColors.textPrimary,
      height: 50,
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      },
    );
  }
}
