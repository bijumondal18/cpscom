import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../Utils/app_preference.dart';
import '../Model/groups_model.dart';
import '../Repository/groups_repository.dart';

part 'group_event.dart';

part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupsRepository _groupsRepository;
  StreamSubscription? _groupsSubscription;
  AppPreference? preference;

  GroupBloc({required GroupsRepository groupsRepository})
      : _groupsRepository = groupsRepository,
        super(GroupInitial());

  Stream<GroupState> mapEventToState(
    GroupEvent event,
  ) async* {
    if (event is LoadGroups) {
      yield* _mapLoadGroupsToState();
    }
    if (event is UpdateGroups) {
      yield* _mapUpdateGroupsToState(event);
    }
  }

  Stream<GroupState> _mapLoadGroupsToState() async* {
    Map<String, dynamic> uid = {"uid": await preference!.getUserId()};
    _groupsSubscription?.cancel();
    _groupsSubscription = _groupsRepository
        .getAllGroups()
        .listen((groups) => add(UpdateGroups(groups, uid)));
  }

  Stream<GroupState> _mapUpdateGroupsToState(UpdateGroups event) async* {
    yield GroupLoaded(groups: event.groups);
  }
}
