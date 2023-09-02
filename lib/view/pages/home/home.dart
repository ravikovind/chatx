import 'package:chatx/bloc/conversation/conversation_bloc.dart';
import 'package:chatx/bloc/user/user_bloc.dart';
import 'package:chatx/core/routes/routes.dart';
import 'package:chatx/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:random_avatar/random_avatar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserBloc>().state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatX'),
        actions: [
          /// profile
          IconButton(
            onPressed: () {
              context.pushNamed(kProfileRoute);
            },
            icon: const Icon(Icons.person),
          ),

          /// search
          IconButton(
            onPressed: () {
              context.pushNamed(kSearchRoute);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: BlocBuilder<ConversationBloc, ConversationState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.conversations.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    RandomAvatar(
                      user.avatar ?? 'ChatX',
                      width: 100,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No Conversations Found!\nStart a new one! see the search icon on the top right corner.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: state.conversations.length,
            itemBuilder: (context, index) {
              final conversation = state.conversations[index];
              final participants = conversation.participants ?? <User>[];

              final otherThanMe = participants
                  .where((element) => element.id != user.id)
                  .toList();

              if (otherThanMe.isEmpty) {
                return const SizedBox.shrink();
              } else if (otherThanMe.length == 1) {
                return ListTile(
                  onTap: () {
                    context.pushNamed(
                      kConversationRoute,
                      extra: conversation,
                    );
                  },
                  title: Text(otherThanMe.first.name ?? 'No Name Found'),
                  subtitle: Text(
                    otherThanMe.first.email ?? 'No Email Found',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  leading: RandomAvatar(
                    otherThanMe.first.avatar ?? 'ChatX',
                    width: 40,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                );
              }
              return ListTile(
                onTap: () {},
                title: Text(conversation.name ?? 'No Name Found'),
              );
            },
          );
        },
      ),
    );
  }
}
