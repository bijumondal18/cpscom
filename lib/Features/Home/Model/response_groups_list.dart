class ResponseGroupsList {
  int? statusCode;
  bool? status;
  List<Data>? data;
  String? message;

  ResponseGroupsList({this.status, this.statusCode, this.data});

  ResponseGroupsList.withError(String errorMessage) {
    message = errorMessage;
  }

  ResponseGroupsList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['statusCode'] = statusCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? admin;
  String? id;
  String? name;
  String? profilePicture;
  String? createdAt;

  Data({this.admin, this.id, this.name, this.profilePicture, this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    admin = json['admin'];
    id = json['id'];
    name = json['name'];
    profilePicture = json['profile_picture'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['admin'] = admin;
    data['id'] = id;
    data['name'] = name;
    data['profile_picture'] = profilePicture;
    data['created_at'] = createdAt;
    return data;
  }
}
