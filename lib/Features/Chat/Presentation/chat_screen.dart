import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/GroupInfo/Presentation/group_info_screen.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_text_field.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../GroupMedia/Presentation/group_media_screen.dart';

class ChatScreen extends StatefulWidget {
  final String groupId;
  bool? isAdmin;

  ChatScreen({Key? key, required this.groupId, this.isAdmin}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController msgController = TextEditingController();

  List<dynamic> membersList = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('groups')
            .doc(widget.groupId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            default:
              if (snapshot.hasData) {
                membersList = snapshot.data!['members'];
                for (var i = 0; i < membersList.length; i++) {
                  if (membersList[i]['uid'] ==
                      FirebaseAuth.instance.currentUser!.uid) {
                    i = membersList.indexWhere((element) =>
                        element['uid'] ==
                        FirebaseAuth.instance.currentUser!.uid);
                    widget.isAdmin = membersList[i]['isAdmin'];
                  }
                }
                return Scaffold(
                  backgroundColor: AppColors.shimmer,
                  appBar: CustomAppBar(
                    title: snapshot.data!['name'],
                    actions: [
                      PopupMenuButton(
                        icon: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.lightGrey,
                          foregroundImage: NetworkImage(
                              "${AppStrings.imagePath}${snapshot.data!['profile_picture']}"),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value: 1,
                              child: Text(
                                'Group Info',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(color: AppColors.black),
                              )),
                          PopupMenuItem(
                              value: 2,
                              child: Text(
                                'Group Media',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(color: AppColors.black),
                              )),
                          PopupMenuItem(
                              value: 3,
                              child: Text(
                                'Mute Notification',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(color: AppColors.black),
                              )),
                          PopupMenuItem(
                              value: 4,
                              child: Text(
                                'Clear Chat',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(color: AppColors.black),
                              )),
                        ],
                        onSelected: (value) {
                          switch (value) {
                            case 1:
                              context.push(GroupInfoScreen(
                                groupId: widget.groupId,
                                isAdmin: widget.isAdmin
                              ));
                              break;
                            case 2:
                              context.push(const GroupMediaScreen());
                              break;
                            case 4:
                              // ViewDialogs.confirmationDialog(
                              //     context,
                              //     'Clear this chat?',
                              //     'Are you sure want to clear this chat?',
                              //     'Clear Chat',
                              //     'Cancel');
                              break;
                          }
                        },
                      ),
                    ],
                  ),
                  body: const _BuildChatList(),
                  bottomSheet: SafeArea(
                    bottom: true,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(-5, -5),
                              color: AppColors.lightGrey,
                              blurRadius: 10)
                        ],
                      ),
                      padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.kDefaultPadding),
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(
                                      AppSizes.cardCornerRadius * 3),
                                  border: Border.all(
                                      width: 0.3, color: AppColors.secondary)),
                              child: CustomTextField(
                                controller: msgController,
                                hintText: 'Type here...',
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: AppSizes.kDefaultPadding,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppColors.buttonGradientColor),
                            child: const Icon(
                              EvaIcons.navigation2,
                              color: AppColors.white,
                              size: 24,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
          }
          return Container();
        });
  }
}

class _BuildChatList extends StatefulWidget {
  const _BuildChatList({Key? key}) : super(key: key);

  @override
  State<_BuildChatList> createState() => _BuildChatListState();
}

class _BuildChatListState extends State<_BuildChatList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 30,
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            child: Text('dbqjdjsd'),
          );
        });
  }
}
