class UserModel {
  final String id;
  final String email;
  final String name;
  final String? token;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // Soporta 'id', '_id' o 'userId'
      id: (json['id'] ?? json['_id'] ?? json['userId'] ?? '').toString(),
      email: json['email'] ?? '',
      // Soporta 'name', 'nombre' o 'username'
      name: json['name'] ?? json['nombre'] ?? json['username'] ?? 'Usuario',
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'token': token,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
    );
  }
}
