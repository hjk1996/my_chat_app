import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/providers/user_info.dart';
import 'package:provider/provider.dart';

import '../widgets/chat/message_list.dart';
import '../widgets/chat/message_input_box.dart';

class ChatRoomScreen extends StatelessWidget {
  final String chatRoomId;

  const ChatRoomScreen(this.chatRoomId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(chatRoomId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text("Something is wrong"),
          );
        }

        final chatRoomData = snapshot.data!.data() as Map;

        final chatRoomTitle = chatRoomData['title'];
        final List chatRommUsers = chatRoomData['users'] ?? [];
        final List messages = chatRoomData['messages'] ?? [];

        final String username = Provider.of<UserInformation>(context).username!;

        Future<void> _sendMessage(String message) async {
          final messageData = {
            'message': message,
            'username':
                Provider.of<UserInformation>(context, listen: false).username,
            'createdAt': Timestamp.now()
          };

          messages.insert(0, messageData);
          await FirebaseFirestore.instance
              .collection("chats")
              .doc(chatRoomId)
              .update({"messages": messages});
        }

        return Scaffold(
          appBar: AppBar(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  chatRoomTitle,
                  style: const TextStyle(fontSize: 25),
                ),
                Text(
                  "(${chatRommUsers.length})",
                  style: TextStyle(fontSize: 15, color: Colors.grey[200]),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                MessageList(messages: messages, username: username),
                MessageInputBox(_sendMessage)
              ],
            ),
          ),
        );
      },
    );
  }
}
