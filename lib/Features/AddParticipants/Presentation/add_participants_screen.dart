import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Widgets/custom_divider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../../Api/firebase_provider.dart';
import '../../../Commons/app_colors.dart';
import '../../../Commons/app_sizes.dart';
import '../../../Models/user.dart';
import '../../../Widgets/custom_app_bar.dart';
import '../../../Widgets/custom_floating_action_button.dart';
import '../../../Widgets/custom_text_field.dart';

class AddParticipantsScreen extends StatefulWidget {
  const AddParticipantsScreen({super.key});

  @override
  State<AddParticipantsScreen> createState() => _AddParticipantsScreenState();
}

class _AddParticipantsScreenState extends State<AddParticipantsScreen> {
  final TextEditingController searchController = TextEditingController();
  List<User> selectedUser = [];
  List<User> users = [];
  Map<int, bool?> itemsSelectedValue = {};
  bool isSelected = false;

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
                      users = data
                              ?.map((element) => User.fromJson(
                                  element.data() as Map<String, dynamic>))
                              .toList() ??
                          [];
                      // remove super admin from users list
                      // super admin and current user will be in the group by default
                      // at the time of creating group
                      for (var i = 0; i < users.length; i++) {
                        print(users[i].isSelected);
                        //remove admin from users list
                        if (users[i].isSuperAdmin == true) {
                          users.remove(users[i]);
                        }
                        //remove current user from users list
                        if (users[i].id ==
                            FirebaseProvider.auth.currentUser!.uid) {
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
                            child: Scrollbar(
                              child: ListView.builder(
                                itemCount: users.length,
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.only(
                                    bottom: AppSizes.kDefaultPadding * 9),
                                itemBuilder: (context, index) {
                                  users[index].isSelected = isSelected;
                                  return _userCard(
                                    users[index],
                                    index,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }
                  return Container();
              }
            }),
        floatingActionButton: selectedUser.isNotEmpty
            ? CustomFloatingActionButton(
                onPressed: () {},
                iconData: EvaIcons.arrowForwardOutline,
              )
            : const SizedBox());
  }

  Widget _userCard(User user, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          users[index].isSelected = !users[index].isSelected;
          print(users[index].isSelected);
          if (users[index].isSelected == true) {
            selectedUser.add(users[index]);
           // users[index].isSelected = false;
            print('add user ----- ${selectedUser.length}');
          } else if (users[index].isSelected == false) {
            selectedUser
                .removeWhere((element) => element.id == users[index].id);
            //users[index].isSelected = true;
            print('remove user ----- ${selectedUser.length}');
          }
        });
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppSizes.cardCornerRadius * 10),
                  child: CachedNetworkImage(
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                    imageUrl: user.profilePicture ?? '',
                    placeholder: (context, url) => const CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.shimmer,
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.shimmer,
                      child: Text(
                        user.name?.substring(0, 1) ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: AppSizes.kDefaultPadding,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name ?? '',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        user.email ?? '',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
                users[index].isSelected   == true
                    ? const Icon(
                        Icons.check_box,
                        size: 20,
                        color: AppColors.primary,
                      )
                    : const Icon(
                        Icons.check_box_outline_blank_rounded,
                        size: 20,
                        color: AppColors.grey,
                      )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 56),
            child: CustomDivider(),
          )
        ],
      ),
    );
  }
}
