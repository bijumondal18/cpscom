import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:cpscom_admin/Commons/app_colors.dart';
import 'package:cpscom_admin/Commons/app_sizes.dart';
import 'package:cpscom_admin/Commons/route.dart';
import 'package:cpscom_admin/Features/Login/Presentation/login_screen.dart';
import 'package:cpscom_admin/Features/UpdateUserStatus/Presentation/update_user_status_screen.dart';
import 'package:cpscom_admin/Utils/app_preference.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_divider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Commons/app_images.dart';
import '../../../Utils/custom_bottom_modal_sheet.dart';
import '../../../Widgets/custom_confirmation_dialog.dart';
import '../../GroupInfo/Model/image_picker_model.dart';

class MyProfileScreen extends StatefulWidget {
  final List<dynamic>? groupsList;

  const MyProfileScreen({Key? key, this.groupsList}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final AppPreference preference = AppPreference();
  final FirebaseProvider firebaseProvider = FirebaseProvider();

  File? image;
  String imageUrl = "";

  Future pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxHeight: 512,
          maxWidth: 512,
          imageQuality: 75);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
      uploadImage();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }
  }

  Future pickImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          maxHeight: 512,
          maxWidth: 512,
          imageQuality: 75);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
      await uploadImage();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }
  }

  UploadTask uploadFile(File image, String fileName) {
    Reference reference =
        FirebaseProvider.storage.ref().child('user_profile_pictures/$fileName');
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future uploadImage() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = uploadFile(image!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      await FirebaseProvider.firestore
          .collection('users')
          .doc(FirebaseProvider.auth.currentUser!.uid)
          .update({'profile_picture': imageUrl});

      // Update user profile picture to firestore, i.e. group-> groupID -> members
      // if (widget.groupsList!.isNotEmpty) {
      //   Map<int, List<dynamic>> testtable = {};
      //
      //   for (var i = 0; i < widget.groupsList!.length; i++) {
      //     var data = widget.groupsList![i].data() as Map<String, dynamic>;
      //     data['members'].forEach((element) async {
      //       if (element['uid'] == FirebaseProvider.auth.currentUser!.uid) {
      //         testtable.update(data.length, (value){
      //           log('${value.length}');
      //           return value;
      //         });
      //         //log('${element['profile_picture']}');
      //         // log('${element['profile_picture']}');
      //         // await FirebaseProvider.firestore
      //         //     .collection('groups')
      //         //     .doc(data['id'])
      //         //     .update({'members': FieldValue.arrayRemove(element)});
      //       }
      //     });
      //   }
      // }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.message.toString());
      }
    }
  }

  @override
  void initState() {
    log('final groups list in profile screen --------- ${widget.groupsList?.length}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Profile',
        actions: [
          TextButton(
              onPressed: () => showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext dialogContext) {
                    return ConfirmationDialog(
                        title: 'Logout?',
                        body: 'Are you sure you want to logout?',
                        positiveButtonLabel: 'Logout',
                        negativeButtonLabel: 'Cancel',
                        onPressedPositiveButton: () async {
                          await FirebaseProvider.logout();
                          await preference.setIsLoggedIn(false);
                          await preference.clearPreference();
                          context.pushAndRemoveUntil(const LoginScreen());
                        });
                  }),
              child: Row(
                children: [
                  const Icon(
                    EvaIcons.logOutOutline,
                    color: AppColors.red,
                    size: 18,
                  ),
                  const SizedBox(
                    width: AppSizes.kDefaultPadding / 3,
                  ),
                  Text(
                    'Logout',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: AppColors.red, fontWeight: FontWeight.w500),
                  ),
                ],
              ))
        ],
      ),
      body: StreamBuilder(
          stream: firebaseProvider.getCurrentUserDetails(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              case ConnectionState.active:
              case ConnectionState.done:
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
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            AppSizes.cardCornerRadius * 10),
                                        child: CachedNetworkImage(
                                            width: 106,
                                            height: 106,
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                '${snapshot.data?['profile_picture']}',
                                            placeholder: (context, url) =>
                                                const CircleAvatar(
                                                  radius: 66,
                                                  backgroundColor: AppColors.bg,
                                                ),
                                            errorWidget: (context, url,
                                                    error) =>
                                                CircleAvatar(
                                                  radius: 66,
                                                  backgroundColor: AppColors.bg,
                                                  child: Text(
                                                    snapshot.data!['name']
                                                        .substring(0, 1)
                                                        .toString()
                                                        .toUpperCase(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                  ),
                                                )),
                                      ),
                                      Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              showCustomBottomSheet(
                                                  context,
                                                  '',
                                                  SizedBox(
                                                    height: 150,
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        padding: const EdgeInsets
                                                                .all(
                                                            AppSizes
                                                                .kDefaultPadding),
                                                        itemCount:
                                                            imagePickerList
                                                                .length,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              switch (index) {
                                                                case 0:
                                                                  pickImageFromGallery();
                                                                  break;
                                                                case 1:
                                                                  pickImageFromCamera();
                                                                  break;
                                                              }
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .only(
                                                                  left: AppSizes
                                                                          .kDefaultPadding *
                                                                      2),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    width: 60,
                                                                    height: 60,
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        AppSizes
                                                                            .kDefaultPadding),
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                            width:
                                                                                1,
                                                                            color: AppColors
                                                                                .lightGrey),
                                                                        color: AppColors
                                                                            .white,
                                                                        shape: BoxShape
                                                                            .circle),
                                                                    child: imagePickerList[
                                                                            index]
                                                                        .icon,
                                                                  ),
                                                                  const SizedBox(
                                                                    height:
                                                                        AppSizes.kDefaultPadding /
                                                                            2,
                                                                  ),
                                                                  Text(
                                                                    '${imagePickerList[index].title}',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyMedium,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                  ));
                                            },
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              padding: const EdgeInsets.all(
                                                  AppSizes.kDefaultPadding /
                                                      1.3),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color:
                                                          AppColors.lightGrey),
                                                  color: AppColors.white,
                                                  shape: BoxShape.circle),
                                              child: Image.asset(
                                                AppImages.cameraIcon,
                                                width: 36,
                                                height: 36,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ))
                                    ],
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
                            ],
                          ),
                        ),
                        const CustomDivider(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.kDefaultPadding),
                          child: Column(
                            children: [
                              ListTile(
                                dense: true,
                                horizontalTitleGap: 0,
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(
                                  EvaIcons.person,
                                  color: AppColors.grey,
                                  size: 20,
                                ),
                                title: Text(
                                  'Name',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                subtitle: Text(
                                  snapshot.data!['name'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontWeight: FontWeight.w400),
                                ),
                              ),
                              const CustomDivider(),
                              ListTile(
                                dense: true,
                                horizontalTitleGap: 0,
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(
                                  EvaIcons.email,
                                  color: AppColors.grey,
                                  size: 20,
                                ),
                                title: Text(
                                  'Email',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                subtitle: Text(
                                  snapshot.data!['email'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontWeight: FontWeight.w400),
                                ),
                              ),
                              const CustomDivider(),
                            ],
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            context.push(const UpdateUserStatusScreen());
                          },
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.kDefaultPadding),
                          horizontalTitleGap: 0,
                          leading: const Icon(
                            EvaIcons.info,
                            color: AppColors.grey,
                            size: 20,
                          ),
                          title: Text(
                            'Status',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          subtitle: Text(
                            snapshot.data!['status'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontWeight: FontWeight.w400),
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
