import 'package:lms/features/roles_and_premission/data/models/authority.dart';

class UserModel {
  final int id;
  late String username;
  late String password;
  late String email;
  late String firstname;
  late String lastname;
  late String phone;
  late bool enabled;
  late List<Authority> authorities;

  UserModel({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.phone,
    this.enabled = true,
    required this.authorities,
  });

  // Add fromJson and toJson methods if needed for API communication.
  // Factory constructor to create an instance from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    var authoritiesJson = json['authorities'] as List<dynamic>? ?? [];
    List<Authority> authorities = authoritiesJson.map((authJson) {
      if (authJson is Map<String, dynamic>) {
        return Authority.fromJson(authJson);
      } else {
        throw Exception('Invalid authority data format');
      }
    }).toList();

    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      password: "", // Password typically not returned
      email: json['email'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      phone: json['phone'] ?? '',
      enabled: json['enabled'] ?? true,
      authorities: authorities,
    );
  }
}
