import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

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
  static Future<void> createGroup(String groupName, String? groupDescription,
      String? profilePicture, List<Map<String, dynamic>> members) async {
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
      "created_at": '${FieldValue.serverTimestamp()}',
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
  static Future<DocumentSnapshot> getCurrentUserDetails() async {
   return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    //     .then((value) {
    //   membersList.add({
    //     'name': value['name'],
    //     'email': value['email'],
    //     'uid': value['uid'],
    //     'isAdmin': value['isAdmin'],
    //     'profile_picture': value['profile_picture'],
    //   });
    // });
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

  Stream<QuerySnapshot> getChatsMessages(String groupId, int limit) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .orderBy(FieldValue.serverTimestamp(), descending: true)
        .limit(limit)
        .snapshots();
  }

// Future<List<ResponseGroupsList?>> getAllGroups() async {
//   QuerySnapshot querySnapshot = await _firestore.collection("groups").get();
//   final allGroupsList = querySnapshot.docs.map((doc) => doc.data()).toList();
//   print(allGroupsList);
//   return querySnapshot.docs.toList();
// }
}
