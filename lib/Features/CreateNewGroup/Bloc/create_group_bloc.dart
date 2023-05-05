import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cpscom_admin/Api/api_provider.dart';
import 'package:cpscom_admin/Features/CreateNewGroup/Model/response_create_group.dart';
import 'package:cpscom_admin/Utils/app_preference.dart';
import 'package:equatable/equatable.dart';

part 'create_group_event.dart';

part 'create_group_state.dart';

class CreateGroupBloc extends Bloc<CreateGroupEvent, CreateGroupState> {
  CreateGroupBloc() : super(CreateGroupStateInitial()) {
    final ApiProvider apiProvider = ApiProvider();
    on<CreateGroupSubmittedEvent>((event, emit) async {
      Map<String, dynamic> request = {
        "uid": event.uid,
        "group_name": event.groupTitle,
        "group_description": event.groupDesc,
        "profile_picture": event.groupPhoto
      };

      try {
        emit(CreateGroupStateLoading());
        final mData = await apiProvider.createGroups(request);
        if (mData.status == true) {
          emit(CreateGroupStateLoaded(mData));
          print('response of create group - $mData');
        } else {
          emit(const CreateGroupStateFailed('Failed to Create Group'));
          CreateGroupStateInitial();
        }
      } catch (e) {
        emit(const CreateGroupStateFailed(''));
        CreateGroupStateInitial();
      }
    });
  }
}
