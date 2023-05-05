part of 'create_group_bloc.dart';

abstract class CreateGroupState extends Equatable {
  const CreateGroupState();

  @override
  List<Object> get props => [];
}

class CreateGroupStateInitial extends CreateGroupState {}

class CreateGroupStateLoading extends CreateGroupState {}

class CreateGroupStateLoaded extends CreateGroupState {
  final ResponseCreateGroup responseCreateGroup;

  const CreateGroupStateLoaded(this.responseCreateGroup);

  @override
  List<Object> get props => [responseCreateGroup];
}

class CreateGroupStateFailed extends CreateGroupState {
  final String msg;

  const CreateGroupStateFailed(this.msg);

  @override
  List<Object> get props => [msg];
}
