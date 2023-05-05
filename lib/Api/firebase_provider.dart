import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Features/Home/Model/response_groups_list.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> login(String email, String password) async {
    try {
      User? user = (await _auth.signInWithEmailAndPassword(
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
      await _auth.signOut();
    } catch (e) {
      return 'Failed to logout';
    }
  }
//
// Future<List<ResponseGroupsList?>> getAllGroups() async {
//   QuerySnapshot querySnapshot = await _firestore.collection("groups").get();
//   final allGroupsList = querySnapshot.docs.map((doc) => doc.data()).toList();
//   print(allGroupsList);
//   return querySnapshot.docs.toList();
// }
}
