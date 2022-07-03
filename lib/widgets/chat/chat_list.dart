import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatList extends StatelessWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something is wrong."),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final userData = snapshot.data!.data() as Map;
        final List userChatIdList = userData['userChatList'] ?? [];

        if (userChatIdList.isEmpty) {
          return const Center(
            child: Text("No room is made yet."),
          );
        }

        return FutureBuilder(
          future: FirebaseFirestore.instance.collection('chats').get(),
          builder:
              (BuildContext ctx, AsyncSnapshot<QuerySnapshot> futureSnapshot) {
            if (futureSnapshot.hasError) {
              return Text("Something went wrong");
            }

            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!futureSnapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final userChatList = futureSnapshot.data!.docs.where(
              (document) => userChatIdList.contains(document.id),
            );

            return ListView(
              children: userChatList.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                return ListTile(
                  title: Text(data['title']),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
