import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_manager_app/colors/app_colors.dart';
import 'package:pet_manager_app/models/feeding.dart';
import 'package:pet_manager_app/providers/pet_provider.dart';
import 'package:pet_manager_app/widgets/custom_buttons.dart';
import 'package:provider/provider.dart';

class FeedingSettingsPage extends StatefulWidget {
  final String petId;

  const FeedingSettingsPage({super.key, required this.petId});

  @override
  State<FeedingSettingsPage> createState() => _FeedingSettingsPageState();
}

class _FeedingSettingsPageState extends State<FeedingSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _totalFoodController;
  late TextEditingController _dailyConsumptionController;
  DateTime? _purchaseDate;

  @override
  void initState() {
    super.initState();
    final feeding =
        Provider.of<PetProvider>(context, listen: false).currentFeeding;
    _totalFoodController = TextEditingController(
      text: feeding?.totalFoodKg.toString() ?? '',
    );
    _dailyConsumptionController = TextEditingController(
      text: feeding?.dailyConsumptionGrams.toString() ?? '',
    );
    _purchaseDate = feeding?.purchaseDate;
  }

  @override
  void dispose() {
    _totalFoodController.dispose();
    _dailyConsumptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurar Alimentación')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _totalFoodController,
                decoration: const InputDecoration(
                  labelText: 'Peso total (kg)',
                  hintText: 'Ej. 5.0',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Campo obligatorio';
                  if (double.tryParse(value) == null)
                    return 'Ingrese un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dailyConsumptionController,
                decoration: const InputDecoration(
                  labelText: 'Consumo diario (gramos)',
                  hintText: 'Ej. 200',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Campo obligatorio';
                  if (double.tryParse(value) == null)
                    return 'Ingrese un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  _purchaseDate == null
                      ? 'Seleccionar fecha de compra'
                      : 'Comprado el: ${DateFormat('dd/MM/yyyy').format(_purchaseDate!)}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _purchaseDate ?? DateTime.now(),
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 365),
                    ),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate != null) {
                    setState(() => _purchaseDate = selectedDate);
                  }
                },
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Guardar Configuración',
                buttonColor: AppColors.primary,
                foregroundColor: AppColors.textSecondary,
                height: 50,
                onPressed: _saveFeedingConfig,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveFeedingConfig() {
    if (_formKey.currentState!.validate() && _purchaseDate != null) {
      final feeding = Feeding(
        petId: widget.petId,
        totalFoodKg: double.parse(_totalFoodController.text),
        dailyConsumptionGrams: double.parse(_dailyConsumptionController.text),
        purchaseDate: _purchaseDate!,
      );

      Provider.of<PetProvider>(
        context,
        listen: false,
      ).saveFeeding(feeding).then((_) => Navigator.pop(context));
    }
  }
}
