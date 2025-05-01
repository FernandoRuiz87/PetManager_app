import 'package:flutter/material.dart';
import 'package:pet_manager_app/colors/app_colors.dart';
import 'package:pet_manager_app/widgets/common_widgets.dart';
import 'package:pet_manager_app/widgets/custom_text_fields.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 70),
                const Header(logoSize: 140),
                const SizedBox(height: 30),
                const CustomTextField(
                  fieldLabel: 'Correo electrónico',
                  defaultText: 'Ingresa tu correo electrónico',
                ),
                const SizedBox(height: 20),
                const PasswordTextField(
                  fieldLabel: 'Contraseña',
                  hintText: 'Ingresa tu contraseña',
                ),
                const _ForgetPasswordButton(),
                const SizedBox(height: 20),
                // Boton de iniciar sesion
                const CustomButton(
                  text: 'Iniciar sesión',
                  buttonColor: AppColors.primary,
                  foregroundColor: AppColors.textSecondary,
                  route: '',
                ),
                const SizedBox(height: 26),
                const SectionDivider(),
                const SizedBox(height: 26),
                const CustomButton(
                  text: 'Crear cuenta',
                  buttonColor: AppColors.secondary,
                  foregroundColor: AppColors.textPrimary,
                  route: 'register_page',
                ),
              ],
            ),
          ),
        ),
      ),
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
        onPressed: () {},
        child: const Text(
          '¿Olvidaste tu contraseña?',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.primary,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
