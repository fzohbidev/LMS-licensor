import 'package:lms/features/user_management/data/models/user_model.dart';

abstract class UserRepository {
  Future<void> addUser(UserModel user);
  Future<void> updateUser(UserModel user);
  Future<void> removeUser(String username);
  Future<List<UserModel>> getUsers();
}
