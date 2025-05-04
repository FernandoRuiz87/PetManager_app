class Shower {
  final String date; // Changed to String to match the rest of the codebase

  Shower({required this.date});

  factory Shower.fromJson(Map<String, dynamic> json) {
    return Shower(date: json['date'] as String); // Removed DateTime parsing
  }

  Map<String, dynamic> toJson() {
    return {'date': date}; // Removed DateTime conversion
  }
}
