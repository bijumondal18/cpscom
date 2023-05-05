part of 'group_bloc.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class LoadGroups extends GroupEvent {
  final Map<String, dynamic> uid;

  const LoadGroups(this.uid);

  @override
  List<Object> get props => [uid];
}

class UpdateGroups extends GroupEvent {
  final List<GroupsModel> groups;
  final Map<String, dynamic> uid;

  const UpdateGroups(this.groups, this.uid);

  @override
  List<Object> get props => [groups, uid];
}
