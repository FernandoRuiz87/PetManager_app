import 'package:intl/intl.dart';

class Feeding {
  final String id;
  final double totalFoodKg; // Peso total del alimento en kg
  final double dailyConsumptionGrams; // Consumo diario en gramos
  final DateTime purchaseDate; // Fecha de compra del alimento

  Feeding({
    required this.id,
    required this.totalFoodKg,
    required this.dailyConsumptionGrams,
    required this.purchaseDate,
  });

  // --- MÉTODOS DE CÁLCULO ---

  /// Convierte kg a gramos
  double get totalFoodGrams => totalFoodKg * 1000;

  /// Días desde la compra
  int get daysSincePurchase => DateTime.now().difference(purchaseDate).inDays;

  /// Gramos consumidos hasta hoy
  double get consumedFoodGrams => daysSincePurchase * dailyConsumptionGrams;

  /// Gramos restantes (nunca negativo)
  double get remainingFoodGrams =>
      (totalFoodGrams - consumedFoodGrams).clamp(0, totalFoodGrams);

  /// Porcentaje restante (0.0 a 1.0)
  double get progressValue =>
      (remainingFoodGrams / totalFoodGrams).clamp(0.0, 1.0);

  /// Días restantes aproximados
  int get remainingDays =>
      remainingFoodGrams > 0
          ? (remainingFoodGrams / dailyConsumptionGrams).ceil()
          : 0;

  /// Fecha formateada (ej: "03/05")
  String get formattedPurchaseDate => DateFormat('dd/MM').format(purchaseDate);

  // --- SERIALIZACIÓN ---

  /// Crea un objeto Feeding desde JSON
  factory Feeding.fromJson(Map<String, dynamic> json) {
    return Feeding(
      id: json['id'],
      totalFoodKg: json['totalFoodKg'].toDouble(),
      dailyConsumptionGrams: json['dailyConsumptionGrams'].toDouble(),
      purchaseDate: DateTime.parse(json['purchaseDate']),
    );
  }

  /// Convierte el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'totalFoodKg': totalFoodKg,
      'dailyConsumptionGrams': dailyConsumptionGrams,
      'purchaseDate': purchaseDate.toIso8601String(),
    };
  }
}
