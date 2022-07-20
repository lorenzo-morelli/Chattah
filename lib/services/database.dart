import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/contact.dart';
import '../models/message.dart';
import '../models/user.dart';

class DatabaseService {
  String? myUid;
  String? theirUid;
  String? myNickname;
  String? theirNickname;
  CollectionReference usersColl = FirebaseFirestore.instance.collection('users');
  late CollectionReference myChatsColl = FirebaseFirestore.instance.collection('users/$myUid/contacts');
  late CollectionReference theirChatsColl = FirebaseFirestore.instance.collection('users/$theirUid/contacts');
  late CollectionReference myMessagesColl =
      FirebaseFirestore.instance.collection('users/$myUid/contacts/$theirUid/messages');
  late CollectionReference theirMessagesColl =
      FirebaseFirestore.instance.collection('users/$theirUid/contacts/$myUid/messages');

  DatabaseService(this.myUid);

  DatabaseService.theirNickname(this.myNickname, this.theirNickname);

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
      for (DocumentSnapshot doc in snapshot.docs) {
        if (doc['nickname'] == nickname) exists = true;
      }
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

    print(myDoc!.data());
    print(theirDoc!.data());
    if (theirDoc != null && myDoc != null) {
      myChatsColl = FirebaseFirestore.instance.collection('users/${myDoc!['uid']}/contacts');
      theirChatsColl = FirebaseFirestore.instance.collection('users/${theirDoc!['uid']}/contacts');
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
        .map((doc) =>
            Message(doc.get('to'), doc.get('from'), doc.get('body'), doc.get('timestamp'), doc.get('seen')))
        .toList();
    messages.sort((a, b) => a.time.compareTo(b.time));
    return messages;
  }
}
