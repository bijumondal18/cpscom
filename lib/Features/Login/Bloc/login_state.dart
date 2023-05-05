part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginStateInitial extends LoginState {}

class LoginStateLoading extends LoginState {}

class LoginStateLoaded extends LoginState {
  final User user;

  const LoginStateLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class LoginStateFailed extends LoginState {
  final String errorMsg;

  const LoginStateFailed(this.errorMsg);

  @override
  List<Object> get props => [errorMsg];
}
