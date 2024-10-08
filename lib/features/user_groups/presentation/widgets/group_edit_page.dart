import 'package:flutter/material.dart';
import 'package:lms/features/user_groups/data/models/group_model.dart';
import '../widgets/group_form.dart';

class GroupEditPage extends StatelessWidget {
  final GroupModel group;

  GroupEditPage({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GroupForm(group: group), // Pass the group to the form
      ),
    );
  }
}
