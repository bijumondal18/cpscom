import 'package:cpscom_admin/Widgets/custom_text_field.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../../Commons/app_colors.dart';
import '../../../Commons/app_sizes.dart';

class HomeSearchBar extends StatelessWidget {
  final String? searchHint;

  const HomeSearchBar({Key? key, this.searchHint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.kDefaultPadding),
      decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: const [
            BoxShadow(
                offset: Offset(7, 7),
                color: AppColors.lightGrey,
                blurRadius: 15),
            BoxShadow(
                offset: Offset(-7, -7),
                color: AppColors.shimmer,
                blurRadius: 15)
          ],
          borderRadius: BorderRadius.circular(AppSizes.cardCornerRadius * 3)),
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
              hintText: searchHint??'Search groups...',
            ),
          )
        ],
      ),
    );
  }
}
