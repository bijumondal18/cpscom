import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Commons/app_images.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/GroupInfo/Presentation/group_info_screen.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_divider.dart';
import 'package:cpscom_admin/Widgets/custom_floating_action_button.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../../Widgets/custom_loader.dart';

class AddMembersScreen extends StatefulWidget {
  final QueryDocumentSnapshot groupDetails;

  const AddMembersScreen({Key? key, required this.groupDetails})
      : super(key: key);

  @override
  State<AddMembersScreen> createState() => _AddMembersScreenState();
}

class _AddMembersScreenState extends State<AddMembersScreen> {
  bool cbMembers = false;
  var selectedIndex = [];

  var stream = FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Add Participants',
      ),
      body: StreamBuilder(
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
                        'No Participants Found',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    );
                  } else {
                    return Scrollbar(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        padding: const EdgeInsets.only(
                            bottom: AppSizes.kDefaultPadding * 9),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              CheckboxListTile(
                                  title: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: AppColors.shimmer,
                                        backgroundImage: const AssetImage(
                                          AppImages.noImage,
                                        ),
                                        foregroundImage: NetworkImage(
                                            '${AppStrings.imagePath}${snapshot.data!.docs[index]['profile_picture']}'),
                                      ),
                                      const SizedBox(
                                        width: AppSizes.kDefaultPadding,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data!.docs[index]['name'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                          Text(
                                            snapshot.data!.docs[index]['email'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  value: selectedIndex.contains(index),
                                  onChanged: (_) {
                                    setState(() {
                                      if (selectedIndex.contains(index)) {
                                        selectedIndex.remove(index);
                                      } else {
                                        selectedIndex.add(index);
                                      }
                                    });
                                  }),
                              const Padding(
                                padding: EdgeInsets.only(left: 64),
                                child: CustomDivider(
                                  height: 10,
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    );
                  }
                }
                return Container();
            }
          }),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          context.pop(GroupInfoScreen(
            groupDetails: widget.groupDetails,
          ));
        },
        iconData: EvaIcons.arrowForwardOutline,
      ),
    );
  }
}
