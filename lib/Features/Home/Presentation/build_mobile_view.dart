import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/AddParticipants/Presentation/add_participants_screen.dart';
import 'package:cpscom_admin/Features/Home/Presentation/home_screen.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../../Api/firebase_provider.dart';
import '../../../Widgets/custom_floating_action_button.dart';
import '../../AddMembers/Presentation/add_members_screen.dart';
import '../Components/build_groups_list.dart';
import '../Widgets/home_header.dart';

class BuildMobileView extends StatefulWidget {
  const BuildMobileView({Key? key}) : super(key: key);

  @override
  State<BuildMobileView> createState() => _BuildMobileViewState();
}

class _BuildMobileViewState extends State<BuildMobileView> {
  var future = FirebaseProvider.firestore
      .collection('users')
      .doc(FirebaseProvider.auth.currentUser!.uid)
      .get();

  bool? isAdmin;

  @override
  Widget build(BuildContext context) {
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
                    body:  SafeArea(
                      bottom: false,
                      // child: Column(
                      //   children: [
                      //     HomeHeader(),
                      //     Expanded(child: BuildGroupList()),
                      //   ],
                      // ),
                      child: BuildChatList(
                        isAdmin: isAdmin ?? false,
                      ),
                    ),
                    floatingActionButton: isAdmin == true
                        ? CustomFloatingActionButton(
                            onPressed: () {
                              context.push(const AddMembersScreen(
                                isCameFromHomeScreen: true,
                              ));
                              //context.push(AddParticipantsScreen());
                            },
                            iconData: EvaIcons.plus,
                          )
                        : const SizedBox(),
                  );
                }
            }
            return const SizedBox();
          }),
    );
  }
}
