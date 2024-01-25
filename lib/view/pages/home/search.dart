import 'package:chatx/bloc/conversation/conversation_bloc.dart';
import 'package:chatx/bloc/search/search_user_bloc.dart';
import 'package:chatx/bloc/user/user_bloc.dart';
import 'package:chatx/data/models/conversation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:rxdart/rxdart.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final _stream = BehaviorSubject<String>();
  void _onChange(String value) => _stream.add(value);
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _stream.debounceTime(const Duration(milliseconds: 800)).listen((event) {
        if (event.length > 2 &&
            !context.read<SearchUserBloc>().state.isLoading) {
          context.read<SearchUserBloc>().add(SearchUser(name: event));
        }
      });
      focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserBloc>().state;
    final id = user.id;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: focusNode,
          onChanged: _onChange,
          decoration: const InputDecoration.collapsed(
            hintText: 'Search',
          ),
        ),
      ),
      body: BlocBuilder<SearchUserBloc, SearchUserState>(
        builder: (context, state) {
          final users = state.users.where((user) => user.id != id).toList();
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (users.isEmpty) {
            return const Center(
              child: Text('No user found'),
            );
          }
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.name ?? ''),
                subtitle: Text(user.email ?? ''),
                onTap: () {
                  final conversation = Conversation(
                    participants: [
                      user,
                      context.read<UserBloc>().state,
                    ],
                    type: 'private',
                  );
                  context.read<ConversationBloc>().add(
                        CreateConversation(
                          conversation: conversation,
                        ),
                      );
                  if (context.canPop()) context.pop();
                },
              );
            },
          );
        },
      ),
    );
  }
}
