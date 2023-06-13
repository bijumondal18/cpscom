import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../Commons/app_colors.dart';
import '../Commons/app_sizes.dart';
import 'custom_text_field.dart';

class CustomSearchbar extends StatefulWidget {
  const CustomSearchbar({super.key});

  @override
  State<CustomSearchbar> createState() => _CustomSearchbarState();
}

class _CustomSearchbarState extends State<CustomSearchbar> {
  //Variable Declarations
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.kDefaultPadding),
      margin: const EdgeInsets.all(AppSizes.kDefaultPadding),
      decoration: BoxDecoration(
          color: AppColors.bg,
          border: Border.all(width: 1, color: AppColors.bg),
          borderRadius: BorderRadius.circular(AppSizes.cardCornerRadius)),
      child: Row(
        children: [
          const Icon(
            EvaIcons.searchOutline,
            size: 22,
            color: AppColors.grey,
          ),
          const SizedBox(
            width: AppSizes.kDefaultPadding,
          ),
          Expanded(
            child: CustomTextField(
              controller: searchController,
              hintText: 'Search groups...',
              minLines: 1,
              maxLines: 1,
              onChanged: (value) {
                // setState(() {
                //   groupName = value!;
                //   groupDesc = value;
                // });
                return null;
              },
              isBorder: false,
            ),
          )
        ],
      ),
    );
  }
}
