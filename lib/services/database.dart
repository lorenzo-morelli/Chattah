import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/contact.dart';
import '../models/message.dart';
import '../models/user.dart';

class DatabaseService {
  final String myUid;
  String? theirUid;
  CollectionReference usersColl = FirebaseFirestore.instance.collection('users');
  late CollectionReference myChatsColl = FirebaseFirestore.instance.collection('users/$myUid/contacts');
  late CollectionReference theirChatsColl = FirebaseFirestore.instance.collection('users/$theirUid/contacts');
  late CollectionReference myMessagesColl =
      FirebaseFirestore.instance.collection('users/$myUid/contacts/$theirUid/messages');
  late CollectionReference theirMessagesColl =
      FirebaseFirestore.instance.collection('users/$theirUid/contacts/$myUid/messages');

  DatabaseService(this.myUid);

  DatabaseService.theirUid(this.myUid, this.theirUid);

  Future getUserData() async {
    UserData? user;
    user = await usersColl.get().then((QuerySnapshot snapshot) {
      snapshot.docs
          .where((doc) => doc['uid'] == myUid)
          .map((doc) => UserData(doc.get('uid'), doc.get('first name'), doc.get('last name'), doc.get('nickname')))
          .toList();
    });
    return user;
  }

  Future addUser(UserData userData) async {
    return usersColl.doc(myUid).set({
      'first name': userData.firstName,
      'last name': userData.lastName,
      'uid': userData.uid,
      'nickname': userData.nickname,
    });
  }

  Future changeNickname(String nickname) async {
    bool exists = false;
    await usersColl.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        if (doc['nickname'] == nickname) exists = true;
      });
    });
    if (!exists) {
      return usersColl.doc(myUid).update({
        'nickname': nickname,
      });
    } else {
      return null;
    }
  }

  Future<String> getNickname() async {
    return usersColl.doc(myUid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot['nickname'] as String;
      } else {
        return "";
      }
    });
  }

  Future addContact() async {
    await usersColl.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        if (theirUid == doc['uid']) {
          myChatsColl.doc(theirUid).set({
            'first name': doc['first name'],
            'last name': doc['last name'],
            'uid': doc['uid'],
            'nickname': doc['nickname'],
          });
        }
      });
    });
    await usersColl.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        if (myUid == doc['uid']) {
          theirChatsColl.doc(myUid).set({
            'first name': doc['first name'],
            'last name': doc['last name'],
            'uid': doc['uid'],
            'nickname': doc['nickname'],
          });
        }
      });
    });
  }

  Future addMessage(Message message) async {
    myMessagesColl.doc(message.time.toString()).set({
      'to': message.to,
      'from': message.from,
      'body': message.body,
      'timestamp': message.time,
      'seen': message.seen,
    });
    theirMessagesColl.doc(message.time.toString()).set({
      'to': message.to,
      'from': message.from,
      'body': message.body,
      'timestamp': message.time,
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
        .map((doc) =>
            Message(doc.get('to'), doc.get('from'), doc.get('body'), doc.get('timestamp'), doc.get('seen')))
        .toList();
    messages.sort((a, b) => a.time.compareTo(b.time));
    return messages;
  }
}
