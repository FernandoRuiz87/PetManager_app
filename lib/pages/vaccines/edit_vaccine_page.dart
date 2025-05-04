import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_manager/models/vaccine.dart';
import 'package:pet_manager/styles/app_colors.dart';
import 'package:pet_manager/widgets/buttons.dart';
import 'package:pet_manager/widgets/common_widgets.dart';
import 'package:pet_manager/widgets/text_fields.dart';

class EditVaccinePage extends StatefulWidget {
  final Vaccine vaccine;

  const EditVaccinePage({super.key, required this.vaccine});

  @override
  State<EditVaccinePage> createState() => _EditVaccinePageState();
}

class _EditVaccinePageState extends State<EditVaccinePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _durationController;
  late TextEditingController _notesController;
  DateTime? _selectedDate;
  String? _dateError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.vaccine.name);
    _durationController = TextEditingController(
      text: widget.vaccine.duration.toString(),
    );
    _notesController = TextEditingController(); // Si luego manejas notas
    _selectedDate = DateTime.tryParse(widget.vaccine.date);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Metodo para mostrar un dialogo de confirmacion
  Future<void> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmationMessage,
    required Color confirmationColor,
    required VoidCallback onConfirm,
    String successMessage = 'Operación completada correctamente.',
    Color successColor = AppColors.good,
  }) async {
    await showDialog(
      context: context,
      builder:
          (context) => ConfirmationDialog(
            title: title,
            content: content,
            confirmationMessage: confirmationMessage,
            confirmationColor: confirmationColor,
            onConfirm: onConfirm,
            successMessage: successMessage,
            successColor: successColor,
          ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _validateDate()) {
      showConfirmationDialog(
        context: context,
        title: 'Confirmar cambios',
        content: '¿Estás seguro de que desea guardar los cambios?',
        confirmationMessage: 'Guardar',
        confirmationColor: AppColors.primary,
        onConfirm: () {
          // Aquí puedes manejar la lógica para guardar los cambios
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Vacuna editada correctamente.',
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
          Navigator.of(context).pop(); // Cierra el modal
        },
      );
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
      initialDate: _selectedDate ?? DateTime.now(),
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
      appBar: AppBar(title: const Text('Editar vacuna')),
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
                    text: 'Guardar Cambios',
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
