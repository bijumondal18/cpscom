import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Api/urls.dart';
import 'package:cpscom_admin/Models/member_model.dart';
import 'package:cpscom_admin/Utils/app_helper.dart';
import 'package:cpscom_admin/Utils/app_preference.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

class FirebaseProvider {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final CollectionReference membersCollectionReference =
      FirebaseFirestore.instance.collection('users');
  static final CollectionReference groupsCollectionReference =
      FirebaseFirestore.instance.collection('groups');
  static final CollectionReference chatsCollectionReference =
      FirebaseFirestore.instance.collection('chats');
  final AppPreference preference = AppPreference();

  Future<User?> login(String email, String password) async {
    try {
      User? user = (await auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (user != null) {
        await preference.setIsLoggedIn(true);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future logout() async {
    try {
      await auth.signOut();
    } catch (e) {
      return 'Failed to logout';
    }
  }

  //CREATE NEW GROUP to firebase firestore collection
  static Future<void> createGroup(
    String groupName,
    String? groupDescription,
    String? profilePicture,
    List<Map<String, dynamic>> members,
  ) async {
    var groupId = const Uuid().v1();
    String uid = '';
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('groups')
        .doc(groupId)
        .set({
      "id": groupId,
      "name": groupName,
      "group_description": groupDescription,
      "profile_picture": profilePicture,
      "created_at": DateTime.now().millisecondsSinceEpoch,
      'time': DateTime.now().millisecondsSinceEpoch,
      "members": members
    });

    await firestore.collection('groups').doc(groupId).set({
      "id": groupId,
      "name": groupName,
      "group_description": groupDescription,
      "profile_picture": profilePicture,
      "created_at": DateTime.now().millisecondsSinceEpoch,
      'time': DateTime.now().millisecondsSinceEpoch,
      "members": members
    });

    //add groups to all the members belongs to this group
    for (int i = 0; i < members.length; i++) {
      uid = members[i]['uid'];

      await firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(groupId)
          .set({
        "name": groupName,
        "group_description": groupDescription,
        "id": groupId,
        "profile_picture": profilePicture,
        "created_at": DateTime.now().millisecondsSinceEpoch, //createdTime,
        'time': DateTime.now().millisecondsSinceEpoch,
        "members": members
      });

      await firestore.collection('groups').doc(groupId).set({
        "name": groupName,
        "group_description": groupDescription,
        "id": groupId,
        "profile_picture": profilePicture,
        "created_at": DateTime.now().millisecondsSinceEpoch, //createdTime,
        'time': DateTime.now().millisecondsSinceEpoch,
        "members": members
      });
    }
    //send initial message (XYZ Created this group) to newly created group chats
    await firestore.collection('groups').doc(groupId).collection('chats').add({
      'message': 'created group "$groupName"',
      'sendBy': auth.currentUser!.displayName,
      'sendById': auth.currentUser!.uid,
      'type': 'notify',
      "profile_picture": profilePicture,
      'time': DateTime.now().millisecondsSinceEpoch
    });
  }

  //get all groups from firebase firestore collection
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllGroups() async* {
    var allGroupsList = membersCollectionReference
        .doc(auth.currentUser!.uid)
        .collection('groups')
        .orderBy('created_at', descending: true)
        .snapshots();
    yield* allGroupsList;
  }

  //get group details from firebase firestore collection
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getGroupDetails(
      String groupId) async* {
    var groupDetails = firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('groups')
        .doc(groupId)
        .snapshots();
    yield* groupDetails;
  }

  //get all users from firebase firestore collection
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() async* {
    var allUsersList = firestore.collection('users').snapshots();
    yield* allUsersList;
  }

  // //get all users from firebase firestore collection
  // static Stream<QuerySnapshot<MembersModel>> getAllUser() async* {
  //   var allUsersList = firestore.collection('users').snapshots();
  //   yield* allUsersList;
  // }

  //get current user details from firebase firestore
  Stream<DocumentSnapshot<Map<String, dynamic>>>
      getCurrentUserDetails() async* {
    getFirebaseMessagingToken();
    yield* FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  //add current user to group in firebase firestore for group creation
  static Future<DocumentSnapshot<Map<String, dynamic>>> addCurrentUserToGroup(
      List<Map<String, dynamic>> memberList) async {
    var user = await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      memberList.add({
        'name': value['name'],
        'email': value['email'],
        'uid': value['uid'],
        'status': value['status'],
        'isAdmin': true,
        'isSuperAdmin': false,
        'profile_picture': value['profile_picture'],
      });
    });
    return user;
  }

  //get current user details from firebase firestore
  static Future<String> updateUserStatus(String status) async {
    return await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'status': status}).then(
            (value) => 'Status Updated Successfully');
  }

  //DELETE user from a group firebase firestore collection
  static Future<void> deleteMember(
      String groupId, List<dynamic> membersList, int index) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('groups')
        .doc(groupId)
        .update({
      "members": FieldValue.arrayRemove([membersList[index]])
    }).then((value) => 'Member Deleted');
  }

