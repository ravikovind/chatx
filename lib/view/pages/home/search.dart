import 'package:chatx/bloc/conversation/conversation_bloc.dart';
import 'package:chatx/bloc/search/search_user_bloc.dart';
import 'package:chatx/bloc/user/user_bloc.dart';
import 'package:chatx/data/models/conversation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            if (value.length > 2 &&
                !context.read<SearchUserBloc>().state.isLoading) {
              context.read<SearchUserBloc>().add(SearchUser(name: value));
            }
          },
          decoration: const InputDecoration(
            hintText: 'Search',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchUserBloc, SearchUserState>(
        builder: (context, state) {
          final users = state.users
              .where(
                (element) => element.id != context.read<UserBloc>().state.id,
              )
              .toList();
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
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
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
