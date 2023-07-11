import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/AddMembers/Presentation/add_members_screen.dart';
import 'package:cpscom_admin/Features/GroupInfo/ChangeGroupDescription/Presentation/chnage_group_description.dart';
import 'package:cpscom_admin/Features/GroupInfo/ChangeGroupTitle/Presentation/change_group_title.dart';
import 'package:cpscom_admin/Utils/custom_snack_bar.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_card.dart';
import 'package:cpscom_admin/Widgets/custom_confirmation_dialog.dart';
import 'package:cpscom_admin/Widgets/custom_divider.dart';
import 'package:cpscom_admin/Widgets/participants_card.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Commons/app_images.dart';
import '../../../Utils/custom_bottom_modal_sheet.dart';
import '../Model/image_picker_model.dart';

class GroupInfoScreen extends StatefulWidget {
  final String groupId;
  final bool? isAdmin;

  const GroupInfoScreen({Key? key, required this.groupId, this.isAdmin})
      : super(key: key);

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  List<dynamic> membersList = [];

  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  File? image;
  String imageUrl = "";
  String superAdminUid = '';

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
      //uploadFile(imageTemp, DateTime.now().millisecondsSinceEpoch.toString());
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
      //uploadFile(imageTemp, DateTime.now().millisecondsSinceEpoch.toString());
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }
  }

  UploadTask uploadFile(File image, String fileName) {
    Reference reference =
        firebaseStorage.ref().child('group_profile_pictures/$fileName');
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
          .collection('groups')
          .doc(widget.groupId)
          .update({'profile_picture': imageUrl});
      await FirebaseProvider.firestore
          .collection('groups')
          .doc(widget.groupId)
          .update({'profile_picture': imageUrl});
      if (context.mounted) {
        customSnackBar(context, 'Group Image Updated Successfully');
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.message.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseProvider.getGroupDetails(widget.groupId),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    membersList = snapshot.data!['members'];
                    for (var i = 0; i < membersList.length; i++) {
                      if (membersList[i]['isSuperAdmin'] == true) {
                        superAdminUid = membersList[i]['uid'];
                      }
                    }
                    return Scaffold(
                      backgroundColor: AppColors.bg,
                      appBar: CustomAppBar(
                        title: 'Group Info',
                        actions: [
                          snapshot.data!['group_creator_uid'] ==
                                      FirebaseProvider.auth.currentUser!.uid ||
                                  superAdminUid ==
                                      FirebaseProvider.auth.currentUser!.uid
                              ? PopupMenuButton(
                                  icon: const Icon(
                                    EvaIcons.moreVerticalOutline,
                                    color: AppColors.darkGrey,
                                    size: 20,
                                  ),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                        value: 1,
                                        child: Text(
                                          'Change Group Title',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        )),

                                  ],
                                  onSelected: (value) {
                                    switch (value) {
                                      case 1:
                                        context.push(ChangeGroupTitle(
                                          groupId: widget.groupId,
                                        ));
                                        break;

                                    }
                                  },
                                )
                              : Container(),
                        ],
                      ),
                      body: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(
                                  AppSizes.kDefaultPadding * 2),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      imageUrl != ''
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(AppSizes
                                                          .cardCornerRadius *
                                                      10),
                                              child: CachedNetworkImage(
                                                  width: 106,
                                                  height: 106,
                                                  fit: BoxFit.cover,
                                                  imageUrl: imageUrl,
                                                  placeholder: (context, url) =>
                                                      const CircleAvatar(
                                                        radius: 66,
                                                        backgroundColor:
                                                            AppColors.lightGrey,
                                                      ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      CircleAvatar(
                                                        radius: 66,
                                                        backgroundColor:
                                                            AppColors.lightGrey,
                                                        child: Text(
                                                          snapshot.data!['name']
                                                              .substring(0, 1)
                                                              .toString()
                                                              .toUpperCase(),
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headlineLarge!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                      )),
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(AppSizes
                                                          .cardCornerRadius *
                                                      10),
                                              child: CachedNetworkImage(
                                                  width: 106,
                                                  height: 106,
                                                  fit: BoxFit.cover,
                                                  imageUrl:
                                                      '${snapshot.data?['profile_picture']}',
                                                  placeholder: (context, url) =>
                                                      const CircleAvatar(
                                                        radius: 66,
                                                        backgroundColor:
                                                            AppColors.lightGrey,
                                                      ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      CircleAvatar(
                                                        radius: 66,
                                                        backgroundColor:
                                                            AppColors.lightGrey,
                                                        child: Text(
                                                          snapshot.data!['name']
                                                              .substring(0, 1)
                                                              .toString()
                                                              .toUpperCase(),
                                                          style: Theme.of(
                                                                  context)
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
                                        right: 0,
                                        bottom: 0,
                                        child: snapshot.data![
                                                        'group_creator_uid'] ==
                                                    FirebaseProvider.auth
                                                        .currentUser!.uid ||
                                                superAdminUid ==
                                                    FirebaseProvider
                                                        .auth.currentUser!.uid
                                            ? GestureDetector(
                                                onTap: () {
                                                  showCustomBottomSheet(
                                                      context,
                                                      '',
                                                      SizedBox(
                                                        height: 150,
                                                        child: ListView.builder(
                                                            shrinkWrap: true,
                                                            padding:
                                                                const EdgeInsets
                                                                        .all(
                                                                    AppSizes
                                                                        .kDefaultPadding),
                                                            itemCount:
                                                                imagePickerList
                                                                    .length,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  switch (
                                                                      index) {
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
                                                                        width:
                                                                            60,
                                                                        height:
                                                                            60,
                                                                        padding:
                                                                            const EdgeInsets.all(AppSizes.kDefaultPadding),
                                                                        decoration: BoxDecoration(
                                                                            border:
                                                                                Border.all(width: 1, color: AppColors.lightGrey),
                                                                            color: AppColors.white,
                                                                            shape: BoxShape.circle),
                                                                        child: imagePickerList[index]
                                                                            .icon,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            AppSizes.kDefaultPadding /
                                                                                2,
                                                                      ),
                                                                      Text(
                                                                        '${imagePickerList[index].title}',
                                                                        style: Theme.of(context)
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
                                                          color: AppColors
                                                              .lightGrey),
                                                      color: AppColors.white,
                                                      shape: BoxShape.circle),
                                                  child: Image.asset(
                                                    AppImages.cameraIcon,
                                                    width: 36,
                                                    height: 36,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: AppSizes.kDefaultPadding,
                                  ),
                                  Text(
                                    '${snapshot.data!['name']}',
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  const SizedBox(
                                    height: AppSizes.kDefaultPadding / 2,
                                  ),
                                  Text(
                                    'Group \u2022 ${membersList.length} People',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ),
                            (snapshot.data!['group_creator_uid'] !=
                                        FirebaseProvider
                                            .auth.currentUser!.uid &&
                                    superAdminUid !=
                                        FirebaseProvider
                                            .auth.currentUser!.uid &&
                                    snapshot.data!['group_description'] == '')
                                ? const SizedBox()
                                : ((snapshot.data!['group_creator_uid'] ==
                                                FirebaseProvider
                                                    .auth.currentUser!.uid ||
                                            superAdminUid ==
                                                FirebaseProvider
                                                    .auth.currentUser!.uid) &&
                                        snapshot.data!['group_description'] ==
                                            '')
                                    ? GestureDetector(
                                        onTap: () => context.push(
                                            ChangeGroupDescription(
                                                groupId: widget.groupId)),
                                        child: CustomCard(
                                          margin: const EdgeInsets.all(
                                              AppSizes.kDefaultPadding),
                                          padding: const EdgeInsets.all(
                                              AppSizes.kDefaultPadding),
                                          child: Text(
                                            'Add Group Description',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                    color: AppColors.primary,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          snapshot.data!['group_creator_uid'] ==
                                                      FirebaseProvider.auth
                                                          .currentUser!.uid ||
                                                  superAdminUid ==
                                                      FirebaseProvider
                                                          .auth.currentUser!.uid
                                              ? context
                                                  .push(ChangeGroupDescription(
                                                  groupId: widget.groupId,
                                                ))
                                              : null;
                                        },
                                        child: CustomCard(
                                          margin: const EdgeInsets.all(
                                              AppSizes.kDefaultPadding),
                                          padding: const EdgeInsets.all(
                                              AppSizes.kDefaultPadding),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Group Description',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                              const SizedBox(
                                                height:
                                                    AppSizes.kDefaultPadding,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      '${snapshot.data?['group_description']}',
                                                      maxLines: 5,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2!
                                                          .copyWith(
                                                              color: AppColors
                                                                  .black),
                                                    ),
                                                  ),
                                                  snapshot.data?['group_creator_uid'] ==
                                                              FirebaseProvider
                                                                  .auth
                                                                  .currentUser!
                                                                  .uid ||
                                                          superAdminUid ==
                                                              FirebaseProvider
                                                                  .auth
                                                                  .currentUser!
                                                                  .uid
                                                      ? const Icon(
                                                          EvaIcons
                                                              .arrowIosForward,
                                                          size: 24,
                                                          color: AppColors.grey,
                                                        )
                                                      : const SizedBox()
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(
                                      AppSizes.kDefaultPadding),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${membersList.length} Participants',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      snapshot.data?['group_creator_uid'] ==
                                                  FirebaseProvider
                                                      .auth.currentUser!.uid ||
                                              superAdminUid ==
                                                  FirebaseProvider
                                                      .auth.currentUser!.uid
                                          ? InkWell(
                                              onTap: () {
                                                // context.push(const AddParticipantsScreen());
                                                context.push(AddMembersScreen(
                                                  groupId: widget.groupId,
                                                  isCameFromHomeScreen: false,
                                                  existingMembersList:
                                                      membersList,
                                                ));
                                              },
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    gradient: AppColors
                                                        .buttonGradientColor),
                                                child: const Icon(
                                                  EvaIcons.plus,
                                                  size: 18,
                                                  color: AppColors.white,
                                                ),
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                                CustomCard(
                                  margin: const EdgeInsets.all(
                                      AppSizes.kDefaultPadding),
                                  padding: const EdgeInsets.all(
                                      AppSizes.kDefaultPadding),
                                  child: ListView.separated(
                                    itemCount: membersList.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      bool isUserSuperAdmin = false;
                                      if (superAdminUid ==
                                          FirebaseProvider
                                              .auth.currentUser!.uid) {
                                        isUserSuperAdmin = true;
                                      }
                                      return ParticipantsCardWidget(
                                          member: membersList[index],
                                          creatorId: snapshot
                                              .data?['group_creator_uid'],
                                          isUserSuperAdmin: isUserSuperAdmin,
                                          isUserAdmin: widget.isAdmin,
                                          onDeleteButtonPressed: () {
                                            widget.isAdmin == true ||
                                                    superAdminUid ==
                                                        FirebaseProvider.auth
                                                            .currentUser!.uid
                                                ? showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder:
                                                        (BuildContext context) {
                                                      return ConfirmationDialog(
                                                        title: 'Delete Member?',
                                                        body:
                                                            'Are you sure you want to delete this member from this group?',
                                                        onPressedPositiveButton:
                                                            () {
                                                          FirebaseProvider
                                                              .deleteMember(
                                                                  widget
                                                                      .groupId,
                                                                  membersList,
                                                                  index);
                                                          context.pop(
                                                              GroupInfoScreen(
                                                            groupId:
                                                                widget.groupId,
                                                            isAdmin:
                                                                widget.isAdmin,
                                                          ));
                                                        },
                                                      );
                                                    })
                                                : const SizedBox();
                                          });
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return const Padding(
                                        padding: EdgeInsets.only(left: 42),
                                        child: CustomDivider(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: AppSizes.kDefaultPadding,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              }
              return Container();
            }));
  }
}
