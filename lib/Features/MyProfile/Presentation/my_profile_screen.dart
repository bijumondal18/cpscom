import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Commons/app_colors.dart';
import 'package:cpscom_admin/Commons/app_sizes.dart';
import 'package:cpscom_admin/Commons/app_strings.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
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
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: future,
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                default:
                  if (snapshot.hasData) {
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin:
                              const EdgeInsets.all(AppSizes.kDefaultPadding),
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 56,
                            backgroundColor: AppColors.bg,
                            foregroundImage: NetworkImage(
                                '${AppStrings.imagePath}${snapshot.data?['profile_picture']}'),
                          ),
                        ),
                        Text(
                          snapshot.data!['name'],
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          snapshot.data!['email'],
                          style: Theme.of(context).textTheme.bodyText2,
                        )
                      ],
                    );
                  }
              }
              return Container();
            }),
      ),
    );
  }
}
