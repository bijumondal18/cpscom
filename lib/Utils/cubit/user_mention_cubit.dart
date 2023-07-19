import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'user_mention_state.dart';

class UserMentionCubit extends Cubit<UserMentionState> {
  UserMentionCubit() : super(UserMentionInitial());

  void mentionCubit(String value) {
     // print("pandey -->$value");
     if(value != null && value != ''){
       if (value![value.length - 1] == '@') {
         // print("@pandey ${value![value.length - 1]}");
         emit(UserMentionLoadedState(isMention: true));
         // _mention = true;
       } else if (value.isNotEmpty && value![value.length - 1] != '@') {
         emit(UserMentionInitial());
         // _mention = false;
       } else if (value.isNotEmpty || value![value.length] != '@'){
         emit(UserMentionInitial());
         // _mention = false;
       } else {
         emit(UserMentionInitial());
       }
     }
     else{
       emit(UserMentionInitial());
     }
  }
}
