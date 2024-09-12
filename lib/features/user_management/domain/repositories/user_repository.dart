import 'package:lms/features/user_management/data/models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getUserProfile(String username);
  Future<String> updateUserProfile(UserModel userModel);
}
