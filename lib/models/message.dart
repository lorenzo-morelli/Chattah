import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String from;
  String to;
  Timestamp timestamp;
  String body;
  bool seen;

  Message(this.from, this.to, this.body, this.timestamp, this.seen);
}
