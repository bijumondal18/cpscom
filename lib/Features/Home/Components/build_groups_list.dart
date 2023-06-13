import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/Home/Widgets/group_list_item.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Models/group.dart';
import '../../../Widgets/custom_text_field.dart';
import '../../Chat/Presentation/chat_screen.dart';

class BuildGroupList extends StatefulWidget {
  const BuildGroupList({super.key});

  @override
  State<BuildGroupList> createState() => BuildGroupListState();
}

class BuildGroupListState extends State<BuildGroupList> {
  //Variable Declarations
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController searchController = TextEditingController();

  List<Group> groupsList = [];
  List<Group> searchedGroupList = [];

  // Search groups by name
  List<Group> searchGroups(String query) {
    setState(() {
      searchedGroupList = groupsList
          .where((element) => element.name!
              .toLowerCase()
              .toString()
              .contains(query.toLowerCase().toString()))
          .toList();
    });
    return searchedGroupList;
  }

  //Get All Groups List
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllGroups() async* {
    var allGroupsList = firestore
        .collection('users/${auth.currentUser!.uid}/groups')
        .orderBy('created_at', descending: true)
        .snapshots();
    yield* allGroupsList;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  onChanged: (String? value) {
                    searchGroups(value!);
                  },
                  isBorder: false,
                ),
              )
            ],
          ),
        ),
        StreamBuilder(
            stream: getAllGroups(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    final data = snapshot.data?.docs;
                    groupsList = data
                            ?.map((element) => Group.fromJson(
                                element.data() as Map<String, dynamic>))
                            .toList() ??
                        [];
                    if (searchedGroupList.isNotEmpty) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: searchedGroupList.length,
                            shrinkWrap: false,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    // context.push(ChatScreen(
                                    //     group: searchedGroupList[index]));
                                  },
                                  child: GroupListItem(
                                    groupsModel: searchedGroupList[index],
                                  ));
                            }),
                      );
                    } else if (groupsList.isNotEmpty) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: groupsList.length,
                            shrinkWrap: false,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    // context.push(
                                    //     ChatScreen(group: groupsList[index]));
                                  },
                                  child: GroupListItem(
                                    groupsModel: groupsList[index],
                                  ));
                            }),
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No Groups Found',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      );
                    }
                  }
                  return const SizedBox();
              }
            }),
      ],
    );
  }
}
