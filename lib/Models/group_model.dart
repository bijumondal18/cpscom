import 'package:cpscom_admin/Models/member_model.dart';

class GroupsModel {
  String? id;
  String? name;
  String? profilePicture;
  String? createdAt;
  String? time;
  String? groupDescription;
  List<MembersModel>? members;
  List<String>? medias;

  GroupsModel(
      {this.id,
        this.name,
        this.profilePicture,
        this.createdAt,
        this.time,
        this.groupDescription,
        this.members,
        this.medias,
      });

  GroupsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profilePicture = json['profile_picture'];
    createdAt = json['created_at'];
    time = json['time'];
    groupDescription = json['group_description'];
    medias = json['medias'].cast<String>();
    if (json['members'] != null) {
      members = <MembersModel>[];
      json['members'].forEach((v) {
        members!.add(MembersModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['profile_picture'] = profilePicture;
    data['created_at'] = createdAt;
    data['time'] = time;
    data['group_description'] = groupDescription;
    data['medias'] = medias;
    if (members != null) {
      data['members'] = members!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

