part of 'user_mention_cubit.dart';

@immutable
abstract class UserMentionState {}

class UserMentionInitial extends UserMentionState {}

class UserMentionLoadedState  extends UserMentionState{
    bool isMention;
    UserMentionLoadedState({required this.isMention});
}
