import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_manager/styles/app_colors.dart';
import 'package:pet_manager/widgets/buttons.dart';
import 'package:pet_manager/widgets/text_fields.dart';

class FeedConfigurationPage extends StatefulWidget {
  const FeedConfigurationPage({super.key});

  @override
  State<FeedConfigurationPage> createState() => _FeedConfigurationPageState();
}

class _FeedConfigurationPageState extends State<FeedConfigurationPage> {
  final _formKey = GlobalKey<FormState>();
  final _dailyConsumptionController = TextEditingController();
  final _totalFoodController = TextEditingController();
  DateTime? _selectedDate;
  String? _dateError;

  @override
  void dispose() {
    _dailyConsumptionController.dispose();
    _totalFoodController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _validateDate()) {
      // Mostrar el diálogo primero
      showDialog(
        context: context,
        builder: (context) {
          final dailyConsumption = int.parse(_dailyConsumptionController.text);
          final totalFood = double.parse(_totalFoodController.text);
          final purchaseDate = _selectedDate!;

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text('Confirmar configuración'),
            content: FoodCalculationCard(
              dailyConsumption: dailyConsumption,
              totalFood: totalFood,
              purchaseDate: purchaseDate,
            ),
            actions: [
              // Botón Cancelar
              TextButton(
                onPressed:
                    () => Navigator.of(context).pop(), // Solo cierra el diálogo
                child: const Text('Cancelar'),
              ),
              // Botón Aceptar
              TextButton(
                onPressed: () {
                  // Cierra el diálogo
                  Navigator.of(context).pop();
                  // Muestra el SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Configuración guardada correctamente.',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: AppColors.good,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.all(16),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                  // Cierra la página actual
                  Navigator.of(context).pop();
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
  }

  bool _validateDate() {
    if (_selectedDate == null) {
      setState(() {
        _dateError = 'Por favor selecciona una fecha de compra';
      });
      return false;
    }
    setState(() {
      _dateError = null;
    });
    return true;
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        _dateError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
      appBar: AppBar(title: const Text('Alimentación')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.only(
            left: padding.left,
            top: padding.top,
            right: padding.right,
            bottom: padding.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    fieldLabel: 'Consumo diario (gramos)',
                    defaultText: 'Ej. 200',
                    isNumberField: true,
                    isRequired: true,
                    controller: _dailyConsumptionController,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Este campo es obligatorio';
                      if (int.tryParse(value) == null)
                        return 'Ingresa un número válido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _ApplicationDateField(
                    selectedDate: _selectedDate,
                    errorText: _dateError,
                    onTap: () => _selectDate(context),
                    labelText: 'Fecha de compra',
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    fieldLabel: 'Cantidad comprada (kg)',
                    defaultText: 'Ej. 5',
                    isNumberField: true,
                    isRequired: true,
                    controller: _totalFoodController,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Este campo es obligatorio';
                      if (double.tryParse(value) == null)
                        return 'Ingresa un número válido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'Guardar configuración',
                    buttonColor: AppColors.primary,
                    foregroundColor: AppColors.textSecondary,
                    onPressed: _submitForm,
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ApplicationDateField extends StatelessWidget {
  final DateTime? selectedDate;
  final String? errorText;
  final VoidCallback onTap;
  final String labelText;

  const _ApplicationDateField({
    required this.selectedDate,
    required this.errorText,
    required this.onTap,
    this.labelText = 'Fecha',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(labelText, style: const TextStyle(fontSize: 16)),
            const Text(' *', style: TextStyle(color: Colors.red, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color:
                    errorText != null
                        ? AppColors.alert
                        : AppColors.textFieldBorderColor,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                      : 'Selecciona una fecha',
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedDate != null ? Colors.black : Colors.grey,
                  ),
                ),
                const Icon(Icons.calendar_today, color: Colors.grey),
              ],
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 5),
          Text(
            errorText!,
            style: TextStyle(color: AppColors.alert, fontSize: 12),
          ),
        ],
      ],
    );
  }
}

class FoodCalculationCard extends StatelessWidget {
  final int dailyConsumption;
  final double totalFood;
  final DateTime purchaseDate;

  const FoodCalculationCard({
    required this.dailyConsumption,
    required this.totalFood,
    required this.purchaseDate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final daysRemaining = (totalFood * 1000 / dailyConsumption).floor();
    final endDate = purchaseDate.add(Duration(days: daysRemaining));

    var textStyle = const TextStyle(fontSize: 18, color: Colors.black);

    Widget buildInfoRow(
      IconData icon,
      String label,
      String value,
      TextStyle textStyle,
    ) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Icon(icon, size: 30, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$label: $value',
                style: textStyle.copyWith(fontSize: 14),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 350,
      width: double.infinity,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        shadowColor: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cálculos de comida',
                style: textStyle.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              buildInfoRow(
                Icons.restaurant,
                'Consumo diario',
                '$dailyConsumption gramos',
                textStyle,
              ),
              buildInfoRow(
                Icons.scale,
                'Cantidad total',
                '${totalFood.toStringAsFixed(2)} kg',
                textStyle,
              ),
              buildInfoRow(
                Icons.calendar_today,
                'Fecha de compra',
                DateFormat('dd/MM/yyyy').format(purchaseDate),
                textStyle,
              ),
              buildInfoRow(
                Icons.hourglass_bottom,
                'Días restantes',
                '$daysRemaining días',
                textStyle,
              ),
              buildInfoRow(
                Icons.event_available,
                'Fecha estimada de término',
                DateFormat('dd/MM/yyyy').format(endDate),
                textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
