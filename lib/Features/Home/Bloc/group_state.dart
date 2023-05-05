part of 'group_bloc.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object> get props => [];
}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupLoaded extends GroupState {
  final List<GroupsModel> groups;

  const GroupLoaded({this.groups = const <GroupsModel>[]});

  @override
  List<Object> get props => [groups];
}

class GroupFailed extends GroupState {}
