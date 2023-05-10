import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/AddMembers/Presentation/add_members_screen.dart';
import 'package:cpscom_admin/Features/GroupInfo/ChangeGroupDescription/Presentation/chnage_group_description.dart';
import 'package:cpscom_admin/Features/GroupInfo/ChangeGroupTitle/Presentation/change_group_title.dart';
import 'package:cpscom_admin/Utils/app_helper.dart';
import 'package:cpscom_admin/Utils/custom_snack_bar.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_card.dart';
import 'package:cpscom_admin/Widgets/custom_confirmation_dialog.dart';
import 'package:cpscom_admin/Widgets/custom_divider.dart';
import 'package:cpscom_admin/Widgets/custom_image_picker.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Commons/app_images.dart';
import '../../../Widgets/delete_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bg,
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
          child: StreamBuilder(
              stream: FirebaseProvider.getGroupDetails(widget.groupId),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  default:
                    if (snapshot.hasData) {
                      membersList = snapshot.data!['members'];
                      return Column(
                        children: [
                          Container(
                            //color: AppColors.white,
                            padding: const EdgeInsets.all(
                                AppSizes.kDefaultPadding * 2),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 56,
                                      backgroundColor: AppColors.lightGrey,
                                      foregroundImage: NetworkImage(
                                          "${AppStrings.imagePath}${snapshot.data!['profile_picture']}"),
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
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Text(
                                  'Group \u2022 ${membersList.length} People',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: AppSizes.kDefaultPadding,
                          ),
                          (widget.isAdmin != true &&
                                  snapshot.data!['group_description'] == '')
                              ? const SizedBox()
                              : (widget.isAdmin == true &&
                                      snapshot.data!['group_description'] == '')
                                  ? InkWell(
                                      onTap: () => context.push(
                                          ChangeGroupDescription(
                                              groupId: widget.groupId)),
                                      child: CustomCard(
                                        padding: const EdgeInsets.all(
                                            AppSizes.kDefaultPadding),
                                        child: Text(
                                          'Add Group Description',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        widget.isAdmin == true
                                            ? context
                                                .push(ChangeGroupDescription(
                                                groupId: widget.groupId,
                                              ))
                                            : null;
                                      },
                                      child: CustomCard(
                                        padding: const EdgeInsets.all(
                                            AppSizes.kDefaultPadding),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Group Description',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                                // Text(
                                                //   'Created at: ${AppHelper.getDateFromString(snapshot.data!['created_at'])}',
                                                //   style: Theme.of(context)
                                                //       .textTheme
                                                //       .bodyText2,
                                                // ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: AppSizes.kDefaultPadding,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    snapshot.data![
                                                        'group_description'],
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
                                                widget.isAdmin == true
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
                          const SizedBox(
                            height: AppSizes.kDefaultPadding,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.kDefaultPadding),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${membersList.length} Participants',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    widget.isAdmin == true
                                        ? InkWell(
                                            onTap: () {
                                              context.push(AddMembersScreen(
                                                groupId: widget.groupId,
                                                isCameFromHomeScreen: false,
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
                                padding: const EdgeInsets.all(
                                    AppSizes.kDefaultPadding),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              AppSizes.kDefaultPadding / 1.5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [],
                                      ),
                                    ),
                                    ListView.separated(
                                      itemCount: membersList.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          dense: true,
                                          contentPadding: EdgeInsets.zero,
                                          horizontalTitleGap: 0,
                                          leading: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                AppSizes.cardCornerRadius * 10),
                                            child: CachedNetworkImage(
                                              width: 30,
                                              height: 30,
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  '${AppStrings.imagePath}${membersList[index]['profile_picture']}',
                                              placeholder: (context, url) =>
                                                  const CircleAvatar(
                                                radius: 30,
                                                backgroundColor:
                                                    AppColors.shimmer,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      CircleAvatar(
                                                radius: 30,
                                                backgroundColor:
                                                    AppColors.shimmer,
                                                child: Text(
                                                  membersList[index]['name']
                                                      .substring(0, 1),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            "${membersList[index]['name']}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                    color: AppColors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          subtitle: Text(
                                            "${membersList[index]['email']}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                          trailing: membersList[index]
                                                      ['isAdmin'] ==
                                                  true
                                              ? Text(
                                                  'Admin',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption!
                                                      .copyWith(
                                                          color:
                                                              AppColors.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                )
                                              : widget.isAdmin == true
                                                  ? IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return ConfirmationDialog(
                                                                title:
                                                                    'Delete Member?',
                                                                body:
                                                                    'Are you sure want to delete this member from this group?',
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
                                                                    groupId: widget
                                                                        .groupId,
                                                                    isAdmin: widget
                                                                        .isAdmin,
                                                                  ));
                                                                },
                                                              );
                                                            });
                                                      },
                                                      icon: const Icon(
                                                        EvaIcons.trash2,
                                                        color: AppColors.grey,
                                                        size: 16,
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const Padding(
                                          padding: EdgeInsets.only(left: 42),
                                          child: CustomDivider(),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: AppSizes.kDefaultPadding,
                          ),
                          SafeArea(
                            child: widget.isAdmin == true
                                ? CustomCard(
                                    padding: const EdgeInsets.all(
                                        AppSizes.kDefaultPadding),
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                          AppSizes.kDefaultPadding / 2),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {},
                                            child: Text(
                                              'Clear Chat',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                      color: AppColors.red,
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                          ),
                                          const CustomDivider(
                                            height: 20,
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Text(
                                              'Exit Group',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                      color: AppColors.red,
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                          )
                        ],
                      );
                    }
                }
                return Container();
              }),
        ));
  }
}
