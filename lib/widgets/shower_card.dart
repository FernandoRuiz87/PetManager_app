import 'package:flutter/material.dart';
import 'package:pet_manager_app/colors/app_colors.dart';
import 'package:pet_manager_app/widgets/custom_buttons.dart';

// Card para baños
class ShowerCard extends StatelessWidget {
  const ShowerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.cardBackground,
      shape: _cardShape(),
      child: Stack(children: [const _CardContent()]),
    );
  }

  RoundedRectangleBorder _cardShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: AppColors.cardStroke, width: 1.5),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [_ShowerInfo(), SizedBox(width: 10), _ActionButtons()],
    );
  }
}

class _ShowerInfo extends StatelessWidget {
  const _ShowerInfo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 25, 15, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _InfoText('Ultimo baño: 05/04/2025', isTitle: true),
          SizedBox(height: 5),
          _InfoText('(Hace 24 dias)', color: AppColors.textTertiary),
        ],
      ),
    );
  }
}

class _InfoText extends StatelessWidget {
  final String text;
  final bool isTitle;
  final Color? color;

  const _InfoText(this.text, {this.isTitle = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: isTitle ? 18 : 16,
        fontWeight: isTitle ? FontWeight.w600 : FontWeight.normal,
        color: color,
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextButton(
          text: 'Editar',
          onPressed: () {},
          textColor: AppColors.primary,
          fontSize: 16,
        ),
        CustomTextButton(
          text: 'Eliminar',
          onPressed: () {},
          textColor: AppColors.alert,
          fontSize: 16,
        ),
      ],
    );
  }
}
