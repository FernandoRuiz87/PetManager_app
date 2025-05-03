class Vaccine {
  final String name;
  final String date;
  final String duration; // Duracion de la vacuna en meses

  Vaccine(this.duration, {required this.name, required this.date});

  factory Vaccine.fromJson(Map<String, dynamic> json) {
    return Vaccine(
      json['duration'] as String,
      name: json['name'] as String,
      date: json['date'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'date': date, 'duration': duration};
  }
}
