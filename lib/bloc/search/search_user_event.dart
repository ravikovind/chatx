part of 'search_user_bloc.dart';

abstract class SearchUserEvent extends Equatable {
  const SearchUserEvent();
  @override
  List<Object> get props => [];
}

class SearchUser extends SearchUserEvent {
  const SearchUser({
    required this.name,
  });
  final String name;
  @override
  List<Object> get props => [name];
}