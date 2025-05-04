import 'package:flutter/material.dart';
import 'package:pet_manager/models/shower.dart';
import 'package:pet_manager/styles/app_colors.dart';
import 'package:intl/intl.dart';

class ShowerCard extends StatelessWidget {
  final Shower shower;
  final VoidCallback onDelete;

  const ShowerCard({super.key, required this.shower, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final showerDate = dateFormat.format(
      DateFormat('yyyy-MM-dd').parse(shower.date),
    );
    final daysSinceShower =
        DateTime.now()
            .difference(DateFormat('yyyy-MM-dd').parse(shower.date))
            .inDays;

    return Card(
      elevation: 0,
      color: AppColors.cardBackground,
      shape: _cardShape(),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: _CardContent(
        showerDate: showerDate,
        daysSinceShower: daysSinceShower,
        onDelete: onDelete,
      ),
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
  final String showerDate;
  final int daysSinceShower;
  final VoidCallback onDelete;

  const _CardContent({
    required this.showerDate,
    required this.daysSinceShower,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _ShowerInfo(
              showerDate: showerDate,
              daysSinceShower: daysSinceShower,
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: AppColors.alert),
            onPressed: onDelete,
            tooltip: 'Eliminar baño',
          ),
        ],
      ),
    );
  }
}

class _ShowerInfo extends StatelessWidget {
  final String showerDate;
  final int daysSinceShower;

  const _ShowerInfo({required this.showerDate, required this.daysSinceShower});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoText('Baño: $showerDate', isTitle: true),
        const SizedBox(height: 4),
        _InfoText(
          daysSinceShower == 0
              ? '(Hoy)'
              : '(Hace $daysSinceShower ${daysSinceShower == 1 ? 'día' : 'días'})',
          color: AppColors.textTertiary,
        ),
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
        fontSize: isTitle ? 16 : 14,
        fontWeight: isTitle ? FontWeight.w600 : FontWeight.normal,
        color: color ?? AppColors.textPrimary,
      ),
    );
  }
}
