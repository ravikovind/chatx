part of 'conversation_bloc.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();
  @override
  List<Object> get props => [];
}

class GetConversations extends ConversationEvent {
  const GetConversations();
}

class CreateConversation extends ConversationEvent {
  const CreateConversation({
    required this.conversation,
  });
  final Conversation conversation;
  @override
  List<Object> get props => [conversation];
}