part of 'get_started_bloc.dart';

abstract class GetStartedEvent extends Equatable {
  const GetStartedEvent();

  @override
  List<Object> get props => [];
}

class GetStartedSubmittedEvent extends GetStartedEvent {}
