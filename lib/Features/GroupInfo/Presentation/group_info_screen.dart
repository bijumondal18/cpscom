import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/AddMembers/Presentation/add_members_screen.dart';
import 'package:cpscom_admin/Features/GroupInfo/ChangeGroupDescription/Presentation/chnage_group_description.dart';
import 'package:cpscom_admin/Features/GroupInfo/ChangeGroupTitle/Presentation/change_group_title.dart';
import 'package:cpscom_admin/Utils/app_helper.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_confirmation_dialog.dart';
import 'package:cpscom_admin/Widgets/custom_image_picker.dart';
import 'package:cpscom_admin/Widgets/delete_button.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Commons/app_images.dart';
import '../../../Widgets/custom_loader.dart';

class GroupInfoScreen extends StatefulWidget {
  final QueryDocumentSnapshot groupDetails;
  final bool? isAdmin;

  const GroupInfoScreen({Key? key, required this.groupDetails, this.isAdmin})
      : super(key: key);

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  // var future = FirebaseFirestore.instance
  //     .collection('groups')
  //     .doc(widget.groupDetails.id)
  //     .get(),
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.shimmer,
        appBar: CustomAppBar(
          title: 'Group Info',
          actions: [
            widget.isAdmin == true
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
                            style: Theme.of(context).textTheme.bodyText2,
                          )),
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case 1:
                          context.push(ChangeGroupTitle(
                            groupDetails: widget.groupDetails,
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
                color: AppColors.white,
                padding: const EdgeInsets.all(AppSizes.kDefaultPadding * 2),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 56,
                          backgroundColor: AppColors.lightGrey,
                          foregroundImage: NetworkImage(
                              "${AppStrings.imagePath}${widget.groupDetails['profile_picture']}"),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: widget.isAdmin == true
                              ? InkWell(
                                  onTap: () {
                                    const CustomImagePicker();
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    padding: const EdgeInsets.all(
                                        AppSizes.kDefaultPadding / 1.3),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: AppColors.lightGrey),
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
                      '${widget.groupDetails['name']}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'Group',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: AppSizes.kDefaultPadding,
              ),
              InkWell(
                onTap: () {
                  widget.isAdmin == true
                      ? context.push(ChangeGroupDescription(
                          groupDetails: widget.groupDetails,
                        ))
                      : null;
                },
                child: Container(
                  color: AppColors.white,
                  padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Group Description',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            'Created at: ${AppHelper.getDateFromString(widget.groupDetails['created_at'])}',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: AppSizes.kDefaultPadding,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.groupDetails['group_description'] != ''
                                  ? '${widget.groupDetails['group_description']}:'
                                  : 'Add group description here...',
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(color: AppColors.black),
                            ),
                          ),
                          widget.isAdmin == true
                              ? const Icon(
                                  EvaIcons.arrowIosForward,
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
              const SizedBox(
                height: AppSizes.kDefaultPadding,
              ),
              ParticipantsCard(
                groupDetails: widget.groupDetails,
                isAdmin: widget.isAdmin,
              ),
              const SizedBox(
                height: AppSizes.kDefaultPadding,
              ),
              SafeArea(
                child: widget.isAdmin == true
                    ? DeleteButton(
                        label: 'Delete Group',
                        onPressed: () {
                          ViewDialogs.confirmationDialog(
                              context,
                              'Delete Group?',
                              'Are you sure want to delete this group?',
                              'Confirm',
                              'Cancel');
                        },
                      )
                    : Container(),
              )
            ],
          ),
        ));
  }
}

class ParticipantsCard extends StatelessWidget {
  final QueryDocumentSnapshot groupDetails;
  final bool? isAdmin;

  ParticipantsCard({
    Key? key,
    required this.groupDetails,
    this.isAdmin,
  }) : super(key: key);

  List<dynamic> membersList = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('groups')
            .doc(groupDetails.id)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          membersList = snapshot.data!['members'];
          return Container(
            padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
            color: AppColors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.kDefaultPadding / 1.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${membersList.length} Participants',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      isAdmin == true
                          ? InkWell(
                              onTap: () {
                                context.push(AddMembersScreen(
                                  groupDetails: groupDetails,
                                ));
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: AppColors.buttonGradientColor),
                                child: const Icon(
                                  EvaIcons.plus,
                                  size: 18,
                                  color: AppColors.white,
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppSizes.kDefaultPadding,
                ),
                ListView.builder(
                    itemCount: membersList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: 0,
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.lightGrey,
                          foregroundImage: NetworkImage("${AppStrings.imagePath}${membersList[index]['profile_picture']}"),
                        ),
                        title: Text(
                          "${membersList[index]['name']}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          "${membersList[index]['email']}",
                          style: Theme.of(context).textTheme.caption,
                        ),
                        trailing: membersList[index]['isAdmin'] == true
                            ? Text(
                                'Admin',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w500),
                              )
                            : isAdmin == true
                                ? IconButton(
                                    onPressed: () {
                                      ViewDialogs.confirmationDialog(
                                          context,
                                          'Delete Member?',
                                          'Are you sure want to delete this member from this group?',
                                          'Confirm',
                                          'Cancel');
                                    },
                                    icon: const Icon(
                                      EvaIcons.trash2,
                                      color: AppColors.grey,
                                      size: 16,
                                    ),
                                  )
                                : const SizedBox(),
                      );
                    })
              ],
            ),
          );
        });
  }
}
