import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/features/user_groups/data/data_sources/user_group_service.dart';
import 'package:lms/features/user_groups/data/models/group_model.dart';
import 'package:lms/features/user_management/data/models/user_model.dart';
import '../../domain/entities/group.dart';
import 'package:lms/features/user_groups/data/repositories/group_repository.dart';

class GroupForm extends StatefulWidget {
  final GroupModel? group; // Group to edit, if available

  GroupForm({this.group}); // Accept group as optional parameter

  @override
  _GroupFormState createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  late ApiService api;
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  List<UserModel> _selectedUsers = [];
  List<UserModel> _availableUsers = []; // All users available for selection
  List<int> _selectedUserIds = []; // Keep track of selected users' IDs

  @override
  void initState() {
    super.initState();
    final Dio dio = Dio();
    final Api apiInstance = Api(dio);
    api = ApiService(api: apiInstance);

    // Load group data if editing
    if (widget.group != null) {
      _name = widget.group!.name;
      _description = widget.group!.description;
      _selectedUsers = widget.group!.users; // Pre-select users for editing

      // Populate _selectedUserIds based on the selected users
      _selectedUserIds = _selectedUsers.map((user) => user.id).toList();
    }

    // Fetch the available users from the API
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final GroupRepository groupService = GroupRepository(apiService: api);
      _availableUsers = await groupService.fetchUsers(); // Fetch users from API
      setState(() {});
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group != null ? 'Edit Group' : 'Create Group'),
        leading: BackButton(), // Add a back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Group Name'),
                initialValue: _name,
                onSaved: (value) {
                  _name = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                initialValue: _description,
                onSaved: (value) {
                  _description = value ?? '';
                },
              ),
              SizedBox(height: 20),
              // User assignment section
              Text('Assign Users',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: _availableUsers.length,
                  itemBuilder: (context, index) {
                    final user = _availableUsers[index];
                    return CheckboxListTile(
                      title: Text(user.firstname + " " + user.lastname),
                      value: _selectedUsers.contains(user),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected!) {
                            _selectedUsers.add(user);
                            _selectedUserIds.add(user.id); // Update IDs
                          } else {
                            _selectedUsers.remove(user);
                            _selectedUserIds.remove(user.id); // Update IDs
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        GroupModel group = GroupModel(
                          id: widget.group?.id ?? 0,
                          name: _name,
                          description: _description,
                          users: _selectedUsers, // Include selected users
                        );

                        try {
                          final GroupRepository groupService =
                              GroupRepository(apiService: api);

                          if (widget.group == null) {
                            await groupService.createGroup(group);
                            if (_selectedUserIds.isNotEmpty) {
                              await groupService.assignUsersToGroup(
                                  group.id, _selectedUserIds);
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Group created successfully!')),
                            );
                          } else {
                            print("USER IDS SELECTED ==>$_selectedUserIds");
                            await groupService.updateGroup(group);
                            if (_selectedUserIds.isNotEmpty) {
                              await groupService.assignUsersToGroup(
                                  group.id, _selectedUserIds);
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Group updated successfully!')),
                            );
                          }

                          GoRouter.of(context).go(AppRouter.kGroupList);
                        } catch (e) {
                          print("ERROR SAVING GROUP $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to save group: $e')),
                          );
                        }
                      }
                    },
                    child: Text('Save'),
                  ),
                  if (widget.group != null)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        _showDeleteConfirmation(context);
                      },
                      child: Text('Delete'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this group?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () async {
                try {
                  final GroupRepository groupService =
                      GroupRepository(apiService: api);
                  await groupService.deleteGroup(widget.group!.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Group deleted successfully!')),
                  );
                  Navigator.of(dialogContext).pop();
                  GoRouter.of(context).go(AppRouter.kGroupList);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete group: $e')),
                  );
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
