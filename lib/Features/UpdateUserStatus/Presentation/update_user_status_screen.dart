import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/MyProfile/Presentation/my_profile_screen.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Utils/custom_snack_bar.dart';
import '../../../Widgets/custom_text_field.dart';
import '../../../Widgets/full_button.dart';

class UpdateUserStatusScreen extends StatefulWidget {
  const UpdateUserStatusScreen({Key? key}) : super(key: key);

  @override
  State<UpdateUserStatusScreen> createState() => _UpdateUserStatusScreenState();
}

class _UpdateUserStatusScreenState extends State<UpdateUserStatusScreen> {
  final TextEditingController statusController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: const CustomAppBar(
          title: 'Enter New Status',
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
              color: AppColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Status',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: AppColors.black),
                  ),
                  const SizedBox(
                    height: AppSizes.kDefaultPadding,
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                          default:
                            if (snapshot.hasData) {
                              statusController.text = snapshot.data!['status'];
                              return CustomTextField(
                                controller: statusController,
                                hintText: 'Add Status',
                                autoFocus: true,
                              );
                            }
                        }
                        return const SizedBox();
                      })
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.kDefaultPadding * 2),
                child: Column(
                  children: [
                    FullButton(
                        label: 'Ok'.toUpperCase(),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({"status": statusController.text}).then(
                                    (value) {
                              customSnackBar(
                                context,
                                'Status Updated Successfully',
                              );
                              context.pop(const MyProfileScreen());
                            });
                          }
                        }),
                    Container(
                      alignment: Alignment.center,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              maximumSize:
                                  const Size.fromHeight(AppSizes.buttonHeight)),
                          onPressed: () {
                            context.pop(const MyProfileScreen());
                          },
                          child: Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText1,
                          )),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
