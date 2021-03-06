import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/chat_room_screen.dart';
import '../../providers/user_info.dart';

class PasswordDialog extends StatefulWidget {
  final String uid;
  final String password;
  final List users;
  final String userId;

  const PasswordDialog(this.uid, this.password, this.users, this.userId,
      {Key? key})
      : super(key: key);

  @override
  State<PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (passwordController.text != widget.password) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wrong Password!'),
        ),
      );
    }

    try {
      widget.users.add(widget.userId);

      final userDoc =
          FirebaseFirestore.instance.collection("users").doc(widget.userId);

      await FirebaseFirestore.instance
          .collection("chats")
          .doc(widget.uid)
          .update(
        {"users": Set.from(widget.users).toList()},
      ).then(
        (_) {
          return userDoc.get();
        },
      ).then((userDataSnapshot) {
        final Map<String, dynamic> userData = userDataSnapshot.data() ?? {};
        final List userChatList = userData["userChatList"] ?? [];
        userChatList.add(widget.uid);
        return userDoc.update(
          {'userChatList': userChatList},
        );
      }).then((_) {
        Provider.of<UserInformation>(context, listen: false)
            .addNewChat(widget.uid);
        Navigator.of(context).pop(passwordController.text);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => ChatRoomScreen(widget.uid),
          ),
        );
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter the password.'),
      content: TextField(
        autofocus: true,
        obscureText: true,
        controller: passwordController,
        onSubmitted: (_) {
          _submit();
        },
      ),
      actions: [
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        )
      ],
    );
  }
}
