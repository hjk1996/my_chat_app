import 'package:flutter/material.dart';

import '../../screens/chat_room_screen.dart';

class PasswordDialog extends StatefulWidget {
  final String uid;
  final String password;

  const PasswordDialog(this.uid, this.password, {Key? key}) : super(key: key);

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
      Navigator.of(context).pop(passwordController.text);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => ChatRoomScreen(widget.uid),
        ),
      );
    } catch (error) {}
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
