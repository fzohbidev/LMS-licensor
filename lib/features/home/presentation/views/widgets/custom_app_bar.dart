import 'package:flutter/material.dart';
import 'package:lms/constants.dart';
import 'package:lms/features/home/presentation/views/widgets/app_bar_grid_and_title.dart';
import 'package:lms/features/home/presentation/views/widgets/app_bar_icons.dart';
import 'package:lms/features/home/presentation/views/widgets/custom_responsive_search_text_field.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kAppBarColor,
      //  padding to avoid overflow
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppBarGridIconAndTitle(),
          ResponsiveTextField(),
          UserOptionsIcons(),
        ],
      ),
    );
  }
}
