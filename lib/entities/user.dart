class User {
  final int id;
  final String name;
  final String username;
  final String password;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, username: $username, password: $password}';
  }
}
