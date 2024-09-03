import 'package:lms/core/utils/api.dart';
import 'package:lms/features/auth/data/models/user_model.dart';
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

String jwtToken = '';

abstract class AuthRemoteDataSource {
  Future<void> loginUser({String username, String password});
  Future<void> registerUser(
      {String firstName,
      String lastName,
      String username,
      String password,
      String phone,
      String email});
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final Api api;

  AuthRemoteDataSourceImpl({required this.api});

  @override
  Future<void> loginUser({String username = '', String password = ''}) async {
    var result = await api.post(
      endPoint: "api/auth/signin",
      body: {
        "username": username,
        "password": password,
      },
    );
    userRole = result['roles'];
    print(userRole);
    // Save the JWT token using SharedPreferences
    jwtToken = result['jwtToken'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', result['jwtToken']);
  }

  @override
  Future<void> registerUser(
      {String firstName = '',
      String lastName = '',
      String username = '',
      String password = '',
      String phone = '',
      String email = ''}) async {
    User user = User(
        firstName: firstName,
        lastName: lastName,
        username: username,
        password: password,
        phone: phone,
        email: email,
        enabled: true,
        authorityIDs: [1]);
    var result = await api.post(
      endPoint: "api/auth/signup",
      body: user.toMap(),
    );
  }
}
