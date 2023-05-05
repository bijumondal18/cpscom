import 'package:cpscom_admin/Features/Home/Model/groups_model.dart';

abstract class BaseRepository{
  Stream<List<GroupsModel>> getAllGroups();
  Stream<List<Members>> getAllMembers();
}