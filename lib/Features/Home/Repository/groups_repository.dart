import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Features/Home/Model/groups_model.dart';
import 'package:cpscom_admin/Features/Home/Repository/base_repository.dart';

class GroupsRepository extends BaseRepository {
  final FirebaseFirestore _firestore;

  GroupsRepository({FirebaseFirestore? firebaseFirestore})
      : _firestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<GroupsModel>> getAllGroups() {
    return _firestore.collection('groups').snapshots().map((snapshots) {
      return snapshots.docs
          .map((doc) => GroupsModel.fromSnapshot(doc))
          .toList();
    });
  }

  @override
  Stream<List<Members>> getAllMembers() {
    return _firestore.collection('users').snapshots().map((snapshots) {
      return snapshots.docs.map((doc) => Members.fromSnapshot(doc)).toList();
    });
  }
}
