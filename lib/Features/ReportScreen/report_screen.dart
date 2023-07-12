import 'dart:developer';

import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:cpscom_admin/Commons/app_sizes.dart';
import 'package:cpscom_admin/Commons/route.dart';
import 'package:cpscom_admin/Features/ReportScreen/Bloc/user_report_bloc.dart';
import 'package:cpscom_admin/Utils/custom_snack_bar.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_text_field.dart';
import 'package:cpscom_admin/Widgets/full_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Commons/app_colors.dart';

class ReportScreen extends StatefulWidget {
  final Map<String, dynamic> chatMap;
  final String groupId;
  final String groupName;
  final String message;
  final bool isGroupReport;

  const ReportScreen(
      {super.key,
      required this.chatMap,
      required this.groupId,
      required this.groupName,
      required this.message,
      required this.isGroupReport});

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
      child: BlocConsumer<UserReportBloc, UserReportState>(
        listener: (context, state) {
          if (state is UserReportStateLoaded) {
            customSnackBar(
                context, state.userReportResponseModel.message.toString());
            Navigator.pop(context);
          }
          if (state is UserReportStateFailed) {
            customSnackBar(context, state.msg.toString());
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(
              title: widget.isGroupReport == true
                  ? 'Report this group'
                  : 'Report to this user',
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
                            if (widget.isGroupReport == true) {
                              context.read<UserReportBloc>().add(
                                  UserReportSubmittedEvent(
                                      widget.groupId,
                                      widget.groupName,
                                      reportById,
                                      FirebaseProvider
                                          .auth.currentUser!.displayName
                                          .toString(),
                                      widget.chatMap['sendById'],
                                      widget.chatMap['sendBy'],
                                      _reasonController.text,
                                      widget.message,
                                      'group-report'));
                            } else {
                              context.read<UserReportBloc>().add(
                                  UserReportSubmittedEvent(
                                      widget.groupId,
                                      widget.groupName,
                                      reportById,
                                      FirebaseProvider
                                          .auth.currentUser!.displayName
                                          .toString(),
                                      widget.chatMap['sendById'],
                                      widget.chatMap['sendBy'],
                                      _reasonController.text,
                                      widget.message,
                                      'user-report'));
                            }

                            // log('group name - ${widget.groupName} \n group id - ${widget.groupId} \n Report By ID - $reportById  \n report to name -  ${widget.chatMap['sendBy']} \n report to id  -  ${widget.chatMap['sendById']} \n Reason - ${_reasonController.text} \n message - ${widget.message}');
                          }
                        })
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
