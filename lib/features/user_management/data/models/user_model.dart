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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var authoritiesJson = json['authorities'];

    List<Authority> authorities;
    if (authoritiesJson is List) {
      authorities = authoritiesJson.map((authJson) {
        if (authJson is Map<String, dynamic>) {
          return Authority.fromJson(authJson);
        } else if (authJson is int) {
          // Handle case where authority is just an ID
          return Authority(id: authJson);
        } else {
          throw Exception('Invalid authority data format');
        }
      }).toList();
    } else {
      authorities = [];
    }

    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      email: json['email'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      phone: json['phone'] ?? '',
      enabled: json['enabled'] ?? true,
      authorities: authorities,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'enabled': enabled,
      'authorities':
          authorities.map((authority) => authority.toJson()).toList(),
    };
  }
}
