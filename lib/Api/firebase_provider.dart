import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Features/Home/Model/groups_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../Features/Home/Model/groups_model.dart';
import '../Features/Home/Model/groups_model.dart';
import '../Features/Home/Model/groups_model.dart';
import '../Features/Home/Model/response_groups_list.dart';

class FirebaseProvider {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<User?> login(String email, String password) async {
    try {
      User? user = (await auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        return user;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future logout() async {
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
      String createdTime) async {
    var groupId = const Uuid().v1();
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
      "created_at": createdTime,
      "members": members
    });

    //add groups to all the members belongs to this group
    for (int i = 0; i < members.length; i++) {
      String uid = members[i]['uid'];

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
        "created_at": '${FieldValue.serverTimestamp()}',
        "members": members
      });
    }
    //send initial message (XYZ Created this group) to newly created group chats
    await firestore.collection('users').doc(groupId).collection('chats').add({
      'message': '${auth.currentUser!.displayName} Created This Group',
      'type': 'notify'
    });
  }

  //get all groups from firebase firestore collection
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllGroups() {
    var allGroupsList = firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('groups')
        .orderBy('created_at', descending: true)
        .snapshots();
    return allGroupsList;
  }

  //get group details from firebase firestore collection
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getGroupDetails(
      String groupId) {
    var groupDetails = firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('groups')
        .doc(groupId)
        .snapshots();
    return groupDetails;
  }

  //get all users from firebase firestore collection
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    var allUsersList = firestore.collection('users').snapshots();
    return allUsersList;
  }

  //get current user details from firebase firestore
  static Stream<DocumentSnapshot<Map<String, dynamic>>>
      getCurrentUserDetails() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  //add current user to group in firebase firestore for group creation
  static Future<DocumentSnapshot<Map<String, dynamic>>> addCurrentUserToGroup(
      List<Map<String, dynamic>> memberList) async {
    var user = await FirebaseFirestore.instance
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
  static Future<String> updateUserStatus(String status) {
    return FirebaseFirestore.instance
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
      String groupId, Map<String, dynamic> member) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('groups')
        .doc(groupId)
        .update({'members': member});
  }

  //GET ALL CHAT Messages in a group firebase firestore collection
  static Stream<QuerySnapshot> getChatsMessages(
    String groupId,
    //int limit,
  ) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .orderBy(FieldValue.serverTimestamp(), descending: true)
        // .limit(limit)
        .snapshots();
  }

  static onSendMessages(
    String groupId,
    String msg,
  ) async {
    if (msg.trim().isNotEmpty) {
      Map<String, dynamic> chatData = {
        'send_by': auth.currentUser!.displayName,
        'message': msg,
        'type': 'text',
        'sent_time': FieldValue.serverTimestamp(),
      };
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('groups')
          .doc(groupId)
          .collection('chats')
          .add(chatData);
    }
  }

  // static Future<List<GroupsModel>> fetchAllGroups() async {
  //   QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
  //       .collection('users')
  //       .doc(auth.currentUser!.uid)
  //       .collection('groups')
  //       .orderBy('created_at', descending: true)
  //       .get();
  //   return querySnapshot.docs
  //       .map((doc) => GroupsModel.fromSnapshot(doc))
  //       .toList();
  // }
}
