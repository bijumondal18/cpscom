import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class GroupsModel extends Equatable {
  final String? groupDescription;
  final String id;
  final String name;
  final String? profilePicture;
  final List<Members> members;

  const GroupsModel(
      {this.groupDescription,
      required this.id,
      required this.name,
      this.profilePicture,
      required this.members});

  static GroupsModel fromSnapshot(DocumentSnapshot snapshot) {
    GroupsModel groupsModel = GroupsModel(
        groupDescription: snapshot['group_description'],
        id: snapshot['id'],
        name: snapshot['name'],
        profilePicture: snapshot['profile_picture'],
        members: snapshot['members']);

    return groupsModel;
  }

  @override
  List<Object?> get props =>
      [groupDescription, id, name, profilePicture, members];
}

class Members extends Equatable {
  final String email;
  final String name;
  final bool isAdmin;
  final String uid;

  const Members(
      {required this.email,
      required this.name,
      required this.isAdmin,
      required this.uid});

  static Members fromSnapshot(DocumentSnapshot snapshot) {
    Members members = Members(
        email: snapshot['email'],
        name: snapshot['name'],
        isAdmin: snapshot['isAdmin'],
        uid: snapshot['uid']);
    return members;
  }

  @override
  List<Object?> get props => [email, name, isAdmin, uid];
}
