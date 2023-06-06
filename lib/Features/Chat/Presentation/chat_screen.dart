import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:cpscom_admin/Commons/app_images.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/Chat/Widget/receiver_tile.dart';
import 'package:cpscom_admin/Features/Chat/Widget/sender_tile.dart';
import 'package:cpscom_admin/Features/GroupInfo/Model/image_picker_model.dart';
import 'package:cpscom_admin/Features/GroupInfo/Presentation/group_info_screen.dart';
import 'package:cpscom_admin/Utils/app_helper.dart';
import 'package:cpscom_admin/Utils/custom_bottom_modal_sheet.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_divider.dart';
import 'package:cpscom_admin/Widgets/custom_text_field.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

import '../../../Utils/app_preference.dart';
import '../../GroupMedia/Presentation/group_media_screen.dart';

final ScrollController _scrollController = ScrollController();

class ChatScreen extends StatefulWidget {
  final String groupId;
  bool? isAdmin;

  ChatScreen({Key? key, required this.groupId, this.isAdmin}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController msgController = TextEditingController();
  final AppPreference preference = AppPreference();
  List<dynamic> membersList = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String profilePicture = '';
  String pushToken = '';

  File? imageFile;

  var extension;
  var extType;

  Future pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
      ],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      extension = file.extension;
      List<File> files =
          result.paths.map((path) => File(path.toString())).toList();
      for (var i in files) {
        log('Image Path: ${i.path}');
        uploadImage(i, extension);
      }
    } else {
      // User canceled the picker
    }
  }

  Future pickImageFromGallery() async {
    List<XFile>? imageFileList = [];
    try {
      final images = await ImagePicker().pickMultiImage(
          // source: ImageSource.gallery,
          maxHeight: 512,
          maxWidth: 512,
          imageQuality: 75);
      if (images.isNotEmpty) {
        setState(() {
          imageFileList.addAll(images);
        });
        final extension = imageFileList.first.path.split(".").last;
        for (var i in imageFileList) {
          //log('Image Path: ${i.path}');
          await uploadImage(File(i.path), extension);
        }
      } else {
        // User canceled the picker
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }
  }

  Future pickImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          maxHeight: 512,
          maxWidth: 512,
          imageQuality: 75);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => imageFile = imageTemp);
      final extension = image.path.split(".").last;
      await uploadImage(imageFile!, extension);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }
  }

  Future uploadImage(File file, extension) async {
    String fileName = const Uuid().v1();
    final ext = file.path.split('.').last;
    if (extension == 'pdf') {
      extType = "pdf";
    } else if (extension == 'jpg' ||
        extension == 'JPG' ||
        extension == 'jpeg' ||
        extension == 'png') {
      extType = "img";
    } else if (extension == 'doc' || extension == 'docx') {
      extType = "doc";
    } else if (extension == 'gif') {
      extType = "gif";
    }
    int status = 1;
    await _firestore
        .collection('groups')
        .doc(widget.groupId)
        .collection('chats')
        .doc(fileName)
        .set({
      "sendBy": _auth.currentUser!.displayName,
      "sendById": _auth.currentUser!.uid,
      "message": "",
      'profile_picture': profilePicture,
      "type": extType,
      "isSeen": false,
      "time": DateTime.now().millisecondsSinceEpoch,
    });
    var ref = FirebaseStorage.instance
        .ref()
        .child('cpscom_admin_images')
        .child("$fileName.jpg");
    var uploadTask = await ref.putFile(file).catchError((error) async {
      await _firestore
          .collection('groups')
          .doc(widget.groupId)
          .collection('chats')
          .doc(fileName)
          .delete();
      status = 0;
    });
    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();
      await _firestore
          .collection('groups')
          .doc(widget.groupId)
          .collection('chats')
          .doc(fileName)
          .update({"message": imageUrl});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseProvider.getGroupDetails(widget.groupId),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const CircularProgressIndicator.adaptive();
              default:
                if (snapshot.hasData) {
                  membersList = snapshot.data!['members'];
                  for (var i = 0; i < membersList.length; i++) {
                    if (membersList[i]['uid'] ==
                        FirebaseAuth.instance.currentUser!.uid) {
                      i = membersList.indexWhere((element) =>
                          element['uid'] ==
                          FirebaseAuth.instance.currentUser!.uid);
                      widget.isAdmin = membersList[i]['isAdmin'];
                      profilePicture = membersList[i]['profile_picture'];
                    }
                  }
                  return SafeArea(
                    child: Scaffold(
                      appBar: CustomAppBar(
                        title: snapshot.data!['name'],
                        actions: [
                          PopupMenuButton(
                            icon: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  AppSizes.cardCornerRadius * 10),
                              child: CachedNetworkImage(
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      '${snapshot.data?['profile_picture']}',
                                  placeholder: (context, url) =>
                                      const CircleAvatar(
                                        radius: 16,
                                        backgroundColor: AppColors.bg,
                                      ),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: AppColors.bg,
                                        child: Text(
                                          snapshot.data!['name']
                                              .substring(0, 1)
                                              .toString()
                                              .toUpperCase(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ),
                                      )),
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  value: 1,
                                  child: Text(
                                    'Group Info',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(color: AppColors.black),
                                  )),
                              PopupMenuItem(
                                  value: 2,
                                  child: Text(
                                    'Group Media',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(color: AppColors.black),
                                  )),
                            ],
                            onSelected: (value) {
                              switch (value) {
                                case 1:
                                  context.push(GroupInfoScreen(
                                      groupId: widget.groupId,
                                      isAdmin: widget.isAdmin));
                                  break;
                                case 2:
                                  context.push(const GroupMediaScreen());
                                  break;
                              }
                            },
                          ),
                        ],
                      ),
                      body: SafeArea(
                        child: Column(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                                child: _BuildChatList(
                                  groupId: widget.groupId,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                const CustomDivider(),
                                Padding(
                                  padding: const EdgeInsets.all(
                                      AppSizes.kDefaultPadding),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  AppSizes.kDefaultPadding),
                                          decoration: BoxDecoration(
                                            color: AppColors.shimmer,
                                            borderRadius: BorderRadius.circular(
                                                AppSizes.cardCornerRadius),
                                            // border: Border.all(
                                            //     width: 0.3,
                                            //     color: AppColors.grey)
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: CustomTextField(
                                                  controller: msgController,
                                                  hintText: 'Type a message',
                                                  maxLines: 4,
                                                  minLines: 1,
                                                  isBorder: false,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  showCustomBottomSheet(
                                                      context,
                                                      '',
                                                      SizedBox(
                                                        height: 150,
                                                        child: ListView.builder(
                                                            shrinkWrap: true,
                                                            padding:
                                                                const EdgeInsets
                                                                        .all(
                                                                    AppSizes
                                                                        .kDefaultPadding),
                                                            itemCount:
                                                                pickerList
                                                                    .length,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  switch (
                                                                      index) {
                                                                    case 0:
                                                                      pickFile();

                                                                      break;
                                                                    case 1:
                                                                      pickImageFromGallery();

                                                                      break;
                                                                    case 2:
                                                                      pickImageFromCamera();

                                                                      break;
                                                                  }
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: AppSizes
                                                                              .kDefaultPadding *
                                                                          2),
                                                                  child: Column(
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            60,
                                                                        height:
                                                                            60,
                                                                        padding:
                                                                            const EdgeInsets.all(AppSizes.kDefaultPadding),
                                                                        decoration: BoxDecoration(
                                                                            border:
                                                                                Border.all(width: 1, color: AppColors.lightGrey),
                                                                            color: AppColors.white,
                                                                            shape: BoxShape.circle),
                                                                        child: pickerList[index]
                                                                            .icon,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            AppSizes.kDefaultPadding /
                                                                                2,
                                                                      ),
                                                                      Text(
                                                                        '${pickerList[index].title}',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .bodyMedium,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                      ));
                                                },
                                                // onTap: () async {
                                                //   FilePickerResult? result =
                                                //       await FilePicker.platform
                                                //           .pickFiles(
                                                //     allowMultiple: true,
                                                //     type: FileType.custom,
                                                //     allowedExtensions: [
                                                //       'jpg',
                                                //       'JPG',
                                                //       'jpeg',
                                                //       'png',
                                                //       'pdf',
                                                //       'gif',
                                                //       'doc',
                                                //       'docx',
                                                //     ],
                                                //   );

                                                //   if (result != null) {
                                                //     PlatformFile file =
                                                //         result.files.first;

                                                //     extension = file.extension;
                                                //     print("chp--->$extension");
                                                //     List<File> files = result
                                                //         .paths
                                                //         .map((path) => File(
                                                //             path.toString()))
                                                //         .toList();
                                                //     for (var i in files) {
                                                //       //log('Image Path: ${i.path}');
                                                //       uploadImage(i, extension);
                                                //     }
                                                //   } else {
                                                //     // User canceled the picker
                                                //   }
                                                // },
                                                child: const Icon(
                                                  EvaIcons.imageOutline,
                                                  color: AppColors.darkGrey,
                                                  size: 24,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: AppSizes.kDefaultPadding,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await FirebaseProvider.onSendMessages(
                                              widget.groupId,
                                              msgController.text,
                                              profilePicture,
                                              await preference.getPushToken(),
                                              //pushToken
                                              '${_auth.currentUser!.displayName}');
                                          msgController.clear();
                                          SchedulerBinding.instance
                                              .addPostFrameCallback((_) {
                                            _scrollController.animateTo(
                                                // _scrollController
                                                //     .position.maxScrollExtent,
                                                0.0,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.easeInOut);
                                          });
                                        },
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          padding: const EdgeInsets.all(
                                              AppSizes.kDefaultPadding / 2),
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: AppColors
                                                  .buttonGradientColor),
                                          child: const Image(
                                            image:
                                                AssetImage(AppImages.sendIcon),
                                            width: 20,
                                            height: 20,
                                            color: AppColors.white,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            }
            return const SizedBox();
          }),
    );
  }
}

