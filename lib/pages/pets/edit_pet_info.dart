import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_manager_app/colors/app_colors.dart';
import 'package:pet_manager_app/models/pet.dart';
import 'package:pet_manager_app/providers/pet_provider.dart';
import 'package:pet_manager_app/widgets/custom_buttons.dart';
import 'package:pet_manager_app/widgets/custom_text_fields.dart';
import 'package:pet_manager_app/pages/pets/widgets/shared_pet_form.dart';
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
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pet.name);
    _breedController = TextEditingController(text: widget.pet.breed);
    _ageController = TextEditingController(text: widget.pet.age.toString());
    _selectedSpecies = widget.pet.specie;
    _petImage =
        widget.pet.photoUrl?.isNotEmpty == true
            ? XFile(widget.pet.photoUrl!)
            : null;

    _nameController.addListener(_checkChanges);
    _breedController.addListener(_checkChanges);
    _ageController.addListener(_checkChanges);
  }

  void _checkChanges() {
    final nameChanged = _nameController.text != widget.pet.name;
    final breedChanged = _breedController.text != widget.pet.breed;
    final ageChanged = _ageController.text != widget.pet.age.toString();
    final speciesChanged = _selectedSpecies != widget.pet.specie;
    final imageChanged = _petImage?.path != widget.pet.photoUrl;

    setState(() {
      _hasChanged =
          nameChanged ||
          breedChanged ||
          ageChanged ||
          speciesChanged ||
          imageChanged;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final updatedPet = Pet(
      id: widget.pet.id,
      name: _nameController.text,
      specie: _selectedSpecies!,
      age: int.parse(_ageController.text),
      breed: _breedController.text,
      photoUrl: _petImage?.path ?? widget.pet.photoUrl ?? '',
    );

    final petProvider = Provider.of<PetProvider>(context, listen: false);
    await petProvider.updatePet(updatedPet);
  }

  void _submitEdit() {
    if (_formKey.currentState!.validate()) {
      _saveChanges();
      Navigator.of(context).popUntil(
        ModalRoute.withName('/home'), // Navega hasta encontrar esta ruta
      );
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
      appBar: AppBar(
        title: const Text('Editar mascota'),
        actions: [
          if (_hasChanged)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Descartar cambios',
            ),
        ],
      ),
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
                    validator: PetFormValidators.requiredValidator,
                  ),
                  const SizedBox(height: 20),
                  SpeciesDropdown(
                    initialValue: _selectedSpecies,
                    onChanged: (value) {
                      setState(() => _selectedSpecies = value);
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
                    validator: PetFormValidators.ageValidator,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    fieldLabel: 'Raza',
                    defaultText: '',
                    isNumberField: false,
                    controller: _breedController,
                  ),
                  const SizedBox(height: 20),
                  PetPhotoSection(
                    initialImage: _petImage,
                    onImageSelected: (image) {
                      setState(() => _petImage = image);
                      _checkChanges();
                    },
                    labelText: 'Toca para editar la foto',
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Guardar cambios',
                    buttonColor:
                        _hasChanged
                            ? AppColors.primary
                            : AppColors.textFieldBorderColor,
                    foregroundColor: AppColors.textSecondary,
                    onPressed: () {
                      if (_hasChanged) {
                        _submitEdit();
                      }
                    },
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
