import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/Home/Presentation/build_desktop_view.dart';
import 'package:cpscom_admin/Features/Home/Presentation/build_mobile_view.dart';
import 'package:cpscom_admin/Features/Home/Presentation/build_tablet_view.dart';
import 'package:cpscom_admin/Features/Home/Widgets/home_chat_card.dart';
import 'package:cpscom_admin/Features/Home/Widgets/home_header.dart';
import 'package:cpscom_admin/Utils/app_helper.dart';
import 'package:cpscom_admin/Widgets/custom_divider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../../Widgets/custom_text_field.dart';
import '../../../Widgets/responsive.dart';
import '../../Chat/Presentation/chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BuildMobileView();
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
  String groupName = '';
  String groupDesc = '';
  String sentTime = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Responsive.isMobile(context) ? const HomeHeader() : const SizedBox(),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSizes.kDefaultPadding),
          margin: const EdgeInsets.all(AppSizes.kDefaultPadding),
          decoration: BoxDecoration(
              color: AppColors.bg,
              border: Border.all(width: 1, color: AppColors.bg),
              borderRadius: BorderRadius.circular(AppSizes.cardCornerRadius)),
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
                  minLines: 1,
                  maxLines: 1,
                  onChanged: (value) {
                    setState(() {
                      groupName = value!;
                      groupDesc = value;
                    });
                    return null;
                  },
                  isBorder: false,
                ),
              )
            ],
          ),
        ),
        Responsive.isMobile(context) ? const SizedBox() : const CustomDivider(),
        Expanded(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: StreamBuilder(
                stream: FirebaseProvider.getAllGroups(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    default:
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text(
                              'No Groups Found',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                          );
                        } else {
                          return Scrollbar(
                            child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(
                                    top: AppSizes.kDefaultPadding),
                                itemBuilder: (context, index) {
                                  //for search groups
                                  var data = snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;
                                  sentTime =
                                      AppHelper.getStringTimeFromTimestamp(
                                          data['created_at']);
                                  if (groupName.isEmpty && groupDesc.isEmpty) {
                                    return HomeChatCard(
                                        groupId: snapshot.data!.docs[index].id,
                                        onPressed: () {
                                          context.push(ChatScreen(
                                            groupId:
                                                snapshot.data!.docs[index].id,
                                            isAdmin: widget.isAdmin,
                                          ));
                                        },
                                        groupName: snapshot.data!.docs[index]
                                            ['name'],
                                        groupDesc: snapshot.data!.docs[index]
                                            ['group_description'],
                                        sentTime: sentTime,
                                        imageUrl:
                                            '${snapshot.data!.docs[index]['profile_picture']}');
                                  } else if (data['name']
                                          .toLowerCase()
                                          .trim()
                                          .toString()
                                          .contains(groupName
                                              .toLowerCase()
                                              .trim()
                                              .toString()) ||
                                      data['group_description']
                                          .toLowerCase()
                                          .trim()
                                          .toString()
                                          .contains(groupName
                                              .toLowerCase()
                                              .trim()
                                              .toString())) {
                                    return HomeChatCard(
                                        groupId: snapshot.data!.docs[index].id,
                                        onPressed: () {
                                          // context.push(ChatScreen(
                                          //   groupId:
                                          //       snapshot.data!.docs[index].id,
                                          //   isAdmin: widget.isAdmin,
                                          // ));
                                        },
                                        groupName: snapshot.data!.docs[index]
                                            ['name'],
                                        groupDesc: snapshot.data!.docs[index]
                                            ['group_description'],
                                        sentTime: sentTime,
                                        imageUrl:
                                            '${snapshot.data!.docs[index]['profile_picture']}');
                                  }
                                  return const SizedBox();
                                }),
                          );
                        }
                      }
                      return const SizedBox();
                  }
                }),
          ),
        ),
      ],
    );
  }
}
