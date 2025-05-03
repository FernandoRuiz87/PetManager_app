import 'package:flutter/material.dart';
import 'package:pet_manager_app/colors/app_colors.dart';
import 'package:pet_manager_app/models/vaccine.dart';
import 'package:pet_manager_app/widgets/custom_buttons.dart';
import 'package:intl/intl.dart';

class VaccineCard extends StatelessWidget {
  final Vaccine vaccine;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const VaccineCard({
    super.key,
    required this.vaccine,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.cardBackground,
      shape: _cardShape(),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        children: [
          _StatusIndicator(statusColor: _getStatusColor()),
          _CardContent(vaccine: vaccine, onEdit: onEdit, onDelete: onDelete),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final dueDate = dateFormat
        .parse(vaccine.date)
        .add(Duration(days: 30 * int.parse(vaccine.duration)));

    return dueDate.isBefore(now)
        ? AppColors
            .alert // Vencida
        : dueDate.difference(now).inDays < 30
        ? AppColors
            .warning // Por vencer
        : AppColors.good; // Vigente
  }

  RoundedRectangleBorder _cardShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: AppColors.cardStroke, width: 1.5),
    );
  }
}

class _CardContent extends StatelessWidget {
  final Vaccine vaccine;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CardContent({
    required this.vaccine,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final applicationDate = dateFormat.format(
      DateFormat('yyyy-MM-dd').parse(vaccine.date),
    );
    final dueDate = dateFormat.format(
      DateFormat('yyyy-MM-dd')
          .parse(vaccine.date)
          .add(Duration(days: 30 * int.parse(vaccine.duration))),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 15, 15, 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _VaccineInfo(
              name: vaccine.name,
              applicationDate: applicationDate,
              dueDate: dueDate,
            ),
          ),
          const SizedBox(width: 10),
          _ActionButtons(onEdit: onEdit, onDelete: onDelete),
        ],
      ),
    );
  }
}

class _VaccineInfo extends StatelessWidget {
  final String name;
  final String applicationDate;
  final String dueDate;

  const _VaccineInfo({
    required this.name,
    required this.applicationDate,
    required this.dueDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoText(name, isTitle: true),
        const SizedBox(height: 8),
        _InfoText('Aplicada: $applicationDate', color: AppColors.textTertiary),
        const SizedBox(height: 4),
        _InfoText('Vence: $dueDate', color: AppColors.good),
      ],
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
        fontSize: isTitle ? 20 : 16,
        fontWeight: isTitle ? FontWeight.w600 : FontWeight.normal,
        color: color ?? AppColors.textPrimary,
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ActionButtons({required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextButton(
          text: 'Editar',
          onPressed: onEdit,
          textColor: AppColors.primary,
          fontSize: 14,
        ),
        const SizedBox(height: 8),
        CustomTextButton(
          text: 'Eliminar',
          onPressed: onDelete,
          textColor: AppColors.alert,
          fontSize: 14,
        ),
      ],
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final Color statusColor;

  const _StatusIndicator({required this.statusColor});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: Container(
        width: 12,
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
      ),
    );
  }
}
