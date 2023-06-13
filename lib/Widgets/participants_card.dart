import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../Commons/app_colors.dart';
import '../Commons/app_sizes.dart';
import '../Commons/app_strings.dart';

class ParticipantsCardWidget extends StatelessWidget {
  final String? profilePicture;
  final String name;
  final String email;
  final bool? isAdmin;
  final bool? isUserAdmin;
  final VoidCallback onDeleteButtonPressed;

  const ParticipantsCardWidget({
    Key? key,
    required this.name,
    required this.email,
    this.isAdmin = false,
    required this.onDeleteButtonPressed,
    this.profilePicture = '',
    this.isUserAdmin = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.cardCornerRadius * 10),
        child: CachedNetworkImage(
          width: 28,
          height: 28,
          fit: BoxFit.cover,
          imageUrl: '${AppStrings.imagePath}$profilePicture',
          placeholder: (context, url) => const CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.bg,
          ),
          errorWidget: (context, url, error) => CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.bg,
            child: Text(
              name.substring(0, 1),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      title: Text(
        name,
        style: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(color: AppColors.black, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        email,
        style: Theme.of(context).textTheme.caption,
      ),
      trailing: isAdmin!
          ? Text(
              'Admin',
              style: Theme.of(context).textTheme.caption!.copyWith(
                  color: AppColors.darkGrey, fontWeight: FontWeight.w400),
            )
          : isUserAdmin!
              ? IconButton(
                  onPressed: () => onDeleteButtonPressed.call(),
                  icon: const Icon(
                    EvaIcons.trash2,
                    color: AppColors.grey,
                    size: 16,
                  ),
                )
              : const SizedBox(),
    );
  }
}
