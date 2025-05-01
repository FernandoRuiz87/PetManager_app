import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pet_manager_app/colors/app_colors.dart';
import 'package:pet_manager_app/widgets/common_widgets.dart';
import 'package:pet_manager_app/widgets/custom_buttons.dart';
import 'package:pet_manager_app/widgets/custom_text_fields.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Alineación a la izquierda
            children: [
              const SizedBox(height: 40),
              const Header(logoSize: 100),
              const SizedBox(height: 30),
              const CustomTextField(
                fieldLabel: 'Nombre completo',
                defaultText: 'Ingrese su nombre',
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                fieldLabel: 'Correo electrónico',
                defaultText: 'correo@example.com',
              ),
              const SizedBox(height: 20),
              const PasswordTextField(
                fieldLabel: 'Contraseña',
                hintText: 'Ingresa una contraseña',
              ),
              const SizedBox(height: 20),
              const PasswordTextField(
                fieldLabel: 'Confirmar contraseña',
                hintText: 'Vuelve a ingresar tu contraseña',
              ),
              const SizedBox(height: 10),
              const _UserAgreementCheckbox(),
              const SizedBox(height: 20),
              CustomButton(
                buttonColor: AppColors.primary,
                text: 'Crear cuenta',
                foregroundColor: AppColors.textSecondary,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false, // Elimina todas las rutas anteriores
                  );
                },
              ),
              const SizedBox(height: 26),
              const SectionDivider(),
              const SizedBox(height: 26),
              CustomButton(
                text: 'Iniciar sesión',
                buttonColor: AppColors.secondary,
                foregroundColor: AppColors.textPrimary,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false, // Elimina todas las rutas anteriores
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserAgreementCheckbox extends StatefulWidget {
  const _UserAgreementCheckbox();

  @override
  State<_UserAgreementCheckbox> createState() => _UserAgreementCheckboxState();
}

class _UserAgreementCheckboxState extends State<_UserAgreementCheckbox> {
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 1.2,
          child: Checkbox(
            value: _isChecked,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            side: BorderSide(color: AppColors.textFieldBorderColor, width: 1.5),
            onChanged: (bool? value) {
              setState(() {
                _isChecked = value ?? false;
              });
            },
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: "He leído y acepto los ",
              style: TextStyle(fontSize: 15, color: Colors.black),
              children: [
                TextSpan(
                  text: "términos y condiciones",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          // Manejar el boton
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
