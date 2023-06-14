import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../Commons/app_colors.dart';
import '../../../Commons/app_sizes.dart';
import '../../../Models/user.dart';

class AvatarCard extends StatelessWidget {
  final User user;

  const AvatarCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(AppSizes.cardCornerRadius * 10),
                child: CachedNetworkImage(
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                  imageUrl: user.profilePicture ?? '',
                  placeholder: (context, url) => const CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.shimmer,
                  ),
                  errorWidget: (context, url, error) => CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.shimmer,
                    child: Text(
                      user.name?.substring(0, 1) ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 11,
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: 13,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            user.name ?? '',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
