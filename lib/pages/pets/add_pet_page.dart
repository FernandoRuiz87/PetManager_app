import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_manager/pages/pets/shared_pet_form.dart';
import 'package:pet_manager/styles/app_colors.dart';
import 'package:pet_manager/widgets/buttons.dart';
import 'package:pet_manager/widgets/text_fields.dart';

class AddPetPage extends StatefulWidget {
  const AddPetPage({super.key});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  // ignore: unused_field
  XFile? _petImage;
  // ignore: unused_field
  String? _selectedSpecies;

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _clearForm();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Mascota agregada correctamente.',
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
      Navigator.pop(context, '/home');
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

  void _clearForm() {
    _nameController.clear();
    _breedController.clear();
    _ageController.clear();
    setState(() {
      _petImage = null;
      _selectedSpecies = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva mascota')),
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
                    fieldLabel: 'Ingresa el nombre de tu mascota',
                    defaultText: 'Nombre de la mascota',
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
                    fieldLabel: 'Ingresa la edad de tu mascota',
                    defaultText: 'Edad',
                    isNumberField: true,
                    controller: _ageController,
                    isRequired: true,
                    validator: _ageValidator,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    fieldLabel: 'Ingresa la raza de tu mascota',
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
                    text: 'Agregar mascota',
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
}
