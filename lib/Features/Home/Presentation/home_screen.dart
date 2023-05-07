import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Commons/app_images.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/AddMembers/Presentation/add_members_screen.dart';
import 'package:cpscom_admin/Features/Home/Widgets/home_appbar.dart';
import 'package:cpscom_admin/Features/Home/Widgets/home_chat_card.dart';
import 'package:cpscom_admin/Features/Home/Widgets/home_search_bar.dart';
import 'package:cpscom_admin/Features/Login/Presentation/login_screen.dart';
import 'package:cpscom_admin/Utils/app_helper.dart';
import 'package:cpscom_admin/Utils/app_preference.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_floating_action_button.dart';
import 'package:cpscom_admin/Widgets/custom_loader.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Api/firebase_provider.dart';
import '../../../Utils/custom_snack_bar.dart';
import '../../../Widgets/custom_confirmation_dialog.dart';
import '../../../Widgets/custom_text_field.dart';
import '../../Chat/Presentation/chat_screen.dart';
import '../../CreateNewGroup/Presentation/create_new_group_screen.dart';
import '../../MyProfile/Presentation/my_profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var future = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    bool? isAdmin;
    return Container(
      color: AppColors.white,
      child: FutureBuilder(
          future: future,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              default:
                if (snapshot.hasData) {
                  isAdmin = snapshot.data?['isAdmin'];
                  return Scaffold(
                    appBar: CustomAppBar(
                        autoImplyLeading: false,
                        title: AppStrings.appName,
                        actions: [
                          PopupMenuButton(
                            icon: CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.lightGrey,
                              foregroundImage: NetworkImage(
                                  '${AppStrings.imagePath}${snapshot.data?['profile_picture']}'),
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  value: 1,
                                  child: Text(
                                    'My Profile',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(color: AppColors.black),
                                  )),
                              PopupMenuItem(
                                  value: 2,
                                  child: Text(
                                    'Logout',
                                    style: Theme.of(context)
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
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ConfirmationDialog(
                                            title: 'Logout?',
                                            body:
                                                'Are you sure you want to logout?',
                                            positiveButtonLabel: 'Logout',
                                            negativeButtonLabel: 'Cancel',
                                            onPressedPositiveButton: () {
                                              try {
                                                //FirebaseProvider().logout();
                                                context
                                                    .pop(const LoginScreen());
                                              } catch (e) {
                                                customSnackBar(context, '$e',
                                                    AppColors.error);
                                              }
                                            });
                                      });
                              }
                            },
                          ),
                        ]),
                    body: BuildChatList(
                      isAdmin: isAdmin!,
                    ),
                    floatingActionButton: isAdmin == true
                        ? CustomFloatingActionButton(
                            onPressed: () {
                              context.push(const AddMembersScreen(
                                isCameFromHomeScreen: true,
                              ));
                              //context.push(const CreateNewGroupScreen());
                            },
                            iconData: EvaIcons.plus,
                          )
                        : Container(),
                  );
                }
            }
            return Container();
          }),
    );
  }
}

class BuildChatList extends StatefulWidget {
  final bool isAdmin;

  const BuildChatList({Key? key, required this.isAdmin}) : super(key: key);

  @override
  State<BuildChatList> createState() => _BuildChatListState();
}

class _BuildChatListState extends State<BuildChatList> {
  final TextEditingController searchController = TextEditingController();

  var stream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('groups')
      .orderBy('created_at', descending: true)
      .snapshots();

  var groupName = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSizes.kDefaultPadding),
          margin: const EdgeInsets.all(AppSizes.kDefaultPadding),
          decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: const [
                BoxShadow(
                    offset: Offset(7, 7),
                    color: AppColors.lightGrey,
                    blurRadius: 15),
                BoxShadow(
                    offset: Offset(-7, -7),
                    color: AppColors.shimmer,
                    blurRadius: 15)
              ],
              borderRadius:
                  BorderRadius.circular(AppSizes.cardCornerRadius * 3)),
          child: Row(
            children: [
              const Icon(
                EvaIcons.searchOutline,
                size: 22,
                color: AppColors.grey,
              ),
              const SizedBox(
                width: AppSizes.kDefaultPadding,
              ),
              Expanded(
                child: CustomTextField(
                  controller: searchController,
                  hintText: 'Search groups...',
                  onChanged: (value) {
                    setState(() {
                      groupName = value!;
                    });
                  },
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder(
              stream: stream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const CustomLoader();
                  default:
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            'No Groups Found',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              //for search groups
                              var data = snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;
                              if (groupName.isEmpty) {
                                return HomeChatCard(
                                    groupId: snapshot.data!.docs[index].id,
                                    onPressed: () {
                                      context.push(ChatScreen(
                                        groupId: snapshot.data!.docs[index].id,
                                        isAdmin: widget.isAdmin,
                                      ));
                                    },
                                    groupName: snapshot.data!.docs[index]
                                        ['name'],
                                    //this will be last sent message by the user
                                    groupDesc: snapshot.data!.docs[index]['group_description'],
                                    sentTime: AppHelper.getDateFromString(
                                        snapshot.data!.docs[index]
                                            ['created_at']),
                                    imageUrl:
                                        '${AppStrings.imagePath}${snapshot.data!.docs[index]['profile_picture']}');
                              } else if (data['name']
                                  .toLowerCase()
                                  .trim()
                                  .toString()
                                  .startsWith(groupName
                                      .toLowerCase()
                                      .trim()
                                      .toString())) {
                                return HomeChatCard(
                                    groupId: snapshot.data!.docs[index].id,
                                    onPressed: () {
                                      context.push(ChatScreen(
                                        groupId: snapshot.data!.docs[index].id,
                                        isAdmin: widget.isAdmin,
                                      ));
                                    },
                                    groupName: snapshot.data!.docs[index]
                                        ['name'],
                                    // groupDesc: snapshot.data!.docs[index]['group_description'],
                                    sentTime: AppHelper.getDateFromString(
                                        snapshot.data!.docs[index]
                                            ['created_at']),
                                    imageUrl:
                                        '${AppStrings.imagePath}${snapshot.data!.docs[index]['profile_picture']}');
                              }
                              return Container();
                            });
                      }
                    }
                    return Container();
                }
              }),
        ),
      ],
    );
  }
}
