import 'package:flutter/material.dart';
import 'package:pet_manager_app/models/feeding.dart';
import 'package:pet_manager_app/models/pet.dart';
import 'package:pet_manager_app/models/shower.dart';
import 'package:pet_manager_app/models/vaccine.dart';
import 'package:pet_manager_app/services/local_storage_service.dart';
import 'package:uuid/uuid.dart';

/// Provider principal que gestiona el estado de las mascotas y sus datos relacionados
class PetProvider with ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();
  final Uuid _uuid = const Uuid();
  List<Pet> _pets = [];
  Feeding? _currentFeeding;

  List<Pet> get pets => _pets;
  Feeding? get currentFeeding => _currentFeeding;

  // ==================== OPERACIONES BÁSICAS DE MASCOTAS ====================

  /// Carga todas las mascotas desde el almacenamiento local
  Future<void> loadPets() async {
    try {
      _pets = await _storage.loadPets();
      notifyListeners();
    } catch (e) {
      throw Exception('Error al cargar mascotas: $e');
    }
  }

  /// Agrega una nueva mascota
  Future<void> addPet(Pet newPet) async {
    try {
      final petToAdd =
          newPet.id.isEmpty ? newPet.copyWith(id: _uuid.v4()) : newPet;
      _pets.add(petToAdd);
      await _storage.savePets(_pets);
      notifyListeners();
    } catch (e) {
      throw Exception('Error al agregar mascota: $e');
    }
  }

  /// Actualiza los datos de una mascota existente
  Future<void> updatePet(Pet updatedPet) async {
    try {
      final index = _pets.indexWhere((p) => p.id == updatedPet.id);
      if (index != -1) {
        _pets[index] = updatedPet;
        await _storage.savePets(_pets);
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Error al actualizar mascota: $e');
    }
  }

  /// Elimina una mascota por su ID
  Future<void> deletePet(String id) async {
    try {
      _pets.removeWhere((p) => p.id == id);
      await _storage.savePets(_pets);
      await _storage.deleteFeeding(
        id,
      ); // Elimina datos de alimentación asociados
      notifyListeners();
    } catch (e) {
      throw Exception('Error al eliminar mascota: $e');
    }
  }

  // ==================== OPERACIONES CON ALIMENTACIÓN ====================

  /// Carga la configuración de alimentación para una mascota
  Future<void> loadFeeding(String petId) async {
    try {
      _currentFeeding = await _storage.loadFeeding(petId);
      notifyListeners();
    } catch (e) {
      throw Exception('Error al cargar datos de alimentación: $e');
    }
  }

  /// Guarda la configuración de alimentación
  Future<void> saveFeeding(Feeding feeding) async {
    try {
      _currentFeeding = feeding;
      await _storage.saveFeeding(feeding);
      notifyListeners();
    } catch (e) {
      throw Exception('Error al guardar alimentación: $e');
    }
  }

  /// Actualiza la configuración de alimentación
  Future<void> updateFeeding(Feeding updatedFeeding) async {
    try {
      _currentFeeding = updatedFeeding;
      await _storage.saveFeeding(updatedFeeding);
      notifyListeners();
    } catch (e) {
      throw Exception('Error al actualizar alimentación: $e');
    }
  }

  // ==================== OPERACIONES CON VACUNAS ====================

  /// Agrega una nueva vacuna a una mascota
  Future<void> addVaccine(String petId, Vaccine newVaccine) async {
    try {
      final petIndex = _pets.indexWhere((pet) => pet.id == petId);
      if (petIndex != -1) {
        final updatedPet = _pets[petIndex];
        final updatedVaccines = [...updatedPet.vaccines ?? [], newVaccine];

        _pets[petIndex] = updatedPet.copyWith(vaccines: updatedVaccines);
        await _storage.savePets(_pets);
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Error al agregar vacuna: $e');
    }
  }

  /// Actualiza una vacuna existente
  Future<void> updateVaccine(String petId, Vaccine updatedVaccine) async {
    try {
      final petIndex = _pets.indexWhere((pet) => pet.id == petId);
      if (petIndex != -1) {
        final updatedPet = _pets[petIndex];
        final updatedVaccines =
            updatedPet.vaccines
                ?.map((v) => v.id == updatedVaccine.id ? updatedVaccine : v)
                .toList()
                ?.cast<Vaccine>();

        if (updatedVaccines != null) {
          _pets[petIndex] = updatedPet.copyWith(vaccines: updatedVaccines);
          await _storage.savePets(_pets);
          notifyListeners();
        }
      }
    } catch (e) {
      throw Exception('Error al actualizar vacuna: $e');
    }
  }

  /// Elimina una vacuna
  Future<void> deleteVaccine(String petId, String vaccineId) async {
    try {
      final petIndex = _pets.indexWhere((pet) => pet.id == petId);
      if (petIndex != -1) {
        final updatedPet = _pets[petIndex];
        final updatedVaccines =
            updatedPet.vaccines?.where((v) => v.id != vaccineId).toList();

        _pets[petIndex] = updatedPet.copyWith(vaccines: updatedVaccines);
        await _storage.savePets(_pets);
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Error al eliminar vacuna: $e');
    }
  }

  // ==================== OPERACIONES CON BAÑOS ====================

  /// Agrega un nuevo registro de baño
  Future<void> addShower(String petId, Shower newShower) async {
    try {
      final petIndex = _pets.indexWhere((pet) => pet.id == petId);
      if (petIndex != -1) {
        final updatedPet = _pets[petIndex];
        final updatedShowers = [...updatedPet.showers ?? [], newShower];

        _pets[petIndex] = updatedPet.copyWith(showers: updatedShowers);
        await _storage.savePets(_pets);
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Error al agregar baño: $e');
    }
  }

  /// Elimina un registro de baño
  Future<void> deleteShower(String petId, String showerId) async {
    try {
      final petIndex = _pets.indexWhere((pet) => pet.id == petId);
      if (petIndex != -1) {
        final updatedPet = _pets[petIndex];
        final updatedShowers =
            updatedPet.showers
                ?.where((s) => s.id != showerId)
                .toList()
                ?.cast<Shower>();

        _pets[petIndex] = updatedPet.copyWith(showers: updatedShowers);
        await _storage.savePets(_pets);
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Error al eliminar baño: $e');
    }

    // ==================== MÉTODOS AUXILIARES ====================

    /// Busca una mascota por su ID
    Pet? getPetById(String id) {
      try {
        return _pets.firstWhere((pet) => pet.id == id);
      } catch (e) {
        return null;
      }
    }
  }
}
