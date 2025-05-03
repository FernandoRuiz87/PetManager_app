import 'package:flutter/material.dart';
import 'package:pet_manager_app/colors/app_colors.dart';
import 'package:pet_manager_app/models/feeding.dart';

class FeedCard extends StatelessWidget {
  final Feeding feeding;

  const FeedCard({super.key, required this.feeding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        elevation: 0,
        color: AppColors.cardBackground,
        shape: _cardShape(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FeedInfo(feeding: feeding),
              const SizedBox(height: 15),
              _ProgressBar(progressValue: feeding.progressValue),
              const SizedBox(height: 10),
              _RemainingDays(remainingDays: feeding.remainingDays),
              if (feeding.notes != null && feeding.notes!.isNotEmpty) ...[
                const SizedBox(height: 10),
                _NotesSection(notes: feeding.notes!),
              ],
            ],
          ),
        ),
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

class _FeedInfo extends StatelessWidget {
  final Feeding feeding;

  const _FeedInfo({required this.feeding});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoText(
          'Consumo: ${feeding.dailyConsumptionGrams.toStringAsFixed(0)}g/día',
          isTitle: true,
        ),
        const SizedBox(height: 5),
        _InfoText(
          'Bolsa actual: ${feeding.totalFoodKg}kg (Comprada el ${feeding.formattedPurchaseDate})',
          color: AppColors.textTertiary,
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progressValue;

  const _ProgressBar({required this.progressValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          borderRadius: BorderRadius.circular(50),
          value: progressValue,
          backgroundColor: const Color(0xFFE9ECEF),
          valueColor: AlwaysStoppedAnimation<Color>(
            _getProgressColor(progressValue),
          ),
          minHeight: 10,
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0%',
              style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
            ),
            Text(
              '${(progressValue * 100).toStringAsFixed(0)}% restante',
              style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
            ),
          ],
        ),
      ],
    );
  }

  Color _getProgressColor(double value) {
    if (value > 0.5) return AppColors.good;
    if (value > 0.2) return AppColors.warning;
    return AppColors.alert;
  }
}

class _RemainingDays extends StatelessWidget {
  final int remainingDays;

  const _RemainingDays({required this.remainingDays});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          remainingDays > 7 ? Icons.check_circle : Icons.warning,
          color: remainingDays > 7 ? AppColors.good : AppColors.warning,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          remainingDays > 0
              ? 'Te queda para $remainingDays ${remainingDays == 1 ? 'día' : 'días'}'
              : '¡Necesitas comprar más alimento!',
          style: TextStyle(
            fontSize: 16,
            color: remainingDays > 7 ? AppColors.textPrimary : AppColors.alert,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _NotesSection extends StatelessWidget {
  final String notes;

  const _NotesSection({required this.notes});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 8),
        Text(
          'Notas:',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(notes, style: const TextStyle(fontSize: 14)),
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
        fontSize: isTitle ? 18 : 14,
        fontWeight: isTitle ? FontWeight.w600 : FontWeight.normal,
        color: color ?? AppColors.textPrimary,
      ),
    );
  }
}
