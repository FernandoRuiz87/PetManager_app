import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pet_manager_app/models/feeding.dart';
import 'package:pet_manager_app/models/pet.dart';

/// Servicio para manejar el almacenamiento local de datos
class LocalStorageService {
  // Singleton pattern
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  /// Obtiene la ruta del directorio de documentos de la aplicación
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Obtiene el archivo donde se guardan las mascotas
  Future<File> get _petsFile async {
    final path = await _localPath;
    return File('$path/pets.json');
  }

  /// Obtiene un archivo específico por nombre
  Future<File> _getFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename');
  }

  // ========== OPERACIONES CON MASCOTAS ==========

  /// Guarda la lista completa de mascotas
  Future<void> savePets(List<Pet> pets) async {
    try {
      final file = await _petsFile;
      final jsonList = pets.map((p) => p.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonList));
    } catch (e) {
      print('Error saving pets: $e');
      throw Exception('No se pudo guardar la lista de mascotas');
    }
  }

  /// Carga todas las mascotas almacenadas
  Future<List<Pet>> loadPets() async {
    try {
      final file = await _petsFile;

      // Si el archivo no existe, retorna lista vacía
      if (!(await file.exists())) {
        return [];
      }

      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((json) => Pet.fromJson(json)).toList();
    } catch (e) {
      print('Error loading pets: $e');
      return [];
    }
  }

  /// Actualiza una mascota existente (buscando por nombre)
  Future<void> updatePet(Pet updatedPet) async {
    try {
      List<Pet> pets = await loadPets();
      final index = pets.indexWhere((p) => p.id == updatedPet.id);

      if (index != -1) {
        pets[index] = updatedPet;
        await savePets(pets);
      }
    } catch (e) {
      print('Error updating pet: $e');
      throw Exception('No se pudo actualizar la mascota');
    }
  }

  /// Elimina una mascota por su ID
  Future<void> deletePet(String petId) async {
    try {
      List<Pet> pets = await loadPets();
      pets.removeWhere((p) => p.id == petId);
      await savePets(pets);
    } catch (e) {
      print('Error deleting pet: $e');
      throw Exception('No se pudo eliminar la mascota');
    }
  }

  /// Elimina el archivo completo de mascotas
  Future<void> deletePetsFile() async {
    try {
      final file = await _petsFile;
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting pets file: $e');
      throw Exception('No se pudo eliminar el archivo de mascotas');
    }
  }

  // ========== OPERACIONES CON ALIMENTACIÓN ==========

  /// Guarda la configuración de alimentación de una mascota
  Future<void> saveFeeding(Feeding feeding) async {
    try {
      final file = await _getFile('feeding_${feeding.petId}.json');
      await file.writeAsString(json.encode(feeding.toJson()));
    } catch (e) {
      print('Error saving feeding data: $e');
      throw Exception('No se pudo guardar la configuración de alimentación');
    }
  }

  /// Carga la configuración de alimentación de una mascota
  Future<Feeding?> loadFeeding(String petId) async {
    try {
      final file = await _getFile('feeding_$petId.json');

      if (!(await file.exists())) {
        return null;
      }

      final contents = await file.readAsString();
      return Feeding.fromJson(json.decode(contents));
    } catch (e) {
      print('Error loading feeding data: $e');
      return null;
    }
  }

  /// Elimina la configuración de alimentación de una mascota
  Future<void> deleteFeeding(String petId) async {
    try {
      final file = await _getFile('feeding_$petId.json');
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting feeding data: $e');
      throw Exception('No se pudo eliminar la configuración de alimentación');
    }
  }
}
