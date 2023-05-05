part of 'create_group_bloc.dart';

abstract class CreateGroupEvent extends Equatable {
  const CreateGroupEvent();

  @override
  List<Object> get props => [];
}

class CreateGroupSubmittedEvent extends CreateGroupEvent {
  final String groupTitle;
  final String uid;
  final String? groupDesc;
  final File? groupPhoto;

  const CreateGroupSubmittedEvent(
      {required this.groupTitle,
      required this.uid,
      this.groupDesc,
      this.groupPhoto});

  @override
  List<Object> get props => [groupTitle, uid, groupDesc!, groupPhoto!];
}
