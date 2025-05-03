import 'package:uuid/uuid.dart';

class Shower {
  final String id;
  final String date;

  Shower({String? id, required this.date}) : id = id ?? const Uuid().v4();

  factory Shower.fromJson(Map<String, dynamic> json) {
    return Shower(id: json['id'] as String?, date: json['date'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'date': date};
  }
}
