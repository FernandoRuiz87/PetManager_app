import 'package:pet_manager_app/models/shower.dart';
import 'package:pet_manager_app/models/vaccine.dart';

class Pet {
  final String name;
  final String specie;
  final String? breed; // raza
  final int age;
  final String? photoUrl;
  final List<Vaccine>? vaccines;
  final List<Shower>? showers;

  Pet({
    required this.name,
    required this.specie,
    this.breed,
    required this.age,
    this.photoUrl,
    this.vaccines,
    this.showers,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      name: json['name'] as String,
      specie: json['specie'] as String,
      breed: json['breed'] as String?,
      age: json['age'] as int,
      photoUrl: json['photoUrl'] as String?,
      vaccines:
          (json['vaccines'] as List<dynamic>?)
              ?.map((v) => Vaccine.fromJson(v as Map<String, dynamic>))
              .toList(),
      showers:
          (json['showers'] as List<dynamic>?)
              ?.map((s) => Shower.fromJson(s as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'specie': specie,
      'breed': breed,
      'age': age,
      'photoUrl': photoUrl,
      'vaccines': vaccines?.map((v) => v.toJson()).toList(),
      'showers': showers?.map((s) => s.toJson()).toList(),
    };
  }
}
