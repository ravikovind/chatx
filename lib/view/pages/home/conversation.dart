import 'dart:async';

import 'package:chatx/bloc/user/user_bloc.dart';
import 'package:chatx/data/models/conversation.dart';
import 'package:chatx/data/models/message.dart';
import 'package:chatx/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key, required this.conversation});
  final Conversation conversation;
  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  io.Socket? socket;

  final streamOfMessages = BehaviorSubject<List<Message>>();
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    streamOfMessages.add(<Message>[]);
    initSocket().then((_) {
      print('socket initialized');
    });
  }

  Future<void> initSocket() async {
    final user = context.read<UserBloc>().state;
    final id = user.id;
    socket = io.io(
      'http://192.168.1.4:3000',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'reconnectionAttempts': 5,
        'reconnectionDelay': 1000,
        'reconnectionDelayMax': 5000,
      },
    );

    /// connect event
    socket?.connect();

    socket?.on(
      'connect',
      (_) => debugPrint('\x1B[32mconnected to socket.io server\x1B[0m'),
    ); // socket.id is the unique identifier for the socket

    /// disconnect event
    socket?.on(
      'disconnect',
      (_) => debugPrint('\x1B[31mdisconnected from socket.io server\x1B[0m'),
    );
    socket?.on(
      'connect_error',
      (_) => debugPrint('\x1B[31mconnection error $_\x1B[0m'),
    );

    /// error event
    socket?.on(
      'error',
      (_) => debugPrint('\x1B[31merror event\x1B[0m'),
    );

    /// emit conversation event
    socket?.emit(
      'conversation',
      <String, dynamic>{
        'conversation': widget.conversation.id,
        'type': 'message',
        'receivers': <String>[
          ...widget.conversation.participants
                  ?.where((element) => element.id != id)
                  .map((e) => '${e.id}')
                  .where((element) =>
                      element.isNotEmpty && element != 'null' && element != '')
                  .toSet()
                  .toList() ??
              <String>[],
        ],
        'sender': id,
      },
    );

    /// conversation event
    socket?.on(
      'conversation',
      (dynamic data) {
        print('conversation event $data');
        if (data == null) {
          return;
        }
        final message = Message.fromJson(data ?? <String, dynamic>{});
        streamOfMessages.add(<Message>[
          ...streamOfMessages.valueOrNull ?? <Message>[],
          message,
        ]);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    streamOfMessages.close();
    socket?.disconnect();
    socket?.clearListeners();
    socket?.close();
    socket?.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserBloc>().state;
    final receivers = widget.conversation.participants
            ?.where((element) => element.id != user.id)
            .map((e) => '${e.id}')
            .where((element) =>
                element.isNotEmpty && element != 'null' && element != '')
            .toSet()
            .toList() ??
        <String>[];

    final participants = widget.conversation.participants ?? <User>[];
    final otherThanMe =
        participants.where((element) => element.id != user.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: Builder(
          builder: (context) {
            if (otherThanMe.isEmpty) {
              return const Text('Random Chat');
            } else if (otherThanMe.length == 1) {
              return Text(otherThanMe.first.name ?? '');
            }
            return Text(widget.conversation.name ?? '');
          },
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: streamOfMessages.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data ?? <Message>[];
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final me = message.sender == user.id;
                      return Align(
                        alignment:
                            me ? Alignment.centerRight : Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6,
                              ),
                              margin: const EdgeInsets.all(4),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: me
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .tertiary
                                        .withOpacity(0.6),
                                borderRadius: me
                                    ? const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        bottomLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(16),
                                      )
                                    : const BorderRadius.only(
                                        topRight: Radius.circular(16),
                                        bottomLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(16),
                                      ),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${message.message ?? ''}\n',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                    ),
                                    WidgetSpan(
                                      child: Text(
                                        DateFormat('hh:mm a - dd/MM/yyyy')
                                            .format(
                                          message.createdAt ?? DateTime.now(),
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'write a message',
                suffixIcon: IconButton.filled(
                  onPressed: () {
                    if (controller.text.isEmpty) return;
                    socket?.emit(
                      'conversation',
                      <String, dynamic>{
                        'conversation': widget.conversation.id,
                        'type': 'message',
                        'message': controller.text.trim(),
                        'sender': user.id,
                        'receivers': <String>[...receivers],
                      },
                    );
                    setState(() {
                      controller.clear();
                    });
                  },
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
