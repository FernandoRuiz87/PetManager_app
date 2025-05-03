import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pet_manager_app/models/pet.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _petsFile async {
    final path = await _localPath;
    return File('$path/pets.json');
  }

  Future<void> savePet(List<Pet> pets) async {
    final file = await _petsFile;
    final jsonList = pets.map((p) => p.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
    print('Guardado en: ${file.path}');
  }

  Future<List<Pet>> loadPets() async {
    try {
      final file = await _petsFile;

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

  Future<void> deletePetsFile() async {
    final file = await _petsFile;
    if (await file.exists()) {
      await file.delete();
    }
  }

  // Editar mascota por nombre (reemplaza la existente con el mismo nombre)
  Future<void> updatePet(Pet updatedPet) async {
    List<Pet> pets = await loadPets();

    int index = pets.indexWhere((p) => p.name == updatedPet.name);
    if (index != -1) {
      pets[index] = updatedPet;
      await savePet(pets);
    }
  }

  // Eliminar mascota por nombre
  Future<void> deletePetByName(String name) async {
    List<Pet> pets = await loadPets();
    pets.removeWhere((p) => p.name == name);
    await savePet(pets);
  }
}
