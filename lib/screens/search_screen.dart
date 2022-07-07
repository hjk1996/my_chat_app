import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/chat_room_screen.dart';
import '../widgets/chat/password_dialog.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search-screen';

  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<Map> chatRooms = [];

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  //TO-DO: 채팅방 검색기능 구현하기.
  Future<void> _submit() async {
    final chatRoomSnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .where(
          "title",
          isGreaterThanOrEqualTo: _searchController.text,
          isLessThan: "${_searchController.text} z",
        )
        .get();

    chatRooms = chatRoomSnapshot.docs
        .map((doc) => {...doc.data(), 'uid': doc.id})
        .toList();

    setState(() {});
  }

  Future<void> _showPasswordDialog(
      String id, String password, List users, String userId) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return PasswordDialog(id, password, users, userId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Chats'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(border: Border.all(width: 2)),
              height: 70,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      autofocus: true,
                      controller: _searchController,
                      onChanged: (value) async {
                        await _submit();
                        if (value.isEmpty) {
                          chatRooms = [];
                        } else {}
                      },
                      onSubmitted: (value) async {
                        await _submit();
                      },
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter chat room name."),
                    )),
                    const Icon(Icons.search)
                  ],
                ),
              ),
            ),
          ),
          if (chatRooms.isNotEmpty)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: ListView.builder(
                    itemCount: chatRooms.length,
                    itemBuilder: (context, index) {
                      final Map<dynamic, dynamic> chatRoomInfo =
                          chatRooms[index];
                      final String title = chatRoomInfo['title'];
                      final List users = chatRoomInfo['users'];
                      final String chatRoomId = chatRoomInfo['uid'];
                      final String password = chatRoomInfo['password'];

                      final bool isIn = users.contains(userId);

                      return Card(
                        elevation: 5,
                        child: ListTile(
                          title: Text(title),
                          trailing: CircleAvatar(
                            child: Text(
                              users.length.toString(),
                            ),
                          ),
                          onTap: () async {
                            if (isIn) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (ctx) => ChatRoomScreen(chatRoomId),
                                ),
                              );
                            } else {
                              await _showPasswordDialog(
                                  chatRoomId, password, users, userId);
                            }
                          },
                        ),
                      );
                    }),
              ),
            )
        ],
      ),
    );
  }
}
