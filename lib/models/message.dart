import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String from;
  String to;
  Timestamp timestamp;
  String body;
  bool seen;
  Map? reply;

  Message({
    this.from = '',
    this.to = '',
    this.body = '',
    required this.timestamp,
    this.seen = false,
    this.reply,
  });
}
