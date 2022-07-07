import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/search_screen.dart';
import '../screens/creat_chat_room_screen.dart';
import '../widgets/drawer.dart';
import '../widgets/chat/chat_list.dart';
import '../providers/user_info.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final userProfileUrl = Provider.of<UserInformation>(context).profileUrl;

    if (userProfileUrl == null) {
      Provider.of<UserInformation>(context)
          .fetchUserInfo(FirebaseAuth.instance.currentUser!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Chat Rooms"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(SearchScreen.routeName);
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: const ChatList(),
        drawer: const MyDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(CreateChatRoomScreen.routeName);
          },
          child: const Icon(Icons.add),
        ));
  }
}
