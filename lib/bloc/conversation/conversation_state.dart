part of 'conversation_bloc.dart';

class ConversationState extends Equatable {
  const ConversationState({
    this.conversations = const <Conversation>[],
    this.isLoading = false,
    this.error = '',
    this.message = '',
  });
  final List<Conversation> conversations;
  final bool isLoading;
  final String error;
  final String message;

  /// copyWith method is used to create a copy of the [ConversationState] object
  /// by changing the provided values.
  
  ConversationState copyWith({
    List<Conversation>? conversations,
    bool? isLoading,
    String? error,
    String? message,
  }) {
    return ConversationState(
      conversations: conversations ?? this.conversations,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }


  /// fromJson method is used to convert the json object received from the api
  /// to a [ConversationState] object.
  
  factory ConversationState.fromJson(Map<String, dynamic> json) {
    return ConversationState(
      conversations: List<Conversation>.from(
        json['conversations']?.map(
              (x) => Conversation.fromJson(x),
            ) ??
            <Conversation>[],
      ),
    );
  }


  /// toJson method is used to convert the [ConversationState] object to json
  /// object to send it to the api.
  
  Map<String, dynamic> toJson() {
    return {
      'conversations': conversations.map((x) => x.toJson()).toList(),
    };
  }


  @override
  List<Object> get props => [conversations, isLoading, error, message];
}
