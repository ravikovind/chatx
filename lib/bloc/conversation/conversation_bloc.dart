import 'dart:async';

import 'package:chatx/data/models/conversation.dart';
import 'package:chatx/data/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc
    extends HydratedBloc<ConversationEvent, ConversationState> {
  ConversationBloc({
    required this.repository,
  }) : super(const ConversationState()) {
    on<GetConversations>(_onGetConversations);
    on<CreateConversation>(_onCreateConversation);
  }

  final UserRepository repository;

  FutureOr<void> _onGetConversations(
      GetConversations event, Emitter<ConversationState> emit) async {
    emit(state.copyWith(isLoading: true, message: '', error: ''));
    try {
      final response = await repository.conversations();
      print(
          'success: ${response.success} data: ${response.data.runtimeType} message: ${response.message}');
      if (response.success) {
        final conversations = response.data as List<Conversation>;
        print('conversations: ${conversations.length}');
        emit(state.copyWith(
          isLoading: false,
          conversations: <Conversation>[...conversations],
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: response.message,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  
  FutureOr<void> _onCreateConversation(CreateConversation event, Emitter<ConversationState> emit) async{
    emit(state.copyWith(isLoading: true, message: '', error: ''));
    try {
      final response = await repository.createConversation(conversation: event.conversation);
      print(
          'success: ${response.success} data: ${response.data.runtimeType} message: ${response.message}');
      if (response.success) {
        emit(state.copyWith(
          isLoading: false,
          message: response.message,
        ));
        add(const GetConversations());
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: response.message,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  @override
  ConversationState fromJson(Map<String, dynamic> json) =>
      ConversationState.fromJson(json);

  @override
  Map<String, dynamic> toJson(ConversationState state) => state.toJson();
}
