import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/MyProfile/Presentation/my_profile_screen.dart';
import 'package:cpscom_admin/Widgets/custom_confirmation_dialog.dart';
import 'package:cpscom_admin/Widgets/custom_divider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Commons/app_icons.dart';

class HomeAppBar extends StatelessWidget {
  bool? isAdmin;

  HomeAppBar({Key? key, this.isAdmin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var future = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    return Column(
      children: [
        Container(
          height: AppSizes.appBarHeight,
          decoration: const BoxDecoration(
            color: AppColors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: AppSizes.kDefaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  AppIcons.appLogo,
                  width: 34,
                  height: 34,
                ),
                Text(
                  AppStrings.appName,
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyText1,
                ),
                FutureBuilder(
                    future: future,
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        default:
                          if (snapshot.hasData) {
                            isAdmin = snapshot.data!['isAdmin'];
                            return PopupMenuButton(
                              icon: CircleAvatar(
                                radius: 24,
                                backgroundColor: AppColors.lightGrey,
                                foregroundImage: NetworkImage(
                                    '${AppStrings.imagePath}${snapshot
                                        .data?['profile_picture']}'),
                              ),
                              itemBuilder: (context) =>
                              [
                                PopupMenuItem(
                                    value: 1,
                                    child: Text(
                                      'My Profile',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(color: AppColors.black),
                                    )),
                                PopupMenuItem(
                                    value: 2,
                                    child: Text(
                                      'Logout',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(color: AppColors.black),
                                    ))
                              ],
                              onSelected: (value) {
                                switch (value) {
                                  case 1:
                                    context.push(const MyProfileScreen());
                                    break;
                                  case 2:
                                    ViewDialogs.confirmationDialog(
                                        context,
                                        'Logout?',
                                        'Are you sure you want to logout?',
                                        'Logout',
                                        'Cancel');
                                    //FirebaseProvider().logout();
                                    // context.pushReplacement(const LoginScreen());
                                    break;
                                }
                              },
                            );
                          }
                      }
                      return Container();
                    })
              ],
            ),
          ),
        ),
        const CustomDivider()
      ],
    );
  }
}
