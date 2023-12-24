<<<<<<< Updated upstream
import 'dart:developer';
=======
import 'dart:io';
>>>>>>> Stashed changes

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:cpscom_admin/Commons/route.dart';
import 'package:cpscom_admin/Features/MyProfile/Presentation/my_profile_screen.dart';
<<<<<<< Updated upstream
import 'package:cpscom_admin/Features/SoftwareLicencesScreen/Presentation/licenses_screen.dart';
=======
>>>>>>> Stashed changes
import 'package:flutter/material.dart';

import '../../../Commons/app_colors.dart';
import '../../../Commons/app_sizes.dart';

class HomeHeader extends StatefulWidget {
<<<<<<< Updated upstream
  final List<dynamic>? groupsList;

  const HomeHeader({Key? key, this.groupsList}) : super(key: key);
=======
  const HomeHeader({Key? key}) : super(key: key);
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
          Spacer(),
=======
>>>>>>> Stashed changes
          StreamBuilder(
              stream: firebaseProvider.getCurrentUserDetails(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
<<<<<<< Updated upstream
                    return const CircularProgressIndicator.adaptive();
=======
                    return  const CircularProgressIndicator.adaptive();
>>>>>>> Stashed changes
                  default:
                    if (snapshot.hasData) {
                      // bool isAdmin = snapshot.data?['isAdmin'];
                      return GestureDetector(
<<<<<<< Updated upstream
                        onTap: () => context.push(MyProfileScreen(
                          groupsList: widget.groupsList,
                        )),
=======
                        onTap: () => context.push(const MyProfileScreen()),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
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
=======
>>>>>>> Stashed changes
        ],
      ),
    );
  }
}
