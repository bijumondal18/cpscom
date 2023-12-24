import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Commons/commons.dart';
<<<<<<< Updated upstream
import 'package:cpscom_admin/Features/Home/Presentation/home_screen.dart';
=======
>>>>>>> Stashed changes
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../../Api/firebase_provider.dart';
import '../../../Widgets/custom_floating_action_button.dart';
import '../../AddMembers/Presentation/add_members_screen.dart';
<<<<<<< Updated upstream

=======
import 'home_screen.dart';
>>>>>>> Stashed changes

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

<<<<<<< Updated upstream
  bool isAdmin = false;
=======
  bool? isAdmin;

  final FirebaseProvider firebaseProvider = FirebaseProvider();
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasData) {
                  if(snapshot.data?['isAdmin'] != null){
                    isAdmin = snapshot.data!['isAdmin'];
                  }
                  return Scaffold(
                    body:  SafeArea(
                      bottom: false,
                      child: BuildChatList(
                        isAdmin: isAdmin,
=======
              default:
                if (snapshot.hasData) {
                  isAdmin = snapshot.data?['isAdmin'];
                  return Scaffold(
                    // appBar: AppBar(
                    //   automaticallyImplyLeading: false,
                    //   title: Row(
                    //     children: [
                    //       Image.asset(
                    //         AppIcons.appLogo,
                    //         width: 24,
                    //         height: 24,
                    //         fit: BoxFit.cover,
                    //       ),
                    //       const SizedBox(
                    //         width: AppSizes.kDefaultPadding / 2,
                    //       ),
                    //       Text(
                    //         AppStrings.appName,
                    //         style: Theme.of(context).textTheme.bodyLarge,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    body: SafeArea(
                      child: BuildChatList(
                        isAdmin: isAdmin!,
>>>>>>> Stashed changes
                      ),
                    ),
                    floatingActionButton: isAdmin == true
                        ? CustomFloatingActionButton(
<<<<<<< Updated upstream
                            onPressed: () {
                              context.push(const AddMembersScreen(
                                isCameFromHomeScreen: true,
                              ));
                              //context.push(AddParticipantsScreen());
                            },
                            iconData: EvaIcons.plus,
                          )
=======
                      onPressed: () {
                        context.push(const AddMembersScreen(
                          isCameFromHomeScreen: true,
                        ));
                        //context.push(const CreateNewGroupScreen());
                      },
                      iconData: EvaIcons.plus,
                    )
>>>>>>> Stashed changes
                        : const SizedBox(),
                  );
                }
            }
            return const SizedBox();
          }),
    );
  }
}
