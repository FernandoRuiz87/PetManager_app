import 'package:flutter/material.dart';
import 'package:pet_manager_app/colors/app_colors.dart';
import 'package:intl/intl.dart';

// Card para la información del alimento
class FeedCard extends StatelessWidget {
  const FeedCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo -
    const double totalFoodKg = 5.0;
    const double dailyConsumptionGrams = 200.0;
    final DateTime purchaseDate = DateTime.parse(
      '2025-05-03',
    ); // Usa el formato AAAA-MM-DD
    final String formattedPurchaseDate = DateFormat(
      'dd/MM',
    ).format(purchaseDate);
    final double totalFoodGrams = totalFoodKg * 1000;

    // Calcula cuántos días han pasado desde la compra
    final int daysSincePurchase =
        DateTime.now().difference(purchaseDate).inDays;

    // Calcula la cantidad de alimento consumido hasta ahora
    final double consumedFoodGrams = daysSincePurchase * dailyConsumptionGrams;

    // Calcula la cantidad restante de alimento
    final double remainingFoodGrams = totalFoodGrams - consumedFoodGrams;

    // Calcula el porcentaje restante (asegurándose de que no sea negativo)
    final double progressValue =
        (remainingFoodGrams > 0 && totalFoodGrams > 0)
            ? (remainingFoodGrams / totalFoodGrams).clamp(0.0, 1.0)
            : 0.0;

    // Calcula los días restantes de comida
    final int remainingDays =
        remainingFoodGrams > 0
            ? (remainingFoodGrams / dailyConsumptionGrams).ceil()
            : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        elevation: 0,
        color: AppColors.cardBackground,
        shape: _cardShape(),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FeedInfo(
                    dailyConsumptionGrams: dailyConsumptionGrams,
                    totalFoodKg: totalFoodKg,
                    formattedPurchaseDate: formattedPurchaseDate,
                    remainingDays: remainingDays,
                    progressValue: progressValue,
                  ),
                ],
              ),
            ),
          ],
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

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progressValue});

  final double progressValue;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      borderRadius: BorderRadius.circular(50),
      value: progressValue,
      backgroundColor: Color(0xFFE9ECEF),
      valueColor: AlwaysStoppedAnimation<Color>(
        progressValue > 0.5
            ? AppColors.good
            : progressValue > 0.2
            ? AppColors.warning
            : Colors.redAccent, // Cambia el color según el progreso
      ),
      minHeight: 10,
    );
  }
}

class _FeedInfo extends StatelessWidget {
  final double dailyConsumptionGrams;
  final double totalFoodKg;
  final String formattedPurchaseDate;
  final int remainingDays;
  final double progressValue;

  const _FeedInfo({
    required this.dailyConsumptionGrams,
    required this.totalFoodKg,
    required this.formattedPurchaseDate,
    required this.remainingDays,
    required this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoText(
          'Consumo: ${dailyConsumptionGrams.toStringAsFixed(0)}g/día',
          isTitle: true,
        ),
        const SizedBox(height: 5),
        _InfoText(
          'Bolsa actual: ${totalFoodKg}kg (Comprada el $formattedPurchaseDate)',
          color: AppColors.textTertiary,
        ),
        const SizedBox(height: 15),
        _ProgressBar(progressValue: progressValue),
        const SizedBox(height: 10),
        _InfoText('Te queda para $remainingDays días'),
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
        fontSize: isTitle ? 18 : 16,
        fontWeight: isTitle ? FontWeight.w600 : FontWeight.normal,
        color: color,
      ),
    );
  }
}
