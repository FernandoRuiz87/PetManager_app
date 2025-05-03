import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pet_manager_app/colors/app_colors.dart';

// Función compartida para guardar imágenes
Future<String> saveImagePermanently(XFile image) async {
  final directory = await getApplicationDocumentsDirectory();
  final name = p.basename(image.path);
  final imagePath = p.join(directory.path, name);
  final newImage = await File(image.path).copy(imagePath);
  return newImage.path;
}

/// Widget para la sección de foto de mascota (reutilizable)
class PetPhotoSection extends StatefulWidget {
  final XFile? initialImage;
  final ValueChanged<XFile?> onImageSelected;
  final String labelText;

  const PetPhotoSection({
    super.key,
    this.initialImage,
    required this.onImageSelected,
    this.labelText = 'Selecciona la foto de tu mascota',
  });

  @override
  State<PetPhotoSection> createState() => _PetPhotoSectionState();
}

class _PetPhotoSectionState extends State<PetPhotoSection> {
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _imageFile = widget.initialImage;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final savedPath = await saveImagePermanently(image);
      final savedImage = XFile(savedPath);
      setState(() => _imageFile = savedImage);
      widget.onImageSelected(savedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.labelText, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: _pickImage,
          child:
              _imageFile == null
                  ? const EmptyImagePlaceholder()
                  : ImagePreview(imageFile: _imageFile!),
        ),
      ],
    );
  }
}

/// Vista previa de la imagen
class ImagePreview extends StatelessWidget {
  final XFile imageFile;

  const ImagePreview({required this.imageFile, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.background),
        image: DecorationImage(
          image: FileImage(File(imageFile.path)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

/// Placeholder cuando no hay imagen
class EmptyImagePlaceholder extends StatelessWidget {
  const EmptyImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.textFieldBorderColor),
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

/// Dropdown de especies (reutilizable)
class SpeciesDropdown extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const SpeciesDropdown({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.validator,
  });

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
          validator:
              validator ??
              (value) => value == null ? 'Este campo es obligatorio' : null,
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

/// Validadores comunes
class PetFormValidators {
  static String? requiredValidator(String? value) {
    if (value == null || value.isEmpty) return 'Este campo es obligatorio';
    return null;
  }

  static String? ageValidator(String? value) {
    if (value == null || value.isEmpty) return 'Este campo es obligatorio';
    if (int.tryParse(value) == null)
      return 'Por favor ingresa un número válido';
    return null;
  }
}
