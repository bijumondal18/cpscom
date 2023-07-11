import 'dart:developer';

import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:cpscom_admin/Commons/app_sizes.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_text_field.dart';
import 'package:cpscom_admin/Widgets/full_button.dart';
import 'package:flutter/material.dart';

import '../../Commons/app_colors.dart';

class ReportScreen extends StatefulWidget {
  final Map<String, dynamic> chatMap;
  final String groupId;
  final String groupName;

  const ReportScreen(
      {super.key,
      required this.chatMap,
      required this.groupId,
      required this.groupName});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController _reasonController = TextEditingController();
  String reportById = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    reportById = FirebaseProvider.auth.currentUser!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Report to this user',
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.kDefaultPadding),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppSizes.cardCornerRadius),
                      border: Border.all(width: 1, color: AppColors.bg)),
                  child: CustomTextField(
                    controller: _reasonController,
                    labelText: 'Reason',
                    hintText: 'Please enter a valid reason...',
                    maxLines: 5,
                    minLines: 5,
                    isBorder: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a valid reason to report.';
                      }
                      return null;
                    },
                  ),
                ),
                const Spacer(),
                FullButton(
                    label: 'Submit',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        log('group name - ${widget.groupName} \n group id - ${widget.groupId} \n Report By ID - $reportById  \n report to name -  ${widget.chatMap['sendBy']} \n report to id  -  ${widget.chatMap['sendById']} \n Reason - ${_reasonController.text}');
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
