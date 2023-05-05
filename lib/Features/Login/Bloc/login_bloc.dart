import 'package:bloc/bloc.dart';
import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:cpscom_admin/Utils/app_preference.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginStateInitial()) {
    AppPreference preference = AppPreference();
    FirebaseProvider firebaseProvider = FirebaseProvider();

    on<LoginSubmittedEvent>((event, emit) async {
      try {
        emit(LoginStateLoading());
        final mData = await firebaseProvider.login(event.email, event.password);

        if (mData?.uid != null) {
          emit(LoginStateLoaded(mData!));
          preference.setIsLoggedIn(true);
          preference.setUserId(mData.uid);
          print('uid : ${mData.uid}');
        } else {
          emit(const LoginStateFailed('Invalid Username or Password'));
          emit(LoginStateInitial());
        }
      } catch (e) {
        emit(LoginStateFailed(e.toString()));
        emit(LoginStateInitial());
      }
    });
  }
}
