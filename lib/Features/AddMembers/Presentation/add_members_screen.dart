import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/CreateNewGroup/Presentation/create_new_group_screen.dart';
import 'package:cpscom_admin/Features/GroupInfo/Presentation/group_info_screen.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_divider.dart';
import 'package:cpscom_admin/Widgets/custom_floating_action_button.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../../Widgets/custom_text_field.dart';

class AddMembersScreen extends StatefulWidget {
  final String? groupId;
  final bool isCameFromHomeScreen;

  const AddMembersScreen(
      {Key? key, this.groupId, required this.isCameFromHomeScreen})
      : super(key: key);

  @override
  State<AddMembersScreen> createState() => _AddMembersScreenState();
}

class _AddMembersScreenState extends State<AddMembersScreen> {
  var selectedIndex = [];
  List<dynamic> existingMembersList = [];

  List<Map<String, dynamic>> members = [];
  final TextEditingController searchController = TextEditingController();
  var membersName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseProvider.getAllUsers(),
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
                    return Scaffold(
                      appBar: CustomAppBar(
                        title: 'Add Participants',
                        actions: [
                          Padding(
                            padding: const EdgeInsets.all(
                                AppSizes.kDefaultPadding + 6),
                            child: Text(
                                '${selectedIndex.length} / ${snapshot.data!.docs.length}'),
                          )
                        ],
                      ),
                      body: Column(
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
                                      offset: Offset(7, 7),
                                      color: AppColors.lightGrey,
                                      blurRadius: 15),
                                  BoxShadow(
                                      offset: Offset(-7, -7),
                                      color: AppColors.shimmer,
                                      blurRadius: 15)
                                ],
                                borderRadius: BorderRadius.circular(
                                    AppSizes.cardCornerRadius * 3)),
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
                                    onChanged: (value) {
                                      setState(() {
                                        membersName = value!;
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Scrollbar(
                              child: ListView.builder(
                                shrinkWrap: true,
                                //physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data?.docs.length,
                                padding: const EdgeInsets.only(
                                    bottom: AppSizes.kDefaultPadding * 9),
                                itemBuilder: (context, index) {
                                  //for search members
                                  var data = snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;
                                  if (membersName.isEmpty) {
                                    return _customCb(
                                        context,
                                        '${snapshot.data!.docs[index]['profile_picture']}',
                                        snapshot.data!.docs[index]['name'],
                                        snapshot.data!.docs[index]['email'],
                                        selectedIndex.contains(index),
                                        index);
                                  } else if (data['name']
                                      .toLowerCase()
                                      .trim()
                                      .toString()
                                      .startsWith(membersName
                                          .toLowerCase()
                                          .trim()
                                          .toString())) {
                                    return _customCb(
                                        context,
                                        '${snapshot.data!.docs[index]['profile_picture']}',
                                        snapshot.data!.docs[index]['name'],
                                        snapshot.data!.docs[index]['email'],
                                        selectedIndex.contains(index),
                                        index);
                                  }
                                  return const SizedBox();
                                  // print('existing members list - ${existingMembersList[index]['uid']}');
                                  // print('all members - ${snapshot.data?.docs[index].id}');
                                  // if (existingMembersList[index]['uid'] ==
                                  //     snapshot.data!.docs[index].id) {
                                  //   print(existingMembersList.length);
                                  // }
                                  // var d = snapshot.data!.docs.firstWhere(
                                  //     (element) =>
                                  //         element.id ==
                                  //         existingMembersList[index]['uid']);
                                  //
                                  // print(d.id);

                                  // return _customCb(
                                  //     context,
                                  //     '${snapshot.data!.docs[index]['profile_picture']}',
                                  //     snapshot.data!.docs[index]['name'],
                                  //     snapshot.data!.docs[index]['email'],
                                  //     selectedIndex.contains(index),
                                  //     index);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
                return Container();
            }
          }),
      floatingActionButton: selectedIndex.isNotEmpty
          ? CustomFloatingActionButton(
              onPressed: () {
                // for (var i = 0; i < selectedIndex.length; i++) {
                //   members.add({
                //     "name": members[i]['name'],
                //     "id": members[i]['uid'],
                //     "isAdmin": members[i]['isAdmin'],
                //     "email": members[i]['email'],
                //     "profile_picture": members[i]['profile_picture'],
                //   });
                //   print(members.length);
                // }
                if (widget.isCameFromHomeScreen == true) {
                  context.push(CreateNewGroupScreen(membersList: members));
                } else {
                  context.pop(GroupInfoScreen(
                    groupId: widget.groupId!,
                  ));
                }
              },
              iconData: EvaIcons.arrowForwardOutline,
            )
          : const SizedBox(),
    );
  }

  Widget _customCb(BuildContext context, String imageUrl, String name,
      String email, bool isSelected, int index) {
    return Column(
      children: [
        CheckboxListTile(
            title: Row(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppSizes.cardCornerRadius * 10),
                  child: CachedNetworkImage(
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                    imageUrl: '${AppStrings.imagePath}$imageUrl',
                    placeholder: (context, url) => const CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.shimmer,
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.shimmer,
                      child: Text(
                        name.substring(0, 1),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      email,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ],
            ),
            controlAffinity: ListTileControlAffinity.trailing,
            value: selectedIndex.contains(index),
            onChanged: (_) {
              setState(() {
                if (selectedIndex.contains(index)) {
                  selectedIndex.remove(index);
                  //isChecked = false;
                } else {
                  selectedIndex.add(index);
                  // isChecked = true;
                }
              });
            }),
        const Padding(
          padding: EdgeInsets.only(left: 64),
          child: CustomDivider(),
        )
      ],
    );
  }
}
