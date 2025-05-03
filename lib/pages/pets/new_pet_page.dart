import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_manager_app/pages/pets/widgets/shared_pet_form.dart';
import 'package:provider/provider.dart';

import 'package:pet_manager_app/colors/app_colors.dart';
import 'package:pet_manager_app/models/pet.dart';
import 'package:pet_manager_app/providers/pet_provider.dart';
import 'package:pet_manager_app/widgets/custom_buttons.dart';
import 'package:pet_manager_app/widgets/custom_text_fields.dart';

class NewPetPage extends StatefulWidget {
  const NewPetPage({super.key});

  @override
  State<NewPetPage> createState() => _NewPetPageState();
}

class _NewPetPageState extends State<NewPetPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  XFile? _petImage;
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
      _savePet();
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

  Future<void> _savePet() async {
    final newPet = Pet(
      name: _nameController.text,
      specie: _selectedSpecies!,
      age: int.parse(_ageController.text),
      breed: _breedController.text,
      photoUrl: _petImage?.path ?? '',
    );

    final petProvider = Provider.of<PetProvider>(context, listen: false);
    await petProvider.addPet(newPet);

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
    if (int.tryParse(value) == null)
      return 'Por favor ingresa un número válido';
    return null;
  }
}
