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
    _pets.add(newPet);
    await _storage.savePet(_pets);
    notifyListeners();
  }

  Future<void> updatePet(Pet updatedPet) async {
    final index = _pets.indexWhere((p) => p.name == updatedPet.name);
    if (index != -1) {
      _pets[index] = updatedPet;
      await _storage.savePet(_pets);
      notifyListeners();
    }
  }

  Future<void> deletePetByName(String name) async {
    _pets.removeWhere((p) => p.name == name);
    await _storage.savePet(_pets);
    notifyListeners();
  }

  Future<void> deleteAllPets() async {
    _pets.clear();
    await _storage.savePet(_pets);
    notifyListeners();
  }
}
