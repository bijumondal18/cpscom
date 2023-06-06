import 'package:cloud_firestore/cloud_firestore.dart';

class ParticipantsModel {
  String? name;
  String? email;
  String? uid;
  String? profilePicture;
  String? status;
  bool? isSelected;
  bool? isAdmin;
  bool? isSuperAdmin;

  ParticipantsModel(
      {this.name,
        this.email,
        this.uid,
        this.profilePicture,
        this.status,
        this.isSelected,
        this.isAdmin,
        this.isSuperAdmin});

  ParticipantsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    uid = json['uid'];
    profilePicture = json['profile_picture'];
    status = json['status'];
    isSelected = json['isSelected'];
    isAdmin = json['isAdmin'];
    isSuperAdmin = json['isSuperAdmin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['uid'] = this.uid;
    data['profile_picture'] = this.profilePicture;
    data['status'] = this.status;
    data['isSelected'] = this.isSelected;
    data['isAdmin'] = this.isAdmin;
    data['isSuperAdmin'] = this.isSuperAdmin;
    return data;
  }
}
