import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Message extends StatefulWidget {
  String messgae;
  bool status;

  Message(this.messgae, this.status, {Key? key}) : super(key: key);

  @override
  State<Message> createState() => _MessageState(messgae, status);
}

class _MessageState extends State<Message> {
  String message;
  bool status;
  _MessageState(this.message, this.status);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: Column(children: [Text(message)]),
    );
  }
}
