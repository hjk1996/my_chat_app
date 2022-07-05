import 'package:flutter/material.dart';

import './message.dart';

class MessageList extends StatelessWidget {
  const MessageList({
    Key? key,
    required this.messages,
    required this.username,
  }) : super(key: key);

  final List messages;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Container(
            width: double.infinity,
            color: Colors.amber,
            child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (ctx, idx) {
                  return Message(messages[idx], username);
                }),
          )),
    );
  }
}
