import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:cpscom_admin/Commons/app_colors.dart';
import 'package:cpscom_admin/Commons/app_sizes.dart';
import 'package:cpscom_admin/Commons/app_strings.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_divider.dart';
import 'package:cpscom_admin/Widgets/custom_loader.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  var future = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'My Profile',
      ),
      body: FutureBuilder(
          future: FirebaseProvider.getCurrentUserDetails(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const CustomLoader();
              default:
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding:
                              const EdgeInsets.all(AppSizes.kDefaultPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 46,
                                    backgroundColor: AppColors.bg,
                                    foregroundImage: NetworkImage(
                                        '${AppStrings.imagePath}${snapshot.data!['profile_picture']}'),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: AppSizes.kDefaultPadding),
                                      child: Text(
                                        'Add an optional profile picture',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: AppSizes.kDefaultPadding + 2),
                                child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Edit',
                                      style: Theme.of(context)
                                          .textTheme
                                          .button!
                                          .copyWith(color: AppColors.primary),
                                    )),
                              )
                            ],
                          ),
                        ),
                        const CustomDivider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.kDefaultPadding),
                          child: Column(
                            children: [
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  'Name',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                subtitle: Text(
                                  snapshot.data!['name'],
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              const CustomDivider(),
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  'Email',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                subtitle: Text(
                                  snapshot.data!['email'],
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              const CustomDivider(),
                            ],
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.kDefaultPadding),
                          title: Text(
                            'Status',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          subtitle: Text(
                            snapshot.data!['status'],
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          trailing: const Icon(
                            EvaIcons.arrowIosForward,
                            color: AppColors.grey,
                            size: 24,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.kDefaultPadding),
                          child: CustomDivider(),
                        ),
                      ],
                    ),
                  );
                }
            }
            return Center(
                child: Text(
              'Error getting profile',
              style: Theme.of(context).textTheme.bodyText2,
            ));
          }),
    );
  }
}
