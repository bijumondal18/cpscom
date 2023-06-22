import 'dart:convert';
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
import 'package:cpscom_admin/Features/MessageInfo/Presentation/message_info_screen.dart';
import 'package:cpscom_admin/Models/group.dart';
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
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

import '../../../Api/urls.dart';
import '../../../Utils/app_preference.dart';
import '../../GroupMedia/Presentation/group_media_screen.dart';

final ScrollController _scrollController = ScrollController();

class ChatScreen extends StatefulWidget {
  // final Group group;
  final String groupId;
  bool? isAdmin;

  ChatScreen({Key? key, required this.groupId, this.isAdmin}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController msgController;
  final AppPreference preference = AppPreference();
  List<dynamic> membersList = [];
  List<dynamic> chatMembersList = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String profilePicture = '';
  List<String> pushToken = [];

  File? imageFile;

  String _mention = '';
  List<dynamic> _filteredSuggestions = [];

  var extension;
  var extType;

  Future<void> pickFile() async {
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
      // print("chp--->$extension");
      List<File> files =
          result.paths.map((path) => File(path.toString())).toList();
      for (var i in files) {
        // log('Image Path: ${i.path}');
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

  Future<void> onSendMessages(String groupId, String msg, String profilePicture,
      String senderName) async {
    if (msg.trim().isNotEmpty) {
      Map<String, dynamic> chatData = {};
      chatData = {
        'sendBy': FirebaseProvider.auth.currentUser!.displayName,
        'sendById': FirebaseProvider.auth.currentUser!.uid,
        'profile_picture': profilePicture,
        'message': msg,
        'read': DateTime.now().millisecondsSinceEpoch,
        'type': 'text',
        'time': DateTime.now().millisecondsSinceEpoch,
        "isSeen": false,
        "members": chatMembersList.toSet().toList(),
      };

      await FirebaseProvider.firestore
          .collection('groups')
          .doc(groupId)
          .collection('chats')
          .add(chatData)
          .then((value) {
        sendPushNotification(senderName, msg);
      });

      await FirebaseProvider.firestore
          .collection('groups')
          .doc(groupId)
          .update({"time": DateTime.now().millisecondsSinceEpoch});
    }
  }

  Future<void> sendPushNotification(String senderName, String msg) async {
    for (var i = 0; i < membersList.length; i++) {
      // notification will sent to all the users of the group except current user.
      List<String> toSendNotificationIds = [];

      try {
        // notification will sent to all the users of the group except current user.
        if (membersList[i]['uid'] != FirebaseProvider.auth.currentUser!.uid) {
          toSendNotificationIds.add(membersList[i]['pushToken']);
        }

        final body = {
          "priority": "high",
          "to": toSendNotificationIds.toString(),
          "data": <String, dynamic>{"title": senderName, "body": msg},
          "notification": <String, dynamic>{"title": senderName, "body": msg}
        };
        var response = await post(Uri.parse(Urls.sendPushNotificationUrl),
            headers: <String, String>{
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader:
                  'key=AAAASaVGhVk:APA91bGJOeV7_YE_rwJ8YKk0x_yTlUAHkb3MvC_UuiC_FHinYDPtfgPvxkFXnMEQQvaBQ9zYIHKcbWVRukUs7NHGsiLM8Crat79a24ZTDycIIvCzJiHiycLeb7nbAQGKeqQ6orCv_DRd'
            },
            body: jsonEncode(body));
        if (kDebugMode) {
          print('status code send notification - ${response.statusCode}');
          print('body send notification -  ${response.body}');
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
  }

  @override
  void initState() {
    msgController = TextEditingController();
    // msgController.addListener(() {
    //   setState(() {
    //     //final text = msgController.text;
    //     final index = msgController.text.lastIndexOf('@');
    //     if (index >= 0 && index < msgController.text.length - 1) {
    //       final mention = msgController.text.substring(index + 1);
    //       if (mention != _mention) {
    //         _filteredSuggestions = membersList.where((value) {
    //           log('${value['name']}');
    //           return value['name'].startsWith(_mention);
    //         }).toList();
    //       } else {
    //         _mention = '';
    //         _filteredSuggestions = [];
    //       }
    //     }
    //   });
    // });
    super.initState();
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
              //   // return const CircularProgressIndicator.adaptive();
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasData) {
                  membersList = snapshot.data?['members'];
                  chatMembersList.clear();
                  for (var i = 0; i < membersList.length; i++) {
                    // if (membersList[i]['uid'] ==
                    //     FirebaseAuth.instance.currentUser!.uid) {
                    //   i = membersList.indexWhere((element) =>
                    //       element['uid'] ==
                    //       FirebaseAuth.instance.currentUser!.uid);
                    //   widget.isAdmin = membersList[i]['isAdmin'];
                    //   profilePicture = membersList[i]['profile_picture'];
                    // } else {
                    //   // pushToken.add(membersList[i]['pushToken']);
                    // }

                    // Add all the members in  the group to check who viewed the message
                    // isSeen by whom and isDelivered to whom
                    chatMembersList.add({
                      "uid": membersList[i]['uid'],
                      "name": membersList[i]['name'],
                      "profile_picture": membersList[i]['profile_picture'],
                      "isSeen": false,
                      "isDelivered": false,
                    });
                    chatMembersList.removeWhere((element) =>
                        element['uid'] ==
                        FirebaseProvider.auth.currentUser!.uid);
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
                              PopupMenuItem(
                                  value: 3,
                                  child: Text(
                                    'Search',
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
                                // case 2:
                                //   context.push(const GroupMediaScreen());
                                //   break;
                                // case 3:
                                //   context.push(const MessageSearchScreen());
                                //   break;
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
                            Stack(
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
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  minLines: 1,
                                                  isBorder: false,
                                                  // onChanged: (String? value) {
                                                  //   setState(() {
                                                  //     words = value!.split('');
                                                  //     str = words.isNotEmpty &&
                                                  //             words[words.length -
                                                  //                     1]
                                                  //                 .startsWith(
                                                  //                     '@')
                                                  //         ? words[
                                                  //             words.length - 1]
                                                  //         : '';
                                                  //   });
                                                  //   log('$str');
                                                  // },
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
                                                                chatPickerList
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
                                                                        child: chatPickerList[index]
                                                                            .icon,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            AppSizes.kDefaultPadding /
                                                                                2,
                                                                      ),
                                                                      Text(
                                                                        '${chatPickerList[index].title}',
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
                                                child: const Icon(
                                                  EvaIcons.attach,
                                                  color: AppColors.primary,
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
                                          await onSendMessages(
                                            widget.groupId,
                                            msgController.text,
                                            profilePicture,
                                            '${_auth.currentUser!.displayName}',
                                          );
                                          msgController.clear();
                                          SchedulerBinding.instance
                                              .addPostFrameCallback((_) {
                                            _scrollController.animateTo(0.0,
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
                                // str.length > 1
                                //     ? ListView.builder(
                                //         shrinkWrap: true,
                                //         itemCount: chatMembersList.length,
                                //         itemBuilder: (context, index) {
                                //           return Text('fdf');
                                //         })
                                //     : const SizedBox()
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
  List<QueryDocumentSnapshot> chatList = [];
  bool isSender = false;
  String sentTime = '';
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<dynamic> chatMembers = [];
  Map<String, dynamic> chatMemberData = {};
  List<dynamic> updatedChatMemberList = [];
  int isSeenCount = 0;
  //get current user details from firebase firestore
  Future<void> updateMessageSeenStatus(
    String groupId,
    String messageId,
    String uid,
    String profilePicture,
    int index,
  ) async {
    // Update chat member data for seen and delivered
    if (uid == auth.currentUser!.uid) {
      chatMemberData = {
        "isSeen": true,
        "isDelivered": true,
        "uid": auth.currentUser!.uid,
        "profile_picture": profilePicture,
        "name": auth.currentUser!.displayName,
      };

      // remove item from chat members and update with new data
      for (var i = 0; i < chatMembers.length; i++) {
        if (i == index) {
          updatedChatMemberList.removeAt(i);
          updatedChatMemberList.add(chatMemberData);
        }
      }
    }

    // update new data to firebase firestore
    await FirebaseProvider.firestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .doc(messageId)
        .update({'members': updatedChatMemberList}).then(
            (value) => 'Message Seen Status Updated ');
  }

  static Future<void> updateIsSeenStatus(
      String groupId, String messageId) async {
    await FirebaseProvider.firestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .doc(messageId)
        .update({
      'isSeen': true,
    }).then((value) => 'Status Updated Successfully');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseProvider.getChatsMessages(widget.groupId),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator.adaptive());
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData) {
                chatList = snapshot.data!.docs;
                for (var i = 0; i < chatList.length; i++) {
                  chatMap = chatList[i].data() as Map<String, dynamic>;
                  if (chatMap['type'] == 'text' || chatMap['type'] == 'img') {
                    chatMembers = chatMap['members'];
                    for (var lastMsg = 0;
                        lastMsg < chatMembers.length;
                        lastMsg++) {
                      if (chatMembers[lastMsg]['uid'] ==
                          auth.currentUser!.uid) {
                        chatMemberData = chatMembers[lastMsg];
                        updatedChatMemberList = chatMembers;
                        updateMessageSeenStatus(
                            widget.groupId,
                            chatList[i].id,
                            chatMemberData['uid'],
                            chatMemberData['profile_picture'],
                            lastMsg);
                      }

                      if (chatMembers[lastMsg]['isSeen'] == true) {
                        isSeenCount += 1;
                      }
                    }
                    //if all members view the msg then only isSeen will be true;
                    if(chatMembers.length == isSeenCount){
                      updateIsSeenStatus(widget.groupId, chatList[i].id);
                    }
                  }
                }
                // log('---------------- ${chatMembers}');
              }
              return Scrollbar(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: chatList.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _scrollController,
                          shrinkWrap: true,
                          reverse: true,
                          padding: const EdgeInsets.only(
                              bottom: AppSizes.kDefaultPadding * 2),
                          itemBuilder: (context, index) {
                            chatMap =
                                chatList[index].data() as Map<String, dynamic>;
                            isSender = chatMap['sendBy'] ==
                                    auth.currentUser!.displayName
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
                                ? GestureDetector(
                                    onTap: () {
                                      context.push(MessageInfoScreen(
                                        chatMap: chatList[index].data()
                                            as Map<String, dynamic>,
                                      ));
                                    },
                                    // onHorizontalDragUpdate: (DragEndDetails) {
                                    //   context.push(MessageInfoScreen(
                                    //     chatMap: chatMap,
                                    //   ));
                                    // },
                                    child: SenderTile(
                                      message: chatMap['message'],
                                      messageType: chatMap['type'],
                                      sentTime: sentTime,
                                      groupCreatedBy: groupCreatedBy,
                                      read: sentTime,
                                      isSeen: chatMap['isSeen'],
                                    ),
                                  )
                                : ReceiverTile(
                                    message: chatMap['message'],
                                    messageType: chatMap['type'],
                                    sentTime: sentTime,
                                    sentByName: chatMap['sendBy'],
                                    sentByImageUrl: chatMap['profile_picture'],
                                    groupCreatedBy: groupCreatedBy,
                                  );
                          }),
                    ),
                  ],
                ),
              );
          }
          // return const SizedBox();
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
    // print(imageUrl);
    return Scaffold(
      appBar: const CustomAppBar(
        title: '',
      ),
      body: PhotoView(imageProvider: NetworkImage(imageUrl)),
    );
  }
}
