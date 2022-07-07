import 'package:flutter/material.dart';

class MessageInputBox extends StatefulWidget {
  final Future<void> Function(String message) sendMessageFn;

  const MessageInputBox(this.sendMessageFn, {Key? key}) : super(key: key);

  @override
  State<MessageInputBox> createState() => _MessageInputBoxState();
}

class _MessageInputBoxState extends State<MessageInputBox> {
  final double inputBoxHeight = 50;
  final textController = TextEditingController();

  bool get hasText {
    return textController.text.isNotEmpty;
  }

  void _submit() async {
    await widget.sendMessageFn(textController.text);
    textController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        SizedBox(
          width: hasText ? width * 0.8 : width,
          height: inputBoxHeight,
          child: TextField(
            onChanged: (_) {
              setState(() {});
            },
            controller: textController,
            decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                border: InputBorder.none),
            minLines: 1,
            maxLines: 10,
          ),
        ),
        if (hasText)
          GestureDetector(
            onTap: _submit,
            child: Container(
              width: width * 0.2,
              height: inputBoxHeight,
              color: Colors.green,
              child: const Icon(Icons.send),
            ),
          )
      ],
    );
  }
}
