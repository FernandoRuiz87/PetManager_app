import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_manager/models/pet.dart';
import 'package:pet_manager/styles/app_colors.dart';
import 'package:pet_manager/widgets/buttons.dart';
import 'package:pet_manager/widgets/common_widgets.dart';
import 'package:pet_manager/widgets/text_fields.dart';
import 'package:pet_manager/pages/pets/shared_pet_form.dart';

class EditPetPage extends StatefulWidget {
  final Pet pet;

  const EditPetPage({super.key, required this.pet});

  @override
  State<EditPetPage> createState() => _EditPetPageState();
}

class _EditPetPageState extends State<EditPetPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _ageController;
  String? _selectedSpecies;
  // ignore: unused_field
  XFile? _petImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pet.name);
    _breedController = TextEditingController(text: widget.pet.breed ?? '');
    _ageController = TextEditingController(text: widget.pet.age.toString());
    _selectedSpecies = _mapSpeciesToSpanish(widget.pet.specie);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await showConfirmationDialog(
        context: context,
        title: 'Confirmar cambios',
        content: '¿Estás seguro de que desea guardar los cambios?',
        confirmationMessage: 'Guardar',
        confirmationColor: AppColors.primary,
        onConfirm: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Cambios guardados correctamente.',
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
          Navigator.pop(context); // Cierra el modal
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Por favor completa todos los campos correctamente.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.alert,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  String? _mapSpeciesToSpanish(String? species) {
    switch (species) {
      case 'Dog':
        return 'Perro';
      case 'Cat':
        return 'Gato';
      case 'Bird':
        return 'Ave';
      case 'Fish':
        return 'Pez';
      case 'Reptile':
        return 'Reptil';
      case 'Other':
        return 'Otro';
      default:
        return null;
    }
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) return 'Este campo es obligatorio';
    return null;
  }

  String? _ageValidator(String? value) {
    if (value == null || value.isEmpty) return 'Este campo es obligatorio';
    if (int.tryParse(value) == null) {
      return 'Por favor ingresa un número válido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: AppBar(title: const Text('Editar mascota')),
      body: Padding(
        padding: EdgeInsets.only(
          left: padding.left,
          right: padding.right,
          bottom: padding.bottom,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    fieldLabel: 'Nombre de la mascota',
                    defaultText: 'Nombre',
                    isNumberField: false,
                    controller: _nameController,
                    isRequired: true,
                    validator: _requiredValidator,
                  ),
                  const SizedBox(height: 20),
                  SpeciesDropdown(
                    value: _selectedSpecies,
                    onChanged: (value) {
                      setState(() => _selectedSpecies = value);
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    fieldLabel: 'Edad',
                    defaultText: 'Edad',
                    isNumberField: true,
                    controller: _ageController,
                    validator: _ageValidator,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    fieldLabel: 'Raza',
                    defaultText: 'Raza',
                    isNumberField: false,
                    controller: _breedController,
                  ),
                  const SizedBox(height: 20),
                  PetPhotoSection(
                    onImageSelected: (image) {
                      setState(() => _petImage = image);
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Guardar cambios',
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
