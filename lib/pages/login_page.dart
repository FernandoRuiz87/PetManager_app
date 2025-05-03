import 'package:flutter/material.dart';
import 'package:pet_manager_app/colors/app_colors.dart';
import 'package:pet_manager_app/widgets/custom_text_fields.dart';
import 'package:pet_manager_app/widgets/custom_buttons.dart';
import 'package:pet_manager_app/widgets/common_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
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
    }
  }

  // Ajuste de pantalla
  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de la pantalla
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
                const SizedBox(height: 70),
                const Header(logoSize: 140),
                const SizedBox(height: 30),
                _EmailField(controller: _emailController),
                const SizedBox(height: 20),
                _PasswordField(controller: _passwordController),
                const _ForgetPasswordButton(),
                const SizedBox(height: 20),
                _LoginButton(onPressed: _submitForm),
                const SizedBox(height: 26),
                const SectionDivider(),
                const SizedBox(height: 26),
                const _RegisterButton(),
              ],
            ),
          ),
        ),
      ),
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
      defaultText: 'Ingresa tu correo electrónico',
      controller: controller,
      isNumberField: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Este campo es obligatorio';
        }
        return null;
      },
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
      hintText: 'Ingresa tu contraseña',
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo es obligatorio';
        } else if (value.length < 6) {
          return 'Debe tener al menos 6 caracteres';
        }
        return null;
      },
    );
  }
}

class _ForgetPasswordButton extends StatelessWidget {
  const _ForgetPasswordButton();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // Implementa recuperación de contraseña
        },
        child: const Text(
          '¿Olvidaste tu contraseña?',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.primary,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.primary,
            decorationThickness: 0.5,
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Iniciar sesión',
      buttonColor: AppColors.primary,
      foregroundColor: AppColors.textSecondary,
      height: 50,
      onPressed: onPressed,
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton();

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Crear cuenta',
      buttonColor: AppColors.secondary,
      foregroundColor: AppColors.textPrimary,
      height: 50,
      onPressed: () {
        Navigator.pushNamed(context, '/register');
      },
    );
  }
}
