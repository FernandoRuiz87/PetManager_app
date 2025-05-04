import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_manager/styles/app_colors.dart';
import 'package:pet_manager/widgets/buttons.dart';
import 'package:pet_manager/widgets/text_fields.dart';

class AddVaccinePage extends StatefulWidget {
  const AddVaccinePage({super.key});

  @override
  State<AddVaccinePage> createState() => _AddVaccinePageState();
}

class _AddVaccinePageState extends State<AddVaccinePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _selectedDate;
  String? _dateError;

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _validateDate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vacuna agregada correctamente.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.good,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pop(context);
    }
  }

  bool _validateDate() {
    if (_selectedDate == null) {
      setState(() {
        _dateError = 'Por favor selecciona una fecha';
      });
      return false;
    }
    setState(() {
      _dateError = null;
    });
    return true;
  }

  Future<void> _selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
        _dateError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva vacuna')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.only(
            left: padding.left,
            right: padding.right,
            top: padding.top,
            bottom: padding.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  CustomTextField(
                    fieldLabel: 'Nombre de la vacuna',
                    defaultText: 'Ej: Rabia, Moquillo',
                    controller: _nameController,
                    isRequired: true,
                    isNumberField: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _ApplicationDateField(
                    selectedDate: _selectedDate,
                    errorText: _dateError,
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    fieldLabel: 'Duración en meses',
                    defaultText: 'Ej: 12 (para 1 año)',
                    controller: _durationController,
                    isRequired: true,
                    isNumberField: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingresa un número válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'Agregar Vacuna',
                    buttonColor: AppColors.primary,
                    foregroundColor: AppColors.textSecondary,
                    onPressed: _submitForm,
                    height: 50,
                  ),
                  const SizedBox(height: 20),
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

  const _ApplicationDateField({
    required this.selectedDate,
    required this.errorText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text('Fecha de aplicación', style: TextStyle(fontSize: 16)),
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
