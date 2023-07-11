import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:cpscom_admin/Commons/route.dart';
import 'package:cpscom_admin/Features/MyProfile/Presentation/my_profile_screen.dart';
import 'package:cpscom_admin/Features/SoftwareLicencesScreen/Presentation/licenses_screen.dart';
import 'package:flutter/material.dart';

import '../../../Commons/app_colors.dart';
import '../../../Commons/app_sizes.dart';

class HomeHeader extends StatefulWidget {
  final List<dynamic>? groupsList;

  const HomeHeader({Key? key, this.groupsList}) : super(key: key);

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final FirebaseProvider firebaseProvider = FirebaseProvider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Chats',
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(color: AppColors.black, fontWeight: FontWeight.w600),
          ),
          Spacer(),
          StreamBuilder(
              stream: firebaseProvider.getCurrentUserDetails(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator.adaptive();
                  default:
                    if (snapshot.hasData) {
                      // bool isAdmin = snapshot.data?['isAdmin'];
                      return GestureDetector(
                        onTap: () => context.push(MyProfileScreen(
                          groupsList: widget.groupsList,
                        )),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              AppSizes.cardCornerRadius * 10),
                          child: CachedNetworkImage(
                              width: 34,
                              height: 34,
                              fit: BoxFit.cover,
                              imageUrl: '${snapshot.data?['profile_picture']}',
                              placeholder: (context, url) => const CircleAvatar(
                                    radius: 16,
                                    backgroundColor: AppColors.bg,
                                  ),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: AppColors.bg,
                                    child: Text(
                                      snapshot.data!['name']
                                          .substring(0, 1)
                                          .toString()
                                          .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                  )),
                        ),
                      );
                    }
                }
                return const SizedBox();
              }),
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              size: 24,
              color: AppColors.darkGrey,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 1,
                  child: Text(
                    'Software Licences',
                    style: Theme.of(context).textTheme.bodyText2,
                  )),
            ],
            onSelected: (value) {
              switch (value) {
                case 1:
                  context.push(const LicenseScreen());
                  break;
              }
            },
          )
        ],
      ),
    );
  }
}
