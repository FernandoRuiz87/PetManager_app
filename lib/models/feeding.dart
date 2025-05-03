import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

/// Modelo para gestionar la configuración de alimentación de una mascota
class Feeding {
  final String id;
  final String petId; // ID de la mascota asociada
  final double totalFoodKg; // Peso total del alimento en kg
  final double dailyConsumptionGrams; // Consumo diario en gramos
  final DateTime purchaseDate; // Fecha de compra del alimento
  final String? notes; // Notas adicionales

  Feeding({
    String? id,
    required this.petId,
    required this.totalFoodKg,
    required this.dailyConsumptionGrams,
    required this.purchaseDate,
    this.notes,
  }) : id = id ?? const Uuid().v4();

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
      petId: json['petId'],
      totalFoodKg: json['totalFoodKg'].toDouble(),
      dailyConsumptionGrams: json['dailyConsumptionGrams'].toDouble(),
      purchaseDate: DateTime.parse(json['purchaseDate']),
      notes: json['notes'],
    );
  }

  /// Convierte el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'totalFoodKg': totalFoodKg,
      'dailyConsumptionGrams': dailyConsumptionGrams,
      'purchaseDate': purchaseDate.toIso8601String(),
      'notes': notes,
    };
  }

  /// Para debug
  @override
  String toString() {
    return 'Feeding(id: $id, petId: $petId, totalFoodKg: $totalFoodKg, '
        'dailyConsumptionGrams: $dailyConsumptionGrams, '
        'purchaseDate: $purchaseDate, notes: $notes)';
  }

  // --- UTILIDADES ---

  /// Copia el objeto con nuevos valores
  Feeding copyWith({
    String? id,
    String? petId,
    double? totalFoodKg,
    double? dailyConsumptionGrams,
    DateTime? purchaseDate,
    String? notes,
  }) {
    return Feeding(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      totalFoodKg: totalFoodKg ?? this.totalFoodKg,
      dailyConsumptionGrams:
          dailyConsumptionGrams ?? this.dailyConsumptionGrams,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      notes: notes ?? this.notes,
    );
  }
}
