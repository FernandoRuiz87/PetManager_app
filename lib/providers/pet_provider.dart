import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../services/local_storage_service.dart';

class PetProvider with ChangeNotifier {
  final _storage = LocalStorageService();
  List<Pet> _pets = [];

  List<Pet> get pets => _pets;

  Future<void> loadPets() async {
    _pets = await _storage.loadPets();
    notifyListeners();
  }

  Future<void> addPet(Pet newPet) async {
    final petToAdd =
        newPet.id.isEmpty
            ? Pet(
              id: _generateId(),
              name: newPet.name,
              specie: newPet.specie,
              age: newPet.age,
              breed: newPet.breed,
              photoUrl: newPet.photoUrl,
            )
            : newPet;

    _pets.add(petToAdd);
    await _storage.savePet(_pets);
    notifyListeners();
  }

  Future<void> updatePet(Pet updatedPet) async {
    final index = _pets.indexWhere((p) => p.id == updatedPet.id);
    if (index != -1) {
      _pets[index] = updatedPet;
      await _storage.savePet(_pets);
      notifyListeners();
    }
  }

  Future<void> deletePet(String id) async {
    _pets.removeWhere((p) => p.id == id);
    await _storage.savePet(_pets);
    notifyListeners();
  }

  Future<void> deleteAllPets() async {
    _pets.clear();
    await _storage.savePet(_pets);
    notifyListeners();
  }

  // Método para generar un ID único
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Método auxiliar para encontrar mascota por ID
  Pet? getPetById(String id) {
    try {
      return _pets.firstWhere((pet) => pet.id == id);
    } catch (e) {
      return null;
    }
  }
}
