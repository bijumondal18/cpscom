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
import 'package:cpscom_admin/Utils/app_helper.dart';
import 'package:cpscom_admin/Utils/custom_bottom_modal_sheet.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_divider.dart';
import 'package:cpscom_admin/Widgets/custom_text_field.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:uuid/uuid.dart';

import '../../../Api/urls.dart';
import '../../../Utils/app_preference.dart';

final ScrollController _scrollController = ScrollController();
// bool isDelivered = true;

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

  dynamic extension;
  dynamic extType;

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
      List<File> files =
          result.paths.map((path) => File(path.toString())).toList();
      for (var i in files) {
        uploadImage(i, extension);
      }
    } else {
      // User canceled the picker
    }
  }

  Future pickImageFromGallery() async {
    List<XFile>? imageFileList = [];
    try {
      final images = await ImagePicker()
          .pickMultiImage(maxHeight: 512, maxWidth: 512, imageQuality: 75);
      if (images.isNotEmpty) {
        setState(() {
          imageFileList.addAll(images);
        });
        final extension = imageFileList.first.path.split(".").last;
        for (var i in imageFileList) {
          await uploadImage(File(i.path), extension);
        }
      } else {
        // User canceled the picker
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        log('Failed to pick image: $e');
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
        log('Failed to pick image: $e');
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
    try {
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
        "members": chatMembersList.toSet().toList(),
      });
      // Update last msg time with group time to show latest messaged group on top on the groups list
      await FirebaseProvider.firestore
          .collection('groups')
          .doc(widget.groupId)
          .update({"time": DateTime.now().millisecondsSinceEpoch});

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
    } catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
    }
  }

  Future<void> onSendMessages(String groupId, String msg, String profilePicture,
      String senderName) async {
    if (msg.trim().isNotEmpty) {
      Map<String, dynamic> chatData = {};
      try {
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

        // msgController.clear();

        // Update last msg time with group time to show latest messaged group on top on the groups list
        await FirebaseProvider.firestore
            .collection('groups')
            .doc(groupId)
            .update({"time": DateTime.now().millisecondsSinceEpoch});
      } catch (e) {
        if (kDebugMode) {
          log(e.toString());
        }
      }
    }
  }

  Future<void> sendPushNotification(String senderName, String msg) async {
    for (var i = 0; i < membersList.length; i++) {
      // notification will sent to all the users of the group except current user.
      try {
        final body = {
          "priority": "high",
          "to": membersList[i]['pushToken'],
          "data": <String, dynamic>{"title": senderName, "body": msg},
          "notification": <String, dynamic>{"title": senderName, "body": msg}
        };
        var response = await post(Uri.parse(Urls.sendPushNotificationUrl),
            headers: <String, String>{
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: AppStrings.serverKey
            },
            body: jsonEncode(body));

        if (kDebugMode) {
          log('status code send notification - ${response.statusCode}');
          log('body send notification -  ${response.body}');
        }
      } catch (e) {
        if (kDebugMode) {
          log(e.toString());
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
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasData) {
                  membersList = snapshot.data?['members'];
                  chatMembersList.clear();
                  for (var i = 0; i < membersList.length; i++) {
                    // Add all the members in  the group to check who viewed the message
                    // isSeen by whom and isDelivered to whom
                    try {
                      chatMembersList.add({
                        "uid": membersList[i]['uid'],
                        "name": membersList[i]['name'],
                        "profile_picture": membersList[i]['profile_picture'],
                        "isSeen": false,
                        "isDelivered": true,
                      });
                      chatMembersList.removeWhere((element) =>
                          element['uid'] ==
                          FirebaseProvider.auth.currentUser!.uid);
                    } catch (e) {
                      if (kDebugMode) {
                        log(e.toString());
                      }
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
                              // PopupMenuItem(
                              //     value: 2,
                              //     child: Text(
                              //       'Group Media',
                              //       style: Theme.of(context)
                              //           .textTheme
                              //           .bodyText2!
                              //           .copyWith(color: AppColors.black),
                              //     )),
                              // PopupMenuItem(
                              //     value: 3,
                              //     child: Text(
                              //       'Search',
                              //       style: Theme.of(context)
                              //           .textTheme
                              //           .bodyText2!
                              //           .copyWith(color: AppColors.black),
                              //     )),
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
                                  // To hide the keyboard on outside touch in the screen
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
  Map<String, dynamic>? chatMemberData = {};
  List<dynamic> updatedChatMemberList = [];
  int isSeenCount = 0;
  dynamic lastChatMsg;
  dynamic mem;

  //int isDeliveredCount = 0;
  String chatId = '';

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
      for (var i = 0; i < mem.length; i++) {
        if (i == index) {
          updatedChatMemberList.removeAt(i);
          updatedChatMemberList.add(chatMemberData);
          log('updated chat members - ${updatedChatMemberList[i]}');
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

  Future<void> updateIsSeenStatus(String groupId, String messageId) async {
    await FirebaseProvider.firestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .doc(messageId)
        .update({
      'isSeen': true,
    });
  }

  // Future<void> updateIsDeliveredStatus(String groupId, String messageId) async {
  //   await FirebaseProvider.firestore
  //       .collection('groups')
  //       .doc(groupId)
  //       .collection('chats')
  //       .doc(messageId)
  //       .update({
  //     'isDelivered': true,
  //   }).then((value) => 'Status Updated Successfully');
  // }

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

                  if (chatMap['type'] == 'text' ||
                      chatMap['type'] == 'img' ||
                      chatMap['type'] == 'pdf' ||
                      chatMap['type'] == 'doc' ||
                      chatMap['type'] == 'docx') {
                    lastChatMsg = chatList[0].data() as Map<String, dynamic>;
                    mem = lastChatMsg['members'];
                    chatMembers = chatMap['members'];
                    updatedChatMemberList = mem;
                    // log('mem ------------ ${mem}');
                    // log('chat members ------------ ${chatMembers}');
                    isSeenCount = 0;
                    for (var j = 0; j < mem.length; j++) {
                      // log('mem ------------ ${mem[j]}');
                      // log('isSeen of Members ------------ ${mem[j]['isSeen']}');
                      // log('last msg ------------ ${chatList[0].id}');
                      updateMessageSeenStatus(widget.groupId, chatList[0].id,
                          mem[j]['uid'], mem[j]['profile_picture'], j);

                      //check lst msg seen count
                      if (mem[j]['isSeen'] == true) {
                        isSeenCount += 1;
                      }

                      // log('isSeen count------ $isSeenCount');
                    }
                    if (isSeenCount == mem.length) {
                      updateIsSeenStatus(widget.groupId, chatList[i].id);
                    }
                  }
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
                              chatMap = chatList[index].data()
                                  as Map<String, dynamic>;
                              chatId = chatList[index].id;
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
                                  ? chatMap['type'] != 'notify'
                                      ? SenderTile(
                                          onTap: () {
                                            context.push(MessageInfoScreen(
                                              chatMap: chatList[index].data()
                                                  as Map<String, dynamic>,
                                            ));
                                          },
                                          message: chatMap['message'],
                                          messageType: chatMap['type'],
                                          sentTime: sentTime,
                                          groupCreatedBy: groupCreatedBy,
                                          read: sentTime,
                                          isSeen: chatMap['isSeen'],
                                          // isDelivered: chatMap['isDelivered'],
                                        )
                                      : SenderTile(
                                          message: chatMap['message'],
                                          messageType: chatMap['type'],
                                          sentTime: sentTime,
                                          groupCreatedBy: groupCreatedBy,
                                          read: sentTime,
                                          isSeen: chatMap['isSeen'],
                                          // isDelivered: chatMap['isDelivered'],
                                        )
                                  : ReceiverTile(
                                      message: chatMap['message'],
                                      messageType: chatMap['type'],
                                      sentTime: sentTime,
                                      sentByName: chatMap['sendBy'],
                                      sentByImageUrl:
                                          chatMap['profile_picture'],
                                      groupCreatedBy: groupCreatedBy,
                                    );
                            }),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
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
    return Scaffold(
      appBar: const CustomAppBar(
        title: '',
      ),
      body: PhotoView(imageProvider: NetworkImage(imageUrl)),
    );
  }
}
