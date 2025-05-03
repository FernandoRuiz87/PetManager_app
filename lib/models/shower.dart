class Shower {
  final String date; // Date of the shower

  Shower({required this.date});

  factory Shower.fromJson(Map<String, dynamic> json) {
    return Shower(date: json['date'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'date': date};
  }
}
