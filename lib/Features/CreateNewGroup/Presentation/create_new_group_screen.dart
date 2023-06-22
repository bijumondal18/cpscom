import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:cpscom_admin/Commons/app_images.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/Home/Presentation/home_screen.dart';
import 'package:cpscom_admin/Utils/custom_snack_bar.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_card.dart';
import 'package:cpscom_admin/Widgets/custom_text_field.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Utils/custom_bottom_modal_sheet.dart';
import '../../../Widgets/custom_floating_action_button.dart';
import '../../GroupInfo/Model/image_picker_model.dart';

class CreateNewGroupScreen extends StatefulWidget {
  final List<Map<String, dynamic>> membersList;

  const CreateNewGroupScreen({Key? key, required this.membersList})
      : super(key: key);

  @override
  State<CreateNewGroupScreen> createState() => _CreateNewGroupScreenState();
}

class _CreateNewGroupScreenState extends State<CreateNewGroupScreen> {
  final TextEditingController grpNameController = TextEditingController();
  final TextEditingController grpDescController = TextEditingController();

  final FirebaseProvider firebaseProvider = FirebaseProvider();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? image;
  String imageUrl = "";

  List<Map<String, dynamic>> finalMembersList = [];

  Future pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxHeight: 512,
          maxWidth: 512,
          imageQuality: 75);
      if (image == null) return;
      final imageTemp = File(image.path);
      // if (kDebugMode) {
      //   print(imageTemp);
      // }
      setState(() => this.image = imageTemp);
      //uploadImage();
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
      // if (kDebugMode) {
      //   print(imageTemp);
      // }
      setState(() => this.image = imageTemp);
      //await uploadImage();
      //uploadFile(imageTemp, DateTime.now().millisecondsSinceEpoch.toString());
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }
  }

  UploadTask uploadFile(File image, String fileName) {
    Reference reference = FirebaseProvider.storage
        .ref()
        .child('group_profile_pictures/$fileName');
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  //
  // Future uploadImage() async {
  //   String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //   UploadTask uploadTask = uploadFile(image!, fileName);
  //   try {
  //     TaskSnapshot snapshot = await uploadTask;
  //     imageUrl = await snapshot.ref.getDownloadURL();
  //     await FirebaseProvider.firestore
  //         .collection('users')
  //         .doc(FirebaseProvider.auth.currentUser!.uid)
  //         .collection('groups')
  //         .doc(widget.groupId)
  //         .update({'profile_picture': imageUrl});
  //     await FirebaseProvider.firestore
  //         .collection('groups')
  //         .doc(widget.groupId)
  //         .update({'profile_picture': imageUrl});
  //     //print('image url - ----------- $imageUrl');
  //   } on FirebaseException catch (e) {}
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
          backgroundColor: AppColors.bg,
          appBar: const CustomAppBar(
            title: 'Create New Group',
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: AppSizes.kDefaultPadding,
                ),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 56,
                        backgroundColor: AppColors.lightGrey,
                        child: image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    AppSizes.cardCornerRadius * 10),
                                child: Image.file(
                                  File(image!.path),
                                  fit: BoxFit.cover,
                                  width: 150,
                                  height: 150,
                                ))
                            : Image.asset(
                                AppImages.groupAvatar,
                                fit: BoxFit.contain,
                                width: 50,
                                height: 50,
                              ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            showCustomBottomSheet(
                                context,
                                '',
                                SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(
                                          AppSizes.kDefaultPadding),
                                      itemCount: imagePickerList.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
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
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: AppSizes.kDefaultPadding *
                                                    2),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 60,
                                                  height: 60,
                                                  padding: const EdgeInsets.all(
                                                      AppSizes.kDefaultPadding),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 1,
                                                          color: AppColors
                                                              .lightGrey),
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
                                AppSizes.kDefaultPadding / 1.3),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: AppColors.lightGrey),
                                color: AppColors.white,
                                shape: BoxShape.circle),
                            child: Image.asset(
                              AppImages.cameraIcon,
                              width: 36,
                              height: 36,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppSizes.kDefaultPadding * 2,
                ),
                CustomCard(
                  margin: const EdgeInsets.symmetric(
                      horizontal: AppSizes.kDefaultPadding),
                  padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Group Title',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: AppColors.black),
                      ),
                      CustomTextField(
                        controller: grpNameController,
                        hintText: 'Group Name',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Group name can\'t be empty';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppSizes.kDefaultPadding,
                ),
                CustomCard(
                  margin: const EdgeInsets.symmetric(
                      horizontal: AppSizes.kDefaultPadding),
                  padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Group Description',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: AppColors.black),
                      ),
                      const SizedBox(
                        height: AppSizes.kDefaultPadding,
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.kDefaultPadding,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  AppSizes.cardCornerRadius / 2),
                              border: Border.all(
                                  width: 1, color: AppColors.lightGrey)),
                          child: CustomTextField(
                            controller: grpDescController,
                            hintText: 'Add Group Description (optional)',
                            minLines: 5,
                            maxLines: 5,
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppSizes.kDefaultPadding * 2,
                ),
                SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(
                          AppSizes.kDefaultPadding,
                        ),
                        child: Text(
                          '${widget.membersList.length} Participants',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder(
                            stream: FirebaseProvider.getAllUsers(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  );
                                case ConnectionState.active:
                                case ConnectionState.done:
                                  if (snapshot.hasData) {
                                    var data = snapshot.data!.docs
                                        .map((e) =>
                                            e.data() as Map<String, dynamic>)
                                        .toList();
                                    return ListView.builder(
                                        itemCount: widget.membersList.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          finalMembersList = widget.membersList
                                              .toSet()
                                              .toList();
                                          for (var i = 0;
                                              i < data.length;
                                              i++) {
                                            // Add super admin to the group
                                            // if admin create the group.
                                            if (data[i]['isSuperAdmin'] ==
                                                true && data[i]['uid'] != auth.currentUser!.uid) {
                                              finalMembersList.add({
                                                "email": data[i]['email'],
                                                "isAdmin": data[i]['isAdmin'],
                                                "isSuperAdmin": data[i]
                                                    ['isSuperAdmin'],
                                                "name": data[i]['name'],
                                                "profile_picture": data[i]
                                                    ['profile_picture'],
                                                "pushToken": data[i]
                                                    ['pushToken'],
                                                "status": data[i]['status'],
                                                "uid": data[i]['uid'],
                                              });
                                            }
                                            // Add current user to the group
                                            if (data[i]['uid'] ==
                                                auth.currentUser!.uid) {
                                              finalMembersList.add({
                                                "email": data[i]['email'],
                                                "isAdmin": data[i]['isAdmin'],
                                                "isSuperAdmin": data[i]
                                                    ['isSuperAdmin'],
                                                "name": data[i]['name'],
                                                "profile_picture": data[i]
                                                    ['profile_picture'],
                                                "pushToken": data[i]
                                                    ['pushToken'],
                                                "status": data[i]['status'],
                                                "uid": data[i]['uid'],
                                              });
                                            }
                                          }
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: AppSizes.kDefaultPadding),
                                            child: SizedBox(
                                              width: 60,
                                              child: Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius
                                                        .circular(AppSizes
                                                                .cardCornerRadius *
                                                            10),
                                                    child: CachedNetworkImage(
                                                        width: 56,
                                                        height: 56,
                                                        fit: BoxFit.cover,
                                                        imageUrl:
                                                            '${widget.membersList[index]['profile_picture']}',
                                                        placeholder: (context,
                                                                url) =>
                                                            const CircleAvatar(
                                                              radius: 40,
                                                              backgroundColor:
                                                                  AppColors
                                                                      .lightGrey,
                                                            ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            CircleAvatar(
                                                              radius: 40,
                                                              backgroundColor:
                                                                  AppColors
                                                                      .lightGrey,
                                                              child: Text(
                                                                widget
                                                                    .membersList[
                                                                        index]
                                                                        ['name']
                                                                    .substring(
                                                                        0, 1)
                                                                    .toString()
                                                                    .toUpperCase(),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText1!
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                              ),
                                                            )),
                                                  ),
                                                  const SizedBox(
                                                    height: AppSizes
                                                            .kDefaultPadding /
                                                        2,
                                                  ),
                                                  Text(
                                                    widget.membersList[index]
                                                        ['name'],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color: AppColors
                                                                .black),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  }
                              }

                              return const SizedBox();
                            }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppSizes.kDefaultPadding * 3,
                ),
              ],
            ),
          ),
          floatingActionButton: CustomFloatingActionButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  FirebaseProvider.createGroup(
                    grpNameController.text,
                    grpDescController.text,
                    imageUrl,
                    finalMembersList.toSet().toList(),
                  );
                  customSnackBar(context, 'Group Created Successfully');
                  context.pushAndRemoveUntil(const HomeScreen());
                } catch (e) {
                  return;
                }
              }
              return;
            },
            iconData: EvaIcons.checkmark,
          )),
    );
  }
}
