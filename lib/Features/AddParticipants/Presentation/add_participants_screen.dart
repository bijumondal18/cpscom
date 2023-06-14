import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Features/AddMembers/Widgets/member_card_widget.dart';
import 'package:cpscom_admin/Widgets/custom_divider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../../Api/firebase_provider.dart';
import '../../../Commons/app_colors.dart';
import '../../../Commons/app_sizes.dart';
import '../../../Models/user.dart';
import '../../../Widgets/custom_app_bar.dart';
import '../../../Widgets/custom_text_field.dart';
import '../Widgets/avatar_card.dart';
// import 'package:cpscom_admin/Models/user.dart' as Users;

class AddParticipantsScreen extends StatefulWidget {
  const AddParticipantsScreen({super.key});

  @override
  State<AddParticipantsScreen> createState() => _AddParticipantsScreenState();
}

class _AddParticipantsScreenState extends State<AddParticipantsScreen> {
  final TextEditingController searchController = TextEditingController();
  List<User> groupUser = [];

  void isSelected(bool selected, User user) {
    setState(() {
      if (selected == true) {
        groupUser.add(user);
        selected = false;
      } else {
        groupUser.remove(user);
        selected = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Add Participants',
      ),
      body: StreamBuilder(
          stream: FirebaseProvider.getAllUsersWithoutCurrentUser(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              default:
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No Participants Found',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    );
                  } else {
                    final data = snapshot.data?.docs;
                    var users = data
                            ?.map((element) => User.fromJson(
                                element.data() as Map<String, dynamic>))
                            .toList() ??
                        [];
                    // remove super admin from users list
                    // super admin and current user will be in the group by default
                    // at the time of creating group
                    for (var i = 0; i < users.length; i++) {
                      if (users[i].isSuperAdmin == true) {
                        users.remove(users[i]);
                      }
                    }
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.kDefaultPadding),
                          margin:
                              const EdgeInsets.all(AppSizes.kDefaultPadding),
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(2, 2),
                                    color: AppColors.lightGrey,
                                    blurRadius: 10),
                                BoxShadow(
                                    offset: Offset(-2, -2),
                                    color: AppColors.lightGrey,
                                    blurRadius: 10)
                              ],
                              borderRadius: BorderRadius.circular(
                                  AppSizes.cardCornerRadius * 10)),
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
                                  hintText: 'Search participants...',
                                  isBorder: false,
                                  onChanged: (String? value) {
                                    // setState(() {
                                    //   membersName = value!;
                                    //   membersEmail = value;
                                    // });
                                    return null;
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              groupUser.isNotEmpty
                                  ? Align(
                                      alignment: Alignment.topCenter,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 75,
                                            color: Colors.white,
                                            child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: groupUser.length,
                                                itemBuilder: (context, index) {
                                                  // if (groupUser[index]
                                                  //         .select ==
                                                  //     true) {
                                                  return InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        groupUser.remove(
                                                            groupUser[index]);
                                                        groupUser[index]
                                                            .select = false;
                                                      });
                                                    },
                                                    child: AvatarCard(
                                                      user: groupUser[index],
                                                    ),
                                                  );
                                                  //}
                                                  return Container();
                                                }),
                                          ),
                                          const SizedBox(
                                            height:
                                                AppSizes.kDefaultPadding / 2,
                                          ),
                                          const CustomDivider(),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              Expanded(
                                child: Scrollbar(
                                  child: ListView.builder(
                                    itemCount: users.length,
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.only(
                                        bottom: AppSizes.kDefaultPadding * 9),
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        return Container(
                                          height: groupUser.isNotEmpty ? 90 : 0,
                                        );
                                      }
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            groupUser.add(users[index]);
                                            // if (users[index].select == true) {
                                            //   groupUser.remove(users[index]);
                                            //   users[index].select == false;
                                            // } else if (users[index].select ==
                                            //     false) {
                                            //   groupUser.add(users[index]);
                                            //   users[index].select == true;
                                            // }
                                          });
                                          print(groupUser.length);
                                        },
                                        child: MemberCardWidget(
                                          member: users[index],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }
                return Container();
            }
          }),
    );
  }
}
