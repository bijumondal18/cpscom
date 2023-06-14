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
import 'package:firebase_auth/firebase_auth.dart';
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
  List multipleSelected = [];
  List<Map<String, dynamic>> selectedMembers = [];

  List<QueryDocumentSnapshot> members = [];
  final TextEditingController searchController = TextEditingController();
  var membersName = '';
  var membersEmail = '';
  Map<String, dynamic> data = {};

  var indx;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  // Future<void> addMemberToGroup(
  //   String groupId,
  //   List<Map<String, dynamic>> member,
  // ) async {
  //   var memberList = [];
  //   memberList.add(member);
  //
  //   await firestore
  //       .collection('users')
  //       .doc(auth.currentUser!.uid)
  //       .collection('groups')
  //       .doc(groupId)
  //       .update({
  //     'members': FieldValue.arrayUnion([
  //       {
  //         'id': member['uid'],
  //         'members': memberList,
  //       }
  //     ]) //memberList
  //   });
  // }

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
                                color: AppColors.bg,
                                // boxShadow: const [
                                //   BoxShadow(
                                //       offset: Offset(2, 2),
                                //       color: AppColors.shimmer,
                                //       blurRadius: 10),
                                //   BoxShadow(
                                //       offset: Offset(-2, -2),
                                //       color: AppColors.shimmer,
                                //       blurRadius: 10)
                                // ],
                                borderRadius: BorderRadius.circular(
                                    AppSizes.cardCornerRadius)),
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
                                      setState(() {
                                        membersName = value!;
                                        membersEmail = value;
                                      });
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
                                shrinkWrap: true,
                                itemCount: snapshot.data?.docs.length,
                                padding: const EdgeInsets.only(
                                    bottom: AppSizes.kDefaultPadding * 9),
                                itemBuilder: (context, index) {
                                  members = snapshot.data!.docs;
                                  indx = index;
                                  //for search members
                                  data = members[index].data()
                                      as Map<String, dynamic>;

                                  if (membersName.isEmpty) {
                                    return _customCb(
                                      context,
                                      '${data['profile_picture']}',
                                      data['name'],
                                      data['email'],
                                      selectedIndex.contains(index),
                                      index,
                                    );
                                  } else if (data['name']
                                          .toLowerCase()
                                          .trim()
                                          .toString()
                                          .contains(membersName
                                              .toLowerCase()
                                              .trim()
                                              .toString()) ||
                                      data['email']
                                          .toLowerCase()
                                          .trim()
                                          .toString()
                                          .contains(membersEmail
                                              .toLowerCase()
                                              .trim()
                                              .toString())) {
                                    return _customCb(
                                      context,
                                      '${data['profile_picture']}',
                                      data['name'],
                                      data['email'],
                                      selectedIndex.contains(index),
                                      index,
                                    );
                                  }
                                  return const SizedBox();
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
                if (widget.isCameFromHomeScreen == true) {
                  context.push(CreateNewGroupScreen(
                    membersList: selectedMembers.unique((x) => x['uid']),
                  ));
                } else {
                 // addMemberToGroup(widget.groupId!,selectedMembers);
                  Future.delayed(
                      const Duration(seconds: 2),
                      () => context.pop(GroupInfoScreen(
                            groupId: widget.groupId!,
                          )));
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
                    imageUrl: imageUrl,
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
                 // selectedMembers.unique((x) => x['uid']);
                } else {
                  selectedIndex.add(index);
                  selectedMembers
                      .add(members[index].data() as Map<String, dynamic>);
                  //selectedMembers.unique((x) => x['uid']);
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

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <dynamic>{}; //Set()
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}
