import 'package:chattah/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/contact.dart';
import '../models/message.dart';
import '../models/user.dart';

class DatabaseService {
  final _auth = AuthService();
  CollectionReference usersColl = FirebaseFirestore.instance.collection('users');

  Future getUserData() async {
    UserData? user;
    user = await usersColl.get().then((QuerySnapshot snapshot) {
      snapshot.docs
          .where((doc) => doc['uid'] == _auth.getUid())
          .map((doc) => UserData(doc.get('uid'), doc.get('first name'), doc.get('last name'), doc.get('nickname')))
          .toList();
    });
    return user;
  }

  Future addUser(UserData userData) async {
    return usersColl.doc(userData.uid).get().then((DocumentSnapshot doc) {
      if (!doc.exists) {
        usersColl.doc(userData.uid).set({
          'first name': userData.firstName,
          'last name': userData.lastName,
          'uid': userData.uid,
          'nickname': "",
        });
      }
    });
  }

  Future changeNickname(String nickname) async {
    bool exists = false;
    await usersColl.get().then((QuerySnapshot snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        if (doc['nickname'] == nickname) exists = true;
      }
    });
    if (!exists) {
      return usersColl.doc(_auth.getUid()).update({
        'nickname': nickname,
      });
    } else {
      return null;
    }
  }

  Future<String> getNickname() async {
    return usersColl.doc(_auth.getUid()).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot['nickname'] as String;
      } else {
        return "";
      }
    });
  }

  Future<Message> getLastMessage(String theirUid) async {
    final myMessagesColl =
        FirebaseFirestore.instance.collection('users/${_auth.getUid()}/contacts/$theirUid/messages');
    Message? message;
    await myMessagesColl.orderBy('timestamp', descending: true).limit(1).get().then((QuerySnapshot snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        message = Message(doc['from'], doc['to'], doc['body'], doc['timestamp'], doc['seen']);
      }
    });
    return message!;
  }

  Future addContact(String myNickname, String theirNickname) async {
    DocumentSnapshot? myDoc;
    DocumentSnapshot? theirDoc;
    await usersColl.get().then((QuerySnapshot snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        if (theirNickname == doc['nickname']) {
          theirDoc = doc;
        }
      }
    });
    await usersColl.get().then((QuerySnapshot snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        if (myNickname == doc['nickname']) {
          myDoc = doc;
        }
      }
    });
    if (theirDoc != null && myDoc != null) {
      final myChatsColl = FirebaseFirestore.instance.collection('users/${myDoc!['uid']}/contacts');
      final theirChatsColl = FirebaseFirestore.instance.collection('users/${theirDoc!['uid']}/contacts');
      myChatsColl.doc(theirDoc!['uid']).set({
        'first name': theirDoc!['first name'],
        'last name': theirDoc!['last name'],
        'uid': theirDoc!['uid'],
        'nickname': theirDoc!['nickname'],
      });
      theirChatsColl.doc(myDoc!['uid']).set({
        'first name': myDoc!['first name'],
        'last name': myDoc!['last name'],
        'uid': myDoc!['uid'],
        'nickname': myDoc!['nickname'],
      });
    }
  }

  Future addMessage(Message message) async {
    final myMessagesColl =
        FirebaseFirestore.instance.collection('users/${message.from}/contacts/${message.to}/messages');
    final theirMessagesColl =
        FirebaseFirestore.instance.collection('users/${message.to}/contacts/${message.from}/messages');
    myMessagesColl.doc(message.timestamp.toString()).set({
      'to': message.to,
      'from': message.from,
      'body': message.body,
      'timestamp': message.timestamp,
      'seen': message.seen,
    });
    theirMessagesColl.doc(message.timestamp.toString()).set({
      'to': message.to,
      'from': message.from,
      'body': message.body,
      'timestamp': message.timestamp,
      'seen': message.seen,
    });
  }

  List<Contact> contactListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => Contact(
              doc.get('uid'),
              doc.get('first name'),
              doc.get('last name'),
              doc.get('nickname'),
            ))
        .toList();
  }

  List<Message> messageListFromSnapshot(QuerySnapshot snapshot) {
    var messages = snapshot.docs
        .map((doc) => Message(
              doc.get('to'),
              doc.get('from'),
              doc.get('body'),
              doc.get('timestamp'),
              doc.get('seen'),
            ))
        .toList();
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return messages;
  }
}
