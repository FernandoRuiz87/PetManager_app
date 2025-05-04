import 'package:pet_manager/models/feed.dart';
import 'package:pet_manager/models/shower.dart';
import 'package:pet_manager/models/vaccine.dart';

class Pet {
  final String id;
  final String name;
  final String specie;
  final String? breed;
  final int age;
  final String? photoUrl;
  final List<Vaccine> vaccines;
  final List<Shower> showers;
  final Feeding feedings;

  Pet({
    required this.id,
    required this.name,
    required this.specie,
    this.breed,
    required this.age,
    this.photoUrl,
    List<Vaccine>? vaccines,
    List<Shower>? showers,
    required this.feedings,
  }) : vaccines = vaccines ?? [],
       showers = showers ?? [];

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      specie: json['specie']?.toString() ?? '',
      breed: json['breed']?.toString(),
      age: (json['age'] as num?)?.toInt() ?? 0,
      photoUrl: json['photoUrl']?.toString(),
      vaccines:
          (json['vaccines'] as List<dynamic>?)
              ?.map((v) => Vaccine.fromJson(v as Map<String, dynamic>))
              .toList() ??
          [],
      showers:
          (json['showers'] as List<dynamic>?)
              ?.map((s) => Shower.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      feedings: Feeding.fromJson(json['feedings'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specie': specie,
      'breed': breed,
      'age': age,
      'photoUrl': photoUrl,
      'vaccines': vaccines.map((v) => v.toJson()).toList(),
      'showers': showers.map((s) => s.toJson()).toList(),
      'feedings': feedings.toJson(),
    };
  }
}
