class Vaccine {
  final String id;
  final String name;
  final String date;
  final String duration;

  Vaccine({
    required this.id,
    required this.name,
    required this.date,
    required this.duration,
  });

  factory Vaccine.fromJson(Map<String, dynamic> json) {
    return Vaccine(
      id: json['id'] as String,
      name: json['name'] as String,
      date: json['date'] as String,
      duration: json['duration'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'date': date, 'duration': duration};
  }
}
