import 'package:lms/features/user_groups/data/data_sources/user_group_service.dart';
import 'package:lms/features/user_groups/data/models/group_model.dart';

class GroupRepository {
  final ApiService apiService;

  GroupRepository({required this.apiService});

  Future<List<GroupModel>> getGroups() async {
    return apiService.fetchGroups();
  }

  Future<void> createGroup(GroupModel group) async {
    await apiService.createGroup(group);
  }

  Future<void> updateGroup(GroupModel group) async {
    await apiService.updateGroup(group);
  }

  Future<void> deleteGroup(int groupId) async {
    await apiService.deleteGroup(groupId);
  }
}
