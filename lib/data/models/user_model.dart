import 'dart:convert';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String token;
  final String createdAt;
  final String modifiedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
    required this.createdAt,
    required this.modifiedAt,
  });

  // Convert a Map to a UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      token: map['token'] ?? '',
      createdAt: map['createdAt'] ?? '',
      modifiedAt: map['modifiedAt'] ?? '',
    );
  }

  // Convert a UserModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'token': token,
      'createdAt': createdAt,
      'modifiedAt': modifiedAt,
    };
  }

  String toJson()=>jsonEncode(toMap());

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return id == other.id &&
        email == other.email &&
        name == other.name &&
        token == other.token &&
        createdAt == other.createdAt &&
        modifiedAt == other.modifiedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    email.hashCode ^
    createdAt.hashCode ^
    modifiedAt.hashCode;
  }
}
