import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../Commons/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final String noImageLabel;

  const ProfileAvatar(
      {super.key, required this.imageUrl, required this.noImageLabel});

  @override
  Widget build(BuildContext context) {
    return imageUrl != ''
        ? Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
                color: AppColors.bg,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      imageUrl,
                    )),
                shape: BoxShape.circle),
          )
        : Container(
            width: 35,
            height: 35,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: AppColors.bg, shape: BoxShape.circle),
            child: Text(
              noImageLabel,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          );
  }
}
