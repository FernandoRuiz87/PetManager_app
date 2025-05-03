import 'package:flutter/material.dart';
import 'package:pet_manager_app/colors/app_colors.dart';
import 'package:pet_manager_app/widgets/custom_buttons.dart';

// Card para vacunas
class VaccineCard extends StatelessWidget {
  const VaccineCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.cardBackground,
      shape: _cardShape(),
      child: Stack(children: [const _StatusIndicator(), const _CardContent()]),
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
      children: const [_VaccineInfo(), SizedBox(width: 10), _ActionButtons()],
    );
  }
}

class _VaccineInfo extends StatelessWidget {
  const _VaccineInfo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 15, 15, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _InfoText('Rabia', isTitle: true),
          SizedBox(height: 5),
          _InfoText('Aplicada: 01/01/2023', color: AppColors.textTertiary),
          SizedBox(height: 5),
          _InfoText('Vence: 01/01/2024', color: AppColors.good),
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
    return Row(
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

class _StatusIndicator extends StatelessWidget {
  const _StatusIndicator();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: Container(
        width: 20,
        decoration: BoxDecoration(
          color: AppColors.good,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
      ),
    );
  }
}
