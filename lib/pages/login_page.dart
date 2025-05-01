import 'package:flutter/material.dart';
import 'package:pet_manager_app/colors/app_colors.dart';

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
                const _Header(),
                const SizedBox(height: 30),
                const _EmailField(),
                const SizedBox(height: 20),
                const _PasswordField(),
                const _ForgetPasswordButton(),
                const SizedBox(height: 20),
                // Boton de iniciar sesion
                const _CustomButton(
                  text: 'Iniciar sesión',
                  buttonColor: AppColors.primary,
                  foregroundColor: AppColors.textSecondary,
                  route: '',
                ),
                const SizedBox(height: 26),
                const _SectionDivider(),
                const SizedBox(height: 26),
                const _CustomButton(
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

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: AppColors.textTertiary, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'O bien',
            style: TextStyle(color: AppColors.textTertiary),
          ),
        ),
        Expanded(child: Divider(color: AppColors.textTertiary, thickness: 1)),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Image.asset("assets/images/logo.png", width: 140, height: 140),
        ),
        const SizedBox(height: 30),
        const Center(
          child: Text(
            'PetManager',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 0),
        const Center(
          child: Text(
            'Tu asistente para el cuidado de mascotas',
            style: TextStyle(fontSize: 16, color: AppColors.textTertiary),
          ),
        ),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Correo electrónico', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 5),
        const TextField(
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: 'Ingresa tu correo electrónico',
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

class _PasswordField extends StatefulWidget {
  const _PasswordField();

  @override
  State<_PasswordField> createState() => __PasswordFieldState();
}

class __PasswordFieldState extends State<_PasswordField> {
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
        const Text('Contraseña', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        TextField(
          obscureText: _showPassword,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.textSecondary,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textFieldBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            hintText: 'Ingresa tu contraseña',
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

class _CustomButton extends StatelessWidget {
  const _CustomButton({
    required this.buttonColor,
    required this.text,
    required this.foregroundColor,
    required this.route,
  });

  final Color buttonColor;
  final String text;
  final Color foregroundColor;
  final String route;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        if (route == '') {
        } else {
          Navigator.pushNamed(context, route);
        }
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: const TextStyle(fontSize: 18),
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        side: BorderSide(color: buttonColor),
      ),
      child: Text(text, style: TextStyle(fontSize: 16, color: foregroundColor)),
    );
  }
}
