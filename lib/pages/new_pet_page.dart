import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:pet_manager_app/colors/app_colors.dart';
import 'package:pet_manager_app/models/pet.dart';
import 'package:pet_manager_app/services/local_storage_service.dart';
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
      Navigator.pushReplacementNamed(context, '/home');
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
    final storage = LocalStorageService();
    final pets = await storage.loadPets();

    final newPet = Pet(
      name: _nameController.text,
      specie: _selectedSpecies!,
      age: int.parse(_ageController.text),
      breed: _breedController.text,
      photoUrl: _petImage?.path ?? '',
    );

    pets.add(newPet);
    await storage.savePet(pets);

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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _SpeciesDropdown(
                    onChanged: (value) {
                      setState(() {
                        _selectedSpecies = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    fieldLabel: 'Ingresa la edad de tu mascota',
                    defaultText: 'Edad',
                    isNumberField: true,
                    controller: _ageController,
                    isRequired: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Por favor ingresa un número válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    fieldLabel: 'Ingresa la raza de tu mascota',
                    defaultText: 'Raza',
                    isNumberField: false,
                    controller: _breedController,
                  ),
                  const SizedBox(height: 20),
                  _PhotoSection(
                    onImageSelected: (image) {
                      setState(() {
                        _petImage = image;
                      });
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
}

// Función para guardar imagen permanentemente
Future<String> saveImagePermanently(XFile image) async {
  final directory = await getApplicationDocumentsDirectory();
  final name = p.basename(image.path);
  final imagePath = p.join(directory.path, name);
  final newImage = await File(image.path).copy(imagePath);
  return newImage.path;
}

class _PhotoSection extends StatefulWidget {
  final ValueChanged<XFile?> onImageSelected;
  const _PhotoSection({required this.onImageSelected});

  @override
  _PhotoSectionState createState() => _PhotoSectionState();
}

class _PhotoSectionState extends State<_PhotoSection> {
  XFile? _imageFile;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final savedPath = await saveImagePermanently(image);
      final savedImage = XFile(savedPath);

      setState(() {
        _imageFile = savedImage;
      });

      widget.onImageSelected(savedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Selecciona la foto de tu mascota',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: _pickImage,
          child:
              _imageFile == null
                  ? const _EmptyImagePlaceholder()
                  : _ImagePreview(imageFile: _imageFile),
        ),
      ],
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.imageFile});
  final XFile? imageFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.background),
        image: DecorationImage(
          image: FileImage(File(imageFile!.path)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _EmptyImagePlaceholder extends StatelessWidget {
  const _EmptyImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textFieldBorderColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.photo_outlined,
            size: 100,
            color: AppColors.textFieldBorderColor,
          ),
          SizedBox(height: 10),
          Text(
            'Toca para agregar una foto',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textTertiary, fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class _SpeciesDropdown extends StatelessWidget {
  final ValueChanged<String?> onChanged;

  const _SpeciesDropdown({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Selecciona la especie', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          hint: const Text('Selecciona una opción'),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textFieldBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.alert),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.alert, width: 2),
            ),
          ),
          style: const TextStyle(color: Colors.black, fontSize: 16),
          dropdownColor: Colors.white,
          validator: (value) {
            if (value == null) {
              return 'Este campo es obligatorio';
            }
            return null;
          },
          items: const [
            DropdownMenuItem(value: 'Perro', child: Text('Perro')),
            DropdownMenuItem(value: 'Gato', child: Text('Gato')),
            DropdownMenuItem(value: 'Ave', child: Text('Ave')),
            DropdownMenuItem(value: 'Pez', child: Text('Pez')),
            DropdownMenuItem(value: 'Reptil', child: Text('Reptil')),
            DropdownMenuItem(value: 'Otro', child: Text('Otro')),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}
