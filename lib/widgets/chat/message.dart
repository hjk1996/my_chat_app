import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final Map<String, dynamic> message;
  final String username;
  Message(this.message, this.username, {Key? key}) : super(key: key);

  Color getTextColor(Color color) {
    int d = 0;

// Counting the perceptive luminance - human eye favors green color...
    double luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;

    if (luminance > 0.5)
      d = 0; // bright colors - black font
    else
      d = 255; // dark colors - white font

    return Color.fromARGB(color.alpha, d, d, d);
  }

  @override
  Widget build(BuildContext context) {
    final bool isMe = username == message['username'];
    final Color backgroundColor = isMe ? Colors.blue[300]! : Colors.deepOrange;

    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(username,
              style: TextStyle(color: getTextColor(backgroundColor))),
        ),
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7),
              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(5),
                  topRight: const Radius.circular(5),
                  bottomLeft: isMe
                      ? const Radius.circular(5)
                      : const Radius.circular(0),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(5),
                ),
              ),
              child: Text(message['message'], maxLines: 8, softWrap: true),
            ),
          ],
        ),
      ],
    );
  }
}
