import 'package:cpscom_admin/Commons/commons.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../Commons/app_colors.dart';
import 'custom_divider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool? autoImplyLeading;

  const CustomAppBar({
    Key? key,
    this.title,
    this.actions,
    this.autoImplyLeading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AppBar(
            automaticallyImplyLeading: autoImplyLeading!,
            actions: actions,
            leading: autoImplyLeading == true ? IconButton(
              icon: const Icon(
                EvaIcons.arrowBack,
                color: AppColors.black,
                size: 24,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ): Container(),
            title: Text(
              title ?? '',
            ),
            // Expanded(
            //   child: Row(
            //     children: [
            //       isOnChatScreen == true
            //           ? const CircleAvatar(
            //               radius: 15,
            //               backgroundColor: AppColors.lightGrey,
            //             )
            //           : Container(),
            //       isOnChatScreen == true
            //           ? const SizedBox(
            //               width: AppSizes.kDefaultPadding,
            //             )
            //           : Container(),
            //       Text(
            //         title ?? '',
            //       ),
            //     ],
            //   ),
            // ),
          ),
        ),
        const CustomDivider()
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
