import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../providers/user_info.dart';
import '../../screens/chat_room_screen.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    await Provider.of<UserInformation>(context, listen: false)
        .fetchUserInfo(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInformation>(
      builder: (context, userInfo, child) => StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .where(
              'id',
              whereIn: userInfo.userChatList ?? [DateTime.now().toString()],
            )
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something is wrong."),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              return Container(
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Card(
                  color: Colors.grey[300],
                  elevation: 6,
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => ChatRoomScreen(document.id)));
                    },
                    title: Text(
                      data['title'],
                      style: const TextStyle(fontSize: 25),
                    ),
                    subtitle: Text(data['description']),
                    trailing: Text(data['last_message_time'] ?? ''),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
