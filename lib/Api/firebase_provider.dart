import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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

  static Future<void> createGroup(String groupName, String groupDescription,
      String profilePicture, List<dynamic> members) async {
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
      "created_at": FieldValue.serverTimestamp(),
      "members": members
    });
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
        "created_at": FieldValue.serverTimestamp(),
        "members": members
      });
    }
    //return createGroup;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllGroups() {
    var allGroupsList = firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('groups')
        .orderBy('created_at', descending: true)
        .snapshots();
    return allGroupsList;
  }

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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    var allUsersList = firestore.collection('users').snapshots();
    return allUsersList;
  }

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

// Future<List<ResponseGroupsList?>> getAllGroups() async {
//   QuerySnapshot querySnapshot = await _firestore.collection("groups").get();
//   final allGroupsList = querySnapshot.docs.map((doc) => doc.data()).toList();
//   print(allGroupsList);
//   return querySnapshot.docs.toList();
// }
}
