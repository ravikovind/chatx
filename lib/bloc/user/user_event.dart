part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object> get props => [];
}

class SetUser extends UserEvent {
  const SetUser({required this.user});
  final User user;
  @override
  List<Object> get props => [user];
}

class CheckUserState extends UserEvent {}
