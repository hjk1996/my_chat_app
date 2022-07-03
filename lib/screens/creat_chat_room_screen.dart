import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../providers/user_info.dart';

class CreateChatRoomScreen extends StatefulWidget {
  static const routeName = "/create-chat-room-screen";
  const CreateChatRoomScreen({Key? key}) : super(key: key);

  @override
  State<CreateChatRoomScreen> createState() => _CreateChatRoomScreenState();
}

class _CreateChatRoomScreenState extends State<CreateChatRoomScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  bool get _readyToSubmit {
    if (_titleController.text.isEmpty || _titleController.text == null) {
      return false;
    }

    if (_descController.text.isEmpty || _descController.text == null) {
      return false;
    }

    if (_passwordController.text.isEmpty || _passwordController.text == null) {
      return false;
    }

    return true;
  }

  Future<void> _submit() async {
    final chatRoomId = Uuid().v4();

    setState(() {
      _isLoading = true;
    });

    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('chats').doc(chatRoomId).set(
        {
          "users": [userId],
          'title': _titleController.text,
          "description": _descController.text,
          "password": _passwordController.text,
          "createdAt": Timestamp.now(),
          "messages": null
        },
      );

      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      final userDocSnapshot = await userDoc.get();
      final userData = userDocSnapshot.data();

      final List userChatRoomList = userData!['userChatRoomList'] ?? [];
      userChatRoomList.add(chatRoomId);

      await userDoc.update({'userChatRoomList': userChatRoomList});

      Navigator.of(context).pop();
       
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
          ),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: ListView(
            children: [
              TextField(
                controller: _titleController,
                onChanged: (_) {
                  setState(() {});
                },
                decoration: const InputDecoration(
                  labelText: 'Chat Room Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _passwordController,
                onChanged: (_) {
                  setState(() {});
                },
                decoration: const InputDecoration(
                  labelText: 'Chat Room Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _descController,
                onChanged: (_) {
                  setState(() {});
                },
                decoration: const InputDecoration(
                  labelText: 'Chat Room Description',
                  border: OutlineInputBorder(),
                ),
                minLines: 10,
                maxLines: 10,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 30,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _readyToSubmit ? _submit : null,
                        child: const Text("Make"),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
