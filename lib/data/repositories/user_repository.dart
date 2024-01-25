import 'package:chatx/data/models/conversation.dart';
import 'package:chatx/data/services/user_service.dart';
import 'package:response_x/response_x.dart';

abstract class UserRepository {
  Future<Response> conversations();
  Future<Response> users({
    required String name,
  });
  Future<Response> createConversation({
    required Conversation conversation,
  });
}

class UserRepositoryOf extends UserRepository {
  UserRepositoryOf({required this.service});
  final UserService service;
  @override
  Future<Response> conversations() => service.conversations();

  @override
  Future<Response> createConversation({required Conversation conversation}) =>
      service.createConversation(conversation: conversation);

  @override
  Future<Response> users({required String name}) => service.users(name: name);
}