  //ADD user to a group firebase firestore collection
  static Future<void> addMemberToGroup(
    String groupId,
    String groupName,
    String profilePicture,
    String groupDesc,
    Map<String, dynamic> member,
  ) async {
    var memberList = [];
    memberList.add(member);

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('groups')
        .doc(groupId)
        .update({
      'members': FieldValue.arrayUnion([
        {
          'id': groupId,
          'members': memberList,
          'group_description': groupDesc,
          'name': groupName,
          'profile_picture': profilePicture,
          'created_at': DateTime.now()
              .millisecondsSinceEpoch, //FieldValue.serverTimestamp(),
        }
      ]) as List<Map<String, dynamic>> //memberList
    });

    // await firestore
    //     .collection('users')
    //     .doc(auth.currentUser!.uid)
    //     .collection('groups')
    //     .doc(groupId)
    //     .set({
    //   'id': groupId,
    //   'members': memberList,
    //   'group_description': groupDesc,
    //   'name': groupName,
    //   'profile_picture': profilePicture,
    //   'created_at': FieldValue.serverTimestamp(),
    // });
  }

  //GET ALL CHAT Messages in a group firebase firestore collection
  static Stream<QuerySnapshot> getChatsMessages(
    String groupId,
  ) async* {
    yield* firestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .orderBy('time', descending: true)
        .snapshots();
  }

  //UPDATE GROUP TITLE in  firebase
  static Future<void> updateGroupTitle(String groupId, String title) async {
    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('groups')
        .doc(groupId)
        .update({"name": title}).then((value) => 'Status Updated Successfully');

    await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .update({"name": title}).then((value) => 'Status Updated Successfully');
  }

  //UPDATE GROUP DESCRIPTION in  firebase
  static Future<void> updateGroupDescription(
      String groupId, String desc) async {
    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('groups')
        .doc(groupId)
        .update({"group_description": desc});

    await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .update({"group_description": desc});
  }

  //GET ALL CHAT Messages in a group firebase firestore collection
  // static Stream<QuerySnapshot> getUnseenMessages(
  //     String groupId,
  //     ) {
  //   return firestore
  //       .collection('groups')
  //       .doc(groupId)
  //       .collection('chats')
  //      // .orderBy('time', descending: true)
  //       .snapshots();
  // }

  //GET Group Description in a group
  static Stream<DocumentSnapshot> getGroupDescription(
    String groupId,
  ) async* {
    yield* firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('groups')
        .doc(groupId)
        .snapshots();
  }

  //GET LAST CHAT Message in a group firebase firestore collection
  static Stream<QuerySnapshot> getLastMessage(
    String groupId,
  ) async* {
    yield* firestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .orderBy('time', descending: true)
        .snapshots();
  }

  static Future<void> onSendMessages(
    String groupId,
    String msg,
    String profilePicture,
    String pushToken,
    String senderName,
  ) async {
    if (msg.trim().isNotEmpty) {
      Map<String, dynamic> chatData = {
        'sendBy': auth.currentUser!.displayName,
        'sendById': auth.currentUser!.uid,
        'profile_picture': profilePicture,
        'message': msg,
        'pushToken': pushToken,
        'type': 'text',
        'time': DateTime.now().millisecondsSinceEpoch, //Timestamp.now(),
        "isSeen": false,
      };

      await firestore
          .collection('groups')
          .doc(groupId)
          .collection('chats')
          .add(chatData)
          .then((value) => sendPushNotification(pushToken, senderName, msg));
    }
  }

  Future<void> uploadImage(File? imageFile) async {
    String fileName = const Uuid().v1();
    var ref = storage.ref().child('admin_group_images').child("$fileName.jpg");
    var uploadTask = await ref.putFile(imageFile!);
    //setState(() async {
    var imageUrl = await uploadTask.ref.getDownloadURL();
    //});
  }

  Future<void> getFirebaseMessagingToken() async {
    await messaging.requestPermission();

    await messaging.getToken().then((value) async {
      if (value != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'pushToken': value});
        //print('push token - $value');
        await preference.setPushToken(value);
        //print('push token from preference - ${await preference.getPushToken()}');
      }
    });
  }

  static Future<void> sendPushNotification(
      String pushToken, String senderName, String msg) async {
    try {
      final body = {
        "to": pushToken,
        "notification": {"title": senderName, "body": msg}
      };
      var response = await post(Uri.parse(Urls.sendPushNotificationUrl),
          headers: {
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
