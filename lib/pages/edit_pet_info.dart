import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pet_manager_app/providers/pet_provider.dart';
import 'package:pet_manager_app/widgets/custom_text_fields.dart';
import 'package:pet_manager_app/widgets/custom_buttons.dart';
import 'package:pet_manager_app/colors/app_colors.dart';
import 'package:pet_manager_app/models/pet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  XFile? _petImage;

  bool _hasChanged = false; // Estado para detectar cambios

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pet.name);
    _breedController = TextEditingController(text: widget.pet.breed);
    _ageController = TextEditingController(text: widget.pet.age.toString());
    _selectedSpecies = widget.pet.specie;
    _petImage =
        widget.pet.photoUrl != null && widget.pet.photoUrl!.isNotEmpty
            ? XFile(widget.pet.photoUrl!)
            : null;
    // Agregar listeners para detectar cambios en los campos
    _nameController.addListener(_checkChanges);
    _breedController.addListener(_checkChanges);
    _ageController.addListener(_checkChanges);
  }

  void _checkChanges() {
    final hasNewChanges =
        _nameController.text != widget.pet.name ||
        _breedController.text != widget.pet.breed ||
        _ageController.text != widget.pet.age.toString() ||
        _selectedSpecies != widget.pet.specie ||
        (_petImage?.path ?? '') != (widget.pet.photoUrl ?? '');

    if (hasNewChanges != _hasChanged) {
      setState(() {
        _hasChanged = hasNewChanges;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    // Crear la mascota actualizada
    final updatedPet = Pet(
      name: _nameController.text,
      specie: _selectedSpecies!,
      age: int.parse(_ageController.text),
      breed: _breedController.text,
      photoUrl: _petImage?.path ?? widget.pet.photoUrl,
    );

    final petProvider = Provider.of<PetProvider>(context, listen: false);
    await petProvider.updatePet(updatedPet);

    Navigator.pop(context, '/home');
  }

  void _submitEdit() {
    if (_formKey.currentState!.validate()) {
      _saveChanges();
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor completa todos los campos correctamente.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.alert,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 3),
        ),
      );
    }
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
          top: padding.top,
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
                    defaultText: '',
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
                    initialValue: _selectedSpecies,
                    onChanged: (value) {
                      setState(() {
                        _selectedSpecies = value;
                      });
                      _checkChanges();
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    fieldLabel: 'Edad',
                    defaultText: '',
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
                    fieldLabel: 'Raza',
                    defaultText: '',
                    isNumberField: false,
                    controller: _breedController,
                  ),
                  const SizedBox(height: 20),
                  _PhotoSection(
                    initialImage: _petImage,
                    onImageSelected: (image) {
                      setState(() {
                        _petImage = image;
                      });
                      _checkChanges();
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Guardar cambios',
                    buttonColor: _hasChanged ? AppColors.primary : Colors.grey,
                    foregroundColor: AppColors.textSecondary,
                    onPressed: _hasChanged ? _submitEdit : () {},
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

// Función para guardar la imagen de forma permanente
Future<String> saveImagePermanently(XFile image) async {
  final directory = await getApplicationDocumentsDirectory();
  final name = p.basename(image.path);
  final imagePath = p.join(directory.path, name);
  final newImage = await File(image.path).copy(imagePath);
  return newImage.path;
}

class _PhotoSection extends StatefulWidget {
  final XFile? initialImage;
  final ValueChanged<XFile?> onImageSelected;

  const _PhotoSection({this.initialImage, required this.onImageSelected});

  @override
  _PhotoSectionState createState() => _PhotoSectionState();
}

class _PhotoSectionState extends State<_PhotoSection> {
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _imageFile = widget.initialImage;
  }

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
        Center(
          child: const Text(
            'Toca para editar la foto',
            style: TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(height: 10),
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
  final String? initialValue;
  final ValueChanged<String?> onChanged;

  const _SpeciesDropdown({this.initialValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Selecciona la especie', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: initialValue,
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
