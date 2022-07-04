import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.amber,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [Text('hi')],
                      ),
                    ),
                  ),
                ),
                TextField()
              ],
            ),
          ),
        );
      },
    );
  }
}
