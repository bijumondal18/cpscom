import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../../Api/firebase_provider.dart';
import '../../../Widgets/custom_floating_action_button.dart';
import '../../AddMembers/Presentation/add_members_screen.dart';
import 'home_screen.dart';

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

  final FirebaseProvider firebaseProvider = FirebaseProvider();

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
                      ),
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
                        : const SizedBox(),
                  );
                }
            }
            return const SizedBox();
          }),
    );
  }
}