class _BuildChatList extends StatefulWidget {
  final String groupId;

  const _BuildChatList({Key? key, required this.groupId}) : super(key: key);

  @override
  State<_BuildChatList> createState() => _BuildChatListState();
}

class _BuildChatListState extends State<_BuildChatList> {
  Map<String, dynamic> chatMap = <String, dynamic>{};
  bool isSender = false;
  String sentTime = '';
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseProvider.getChatsMessages(widget.groupId),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator.adaptive());
            default:
              if (snapshot.hasData) {
                return Scrollbar(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      shrinkWrap: true,
                      reverse: true,
                      padding: const EdgeInsets.only(
                          bottom: AppSizes.kDefaultPadding * 2),
                      itemBuilder: (context, index) {
                        chatMap = snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;
                        isSender =
                            chatMap['sendBy'] == auth.currentUser!.displayName
                                ? true
                                : false;
                        sentTime = AppHelper.getStringTimeFromTimestamp(
                            chatMap['time']);

                        var groupCreatedBy =
                            FirebaseProvider.auth.currentUser!.uid ==
                                    chatMap['sendById']
                                ? 'You'
                                : chatMap['sendBy'];

                        return isSender
                            ? SenderTile(
                                message: chatMap['message'],
                                messageType: chatMap['type'],
                                sentTime: sentTime,
                                groupCreatedBy: groupCreatedBy,
                              )
                            : ReceiverTile(
                                message: chatMap['message'],
                                messageType: chatMap['type'],
                                sentTime: sentTime,
                                sentByName: chatMap['sendBy'],
                                sentByImageUrl: chatMap['profile_picture'],
                                groupCreatedBy: groupCreatedBy,
                              );

                        // return chatMap['type'] == 'text'
                        //     ? Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: Row(
                        //           crossAxisAlignment: CrossAxisAlignment.end,
                        //           mainAxisAlignment: isSender
                        //               ? MainAxisAlignment.end
                        //               : MainAxisAlignment.start,
                        //           children: [
                        //             !isSender
                        //                 ? ClipRRect(
                        //                     borderRadius: BorderRadius.circular(
                        //                         AppSizes.cardCornerRadius * 3),
                        //                     child: CachedNetworkImage(
                        //                         width: 30,
                        //                         height: 30,
                        //                         fit: BoxFit.cover,
                        //                         imageUrl:
                        //                             '${chatMap['profile_picture']}',
                        //                         placeholder: (context, url) =>
                        //                             const CircleAvatar(
                        //                               radius: 16,
                        //                               backgroundColor:
                        //                                   AppColors.bg,
                        //                             ),
                        //                         errorWidget: (context, url,
                        //                                 error) =>
                        //                             CircleAvatar(
                        //                               radius: 16,
                        //                               backgroundColor:
                        //                                   AppColors.bg,
                        //                               child: Text(
                        //                                 chatMap['name']
                        //                                     .substring(0, 1)
                        //                                     .toString()
                        //                                     .toUpperCase(),
                        //                                 style: Theme.of(context)
                        //                                     .textTheme
                        //                                     .bodyLarge!
                        //                                     .copyWith(
                        //                                         fontWeight:
                        //                                             FontWeight
                        //                                                 .w600),
                        //                               ),
                        //                             )),
                        //                   )
                        //                 : const SizedBox(),
                        //             Padding(
                        //               padding: const EdgeInsets.only(
                        //                   bottom: AppSizes.kDefaultPadding),
                        //               child: Column(
                        //                 crossAxisAlignment: isSender
                        //                     ? CrossAxisAlignment.end
                        //                     : CrossAxisAlignment.start,
                        //                 children: [
                        //                   !isSender
                        //                       ? Padding(
                        //                           padding:
                        //                               const EdgeInsets.only(
                        //                                   left: AppSizes
                        //                                       .kDefaultPadding,
                        //                                   bottom: 4),
                        //                           child: Row(
                        //                             children: [
                        //                               Text(
                        //                                 '${chatMap['sendBy']}, ',
                        //                                 style: Theme.of(context)
                        //                                     .textTheme
                        //                                     .caption!
                        //                                     .copyWith(
                        //                                         fontSize: 12,
                        //                                         fontWeight:
                        //                                             FontWeight
                        //                                                 .w600),
                        //                               ),
                        //                               Text(
                        //                                 sentTime,
                        //                                 style: Theme.of(context)
                        //                                     .textTheme
                        //                                     .caption!
                        //                                     .copyWith(
                        //                                         fontSize: 12),
                        //                               ),
                        //                             ],
                        //                           ),
                        //                         )
                        //                       : Padding(
                        //                           padding:
                        //                               const EdgeInsets.only(
                        //                                   left: AppSizes
                        //                                       .kDefaultPadding,
                        //                                   bottom: 4),
                        //                           child: Text(
                        //                             sentTime,
                        //                             style: Theme.of(context)
                        //                                 .textTheme
                        //                                 .caption!
                        //                                 .copyWith(fontSize: 12),
                        //                           ),
                        //                         ),
                        //                   ChatBubble(
                        //                     clipper: ChatBubbleClipper3(
                        //                         type: isSender
                        //                             ? BubbleType.sendBubble
                        //                             : BubbleType
                        //                                 .receiverBubble),
                        //                     backGroundColor: isSender
                        //                         ? AppColors.secondary
                        //                             .withOpacity(0.5)
                        //                         : AppColors.bg,
                        //                     alignment: isSender
                        //                         ? Alignment.topRight
                        //                         : Alignment.topLeft,
                        //                     elevation: 0,
                        //                     margin: const EdgeInsets.only(
                        //                         left: AppSizes.kDefaultPadding /
                        //                             4),
                        //                     child: Container(
                        //                       constraints: BoxConstraints(
                        //                           maxWidth:
                        //                               MediaQuery.of(context)
                        //                                       .size
                        //                                       .width *
                        //                                   0.65),
                        //                       child: Text(
                        //                         chatMap['message'],
                        //                         style: Theme.of(context)
                        //                             .textTheme
                        //                             .bodyText2!
                        //                             .copyWith(
                        //                                 color: AppColors.black),
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       )
                        //     : chatMap['type'] == 'img'
                        //         ? GestureDetector(
                        //             // onTap: () => context.push(
                        //             //     ShowImage(imageUrl: chatMap['message'])),
                        //             child: Padding(
                        //               padding: const EdgeInsets.all(8.0),
                        //               child: Row(
                        //                 crossAxisAlignment:
                        //                     CrossAxisAlignment.end,
                        //                 mainAxisAlignment: isSender
                        //                     ? MainAxisAlignment.end
                        //                     : MainAxisAlignment.start,
                        //                 children: [
                        //                   !isSender
                        //                       ? ClipRRect(
                        //                           borderRadius: BorderRadius
                        //                               .circular(AppSizes
                        //                                       .cardCornerRadius *
                        //                                   3),
                        //                           child: CachedNetworkImage(
                        //                               width: 30,
                        //                               height: 30,
                        //                               fit: BoxFit.cover,
                        //                               imageUrl:
                        //                                   '${chatMap['profile_picture']}',
                        //                               placeholder: (context,
                        //                                       url) =>
                        //                                   const CircleAvatar(
                        //                                     radius: 16,
                        //                                     backgroundColor:
                        //                                         AppColors.bg,
                        //                                   ),
                        //                               errorWidget: (context,
                        //                                       url, error) =>
                        //                                   CircleAvatar(
                        //                                     radius: 16,
                        //                                     backgroundColor:
                        //                                         AppColors.bg,
                        //                                     child: Text(
                        //                                       chatMap['name']
                        //                                           .substring(
                        //                                               0, 1)
                        //                                           .toString()
                        //                                           .toUpperCase(),
                        //                                       style: Theme.of(
                        //                                               context)
                        //                                           .textTheme
                        //                                           .bodyLarge!
                        //                                           .copyWith(
                        //                                               fontWeight:
                        //                                                   FontWeight
                        //                                                       .w600),
                        //                                     ),
                        //                                   )),
                        //                         )
                        //                       : const SizedBox(),
                        //                   Padding(
                        //                     padding: const EdgeInsets.only(
                        //                         bottom:
                        //                             AppSizes.kDefaultPadding),
                        //                     child: Column(
                        //                       crossAxisAlignment: isSender
                        //                           ? CrossAxisAlignment.end
                        //                           : CrossAxisAlignment.start,
                        //                       children: [
                        //                         !isSender
                        //                             ? Row(
                        //                                 children: [
                        //                                   Text(
                        //                                     '${chatMap['sendBy']},',
                        //                                     style: Theme.of(
                        //                                             context)
                        //                                         .textTheme
                        //                                         .caption!
                        //                                         .copyWith(
                        //                                             fontSize:
                        //                                                 12,
                        //                                             fontWeight:
                        //                                                 FontWeight
                        //                                                     .w600),
                        //                                   ),
                        //                                   Text(
                        //                                     sentTime,
                        //                                     style: Theme.of(
                        //                                             context)
                        //                                         .textTheme
                        //                                         .caption!
                        //                                         .copyWith(
                        //                                             fontSize:
                        //                                                 12),
                        //                                   ),
                        //                                 ],
                        //                               )
                        //                             : Text(
                        //                                 sentTime,
                        //                                 style: Theme.of(context)
                        //                                     .textTheme
                        //                                     .caption!
                        //                                     .copyWith(
                        //                                         fontSize: 12),
                        //                               ),
                        //                         ChatBubble(
                        //                           clipper: ChatBubbleClipper3(
                        //                               type: isSender
                        //                                   ? BubbleType
                        //                                       .sendBubble
                        //                                   : BubbleType
                        //                                       .receiverBubble),
                        //                           backGroundColor: isSender
                        //                               ? AppColors.secondary
                        //                                   .withOpacity(0.3)
                        //                               : AppColors.bg,
                        //                           alignment: isSender
                        //                               ? Alignment.topRight
                        //                               : Alignment.topLeft,
                        //                           elevation: 0,
                        //                           margin: const EdgeInsets.only(
                        //                               top: AppSizes
                        //                                   .kDefaultPadding),
                        //                           child: Container(
                        //                             constraints: BoxConstraints(
                        //                                 maxWidth: MediaQuery.of(
                        //                                             context)
                        //                                         .size
                        //                                         .width *
                        //                                     0.65),
                        //                             child: ClipRRect(
                        //                               borderRadius: BorderRadius
                        //                                   .circular(AppSizes
                        //                                       .cardCornerRadius),
                        //                               child: CachedNetworkImage(
                        //                                 imageUrl:
                        //                                     chatMap['message'],
                        //                                 fit: BoxFit.cover,
                        //                                 placeholder: (context,
                        //                                         url) =>
                        //                                     Platform.isAndroid
                        //                                         ? const CircularProgressIndicator()
                        //                                         : const CupertinoActivityIndicator(),
                        //                                 errorWidget: (context,
                        //                                         url, error) =>
                        //                                     Platform.isAndroid
                        //                                         ? const CircularProgressIndicator()
                        //                                         : const CupertinoActivityIndicator(),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //           )
                        //         : (chatMap['type'] == 'pdf' ||
                        //                 chatMap['type'] == 'doc' ||
                        //                 chatMap['type'] == 'docx')
                        //             ? GestureDetector(
                        //                 // onTap: () => context.push(
                        //                 //     ShowImage(imageUrl: chatMap['message'])),
                        //                 child: Padding(
                        //                   padding: const EdgeInsets.all(8.0),
                        //                   child: Row(
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.end,
                        //                     mainAxisAlignment: isSender
                        //                         ? MainAxisAlignment.end
                        //                         : MainAxisAlignment.start,
                        //                     children: [
                        //                       !isSender
                        //                           ? ClipRRect(
                        //                               borderRadius: BorderRadius
                        //                                   .circular(AppSizes
                        //                                           .cardCornerRadius *
                        //                                       3),
                        //                               child: CachedNetworkImage(
                        //                                   width: 30,
                        //                                   height: 30,
                        //                                   fit: BoxFit.cover,
                        //                                   imageUrl:
                        //                                       '${chatMap['profile_picture']}',
                        //                                   placeholder: (context,
                        //                                           url) =>
                        //                                       const CircleAvatar(
                        //                                         radius: 16,
                        //                                         backgroundColor:
                        //                                             AppColors
                        //                                                 .bg,
                        //                                       ),
                        //                                   errorWidget: (context,
                        //                                           url, error) =>
                        //                                       CircleAvatar(
                        //                                         radius: 16,
                        //                                         backgroundColor:
                        //                                             AppColors
                        //                                                 .bg,
                        //                                         child: Text(
                        //                                           chatMap['name']
                        //                                               .substring(
                        //                                                   0, 1)
                        //                                               .toString()
                        //                                               .toUpperCase(),
                        //                                           style: Theme.of(
                        //                                                   context)
                        //                                               .textTheme
                        //                                               .bodyLarge!
                        //                                               .copyWith(
                        //                                                   fontWeight:
                        //                                                       FontWeight.w600),
                        //                                         ),
                        //                                       )),
                        //                             )
                        //                           : const SizedBox(),
                        //                       Padding(
                        //                         padding: const EdgeInsets.only(
                        //                             bottom: AppSizes
                        //                                 .kDefaultPadding),
                        //                         child: Column(
                        //                           crossAxisAlignment: isSender
                        //                               ? CrossAxisAlignment.end
                        //                               : CrossAxisAlignment
                        //                                   .start,
                        //                           children: [
                        //                             !isSender
                        //                                 ? Row(
                        //                                     children: [
                        //                                       Text(
                        //                                         '${chatMap['sendBy']},',
                        //                                         style: Theme.of(
                        //                                                 context)
                        //                                             .textTheme
                        //                                             .caption!
                        //                                             .copyWith(
                        //                                                 fontSize:
                        //                                                     12,
                        //                                                 fontWeight:
                        //                                                     FontWeight.w600),
                        //                                       ),
                        //                                       Text(
                        //                                         sentTime,
                        //                                         style: Theme.of(
                        //                                                 context)
                        //                                             .textTheme
                        //                                             .caption!
                        //                                             .copyWith(
                        //                                                 fontSize:
                        //                                                     12),
                        //                                       ),
                        //                                     ],
                        //                                   )
                        //                                 : Text(
                        //                                     sentTime,
                        //                                     style: Theme.of(
                        //                                             context)
                        //                                         .textTheme
                        //                                         .caption!
                        //                                         .copyWith(
                        //                                             fontSize:
                        //                                                 12),
                        //                                   ),
                        //                             ChatBubble(
                        //                               clipper: ChatBubbleClipper3(
                        //                                   type: isSender
                        //                                       ? BubbleType
                        //                                           .sendBubble
                        //                                       : BubbleType
                        //                                           .receiverBubble),
                        //                               backGroundColor: isSender
                        //                                   ? AppColors.secondary
                        //                                       .withOpacity(0.3)
                        //                                   : AppColors.bg,
                        //                               alignment: isSender
                        //                                   ? Alignment.topRight
                        //                                   : Alignment.topLeft,
                        //                               elevation: 0,
                        //                               margin: const EdgeInsets
                        //                                       .only(
                        //                                   top: AppSizes
                        //                                       .kDefaultPadding),
                        //                               child: Container(
                        //                                 constraints: BoxConstraints(
                        //                                     maxHeight: 100,
                        //                                     maxWidth: MediaQuery.of(
                        //                                                 context)
                        //                                             .size
                        //                                             .width *
                        //                                         0.45),
                        //                                 child: ClipRRect(
                        //                                   borderRadius: BorderRadius
                        //                                       .circular(AppSizes
                        //                                           .cardCornerRadius),
                        //                                   child: SfPdfViewer
                        //                                       .network(
                        //                                     chatMap['message'],
                        //                                     canShowPaginationDialog:
                        //                                         false,
                        //                                     canShowScrollHead:
                        //                                         false,
                        //                                     canShowScrollStatus:
                        //                                         false,
                        //                                     pageLayoutMode:
                        //                                         PdfPageLayoutMode
                        //                                             .single,
                        //                                     canShowPasswordDialog:
                        //                                         false,
                        //                                   ),
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ],
                        //                         ),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 ),
                        //               )
                        //             : chatMap['type'] == 'notify'
                        //                 ? Padding(
                        //                     padding: const EdgeInsets.symmetric(
                        //                         horizontal:
                        //                             AppSizes.kDefaultPadding),
                        //                     child: Row(
                        //                       mainAxisAlignment:
                        //                           MainAxisAlignment.center,
                        //                       children: [
                        //                         Container(
                        //                           decoration: BoxDecoration(
                        //                               color: AppColors.primary
                        //                                   .withOpacity(0.2),
                        //                               borderRadius: BorderRadius
                        //                                   .circular(AppSizes
                        //                                           .cardCornerRadius /
                        //                                       2)),
                        //                           padding: const EdgeInsets.all(
                        //                               AppSizes.kDefaultPadding /
                        //                                   1.5),
                        //                           margin: const EdgeInsets.all(
                        //                               AppSizes.kDefaultPadding),
                        //                           child: Text(
                        //                             chatMap['sendById'] ==
                        //                                     auth.currentUser!
                        //                                         .uid
                        //                                 ? 'You ${chatMap['message']}'
                        //                                 : '${chatMap['sendBy']} ${chatMap['message']}',
                        //                             style: Theme.of(context)
                        //                                 .textTheme
                        //                                 .bodySmall!
                        //                                 .copyWith(
                        //                                     color: AppColors
                        //                                         .black),
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   )
                        //                 : const SizedBox();
                      }),
                );
              }
          }
          return const SizedBox();
        });
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(imageUrl);
    return Scaffold(
      appBar: const CustomAppBar(
        title: '',
      ),
      body: PhotoView(imageProvider: NetworkImage(imageUrl)),
    );
  }
}
