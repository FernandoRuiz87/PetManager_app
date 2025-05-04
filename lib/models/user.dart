class User {
  final int id;
  final String username;
  final String password;

  User({required this.id, required this.username, required this.password});

  // Crear un objeto User a partir de JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
    );
  }

  // Convertir un objeto User a JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'username': username, 'password': password};
  }

  // Method to validate login credentials
  static bool validateLogin(
    String username,
    String password,
    List<User> users,
  ) {
    for (var user in users) {
      if (user.username == username && user.password == password) {
        return true;
      }
    }
    return false;
  }
}
