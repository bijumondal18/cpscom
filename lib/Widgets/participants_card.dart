import 'package:cached_network_image/cached_network_image.dart';
<<<<<<< Updated upstream
import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:cpscom_admin/Models/user.dart';
=======
>>>>>>> Stashed changes
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../Commons/app_colors.dart';
import '../Commons/app_sizes.dart';
import '../Commons/app_strings.dart';

class ParticipantsCardWidget extends StatelessWidget {
<<<<<<< Updated upstream
  final bool? isUserAdmin;
  final bool? isUserSuperAdmin;
  final Map<String, dynamic> member;
  final String? creatorId;
=======
  final String? profilePicture;
  final String name;
  final String email;
  final bool? isAdmin;
  final bool? isUserAdmin;
>>>>>>> Stashed changes
  final VoidCallback onDeleteButtonPressed;

  const ParticipantsCardWidget({
    Key? key,
<<<<<<< Updated upstream
    required this.onDeleteButtonPressed,
    required this.member,
    this.isUserAdmin = false,
    this.creatorId,
    this.isUserSuperAdmin,
=======
    required this.name,
    required this.email,
    this.isAdmin = false,
    required this.onDeleteButtonPressed,
    this.profilePicture = '',
    this.isUserAdmin = false,
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
          imageUrl: member['profile_picture'],
=======
          imageUrl: '${AppStrings.imagePath}$profilePicture',
>>>>>>> Stashed changes
          placeholder: (context, url) => const CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.bg,
          ),
          errorWidget: (context, url, error) => CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.bg,
            child: Text(
<<<<<<< Updated upstream
              member['name'].substring(0, 1),
=======
              name.substring(0, 1),
>>>>>>> Stashed changes
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      title: Text(
<<<<<<< Updated upstream
        member['name'],
=======
        name,
>>>>>>> Stashed changes
        style: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(color: AppColors.black, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
<<<<<<< Updated upstream
        member['email'],
        style: Theme.of(context).textTheme.caption,
      ),
      trailing: creatorId == member['uid'] || member['isSuperAdmin'] == true
=======
        email,
        style: Theme.of(context).textTheme.caption,
      ),
      trailing: isAdmin!
>>>>>>> Stashed changes
          ? Text(
              'Admin',
              style: Theme.of(context).textTheme.caption!.copyWith(
                  color: AppColors.darkGrey, fontWeight: FontWeight.w400),
            )
<<<<<<< Updated upstream
          : (creatorId == FirebaseProvider.auth.currentUser!.uid ||
                  isUserSuperAdmin == true)
=======
          : isUserAdmin!
>>>>>>> Stashed changes
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
