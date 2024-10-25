import 'package:flutter/material.dart';
import 'package:lms/core/functions/get_responsive_font_size.dart';

Widget buildListTile(
    {required IconData icon,
    String? title,
    required VoidCallback onTap,
    Widget? trailing,
    required BuildContext context}) {
  return ListTile(
    title: Row(
      children: [
        Icon(icon),
        const SizedBox(width: 5),
        Text(
          title ?? '',
          style: TextStyle(
              fontSize: getResponsiveFontSize(context, baseFontSize: 14)),
        ),
      ],
    ),
    trailing: trailing,
    onTap: onTap,
  );
}

Widget buildExpansionTile(
    {required IconData icon,
    String? title,
    required List<Widget> children,
    required BuildContext context}) {
  return ExpansionTile(
    title: Row(
      children: [
        Icon(icon),
        const SizedBox(width: 5),
        Text(
          title ?? '',
          style: TextStyle(
              fontSize: getResponsiveFontSize(context, baseFontSize: 14)),
        ),
      ],
    ),
    children: children,
  );
}
