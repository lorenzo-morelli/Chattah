import 'dart:io';

import 'package:chattah/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/contact.dart';
import '../models/message.dart';
import '../models/user.dart';

class DatabaseService {
  final _auth = AuthService();
  CollectionReference usersColl = FirebaseFirestore.instance.collection('users');

  Future addUser(UserData userData) async {
    return usersColl.doc(userData.uid).get().then((DocumentSnapshot doc) {
      if (!doc.exists) {
        usersColl.doc(userData.uid).set({
          'first name': userData.firstName,
          'last name': userData.lastName,
          'uid': userData.uid,
          'nickname': userData.nickname,
          'pro pic URL': userData.proPicURL
        });
      }
    });
  }

  Future updateNickname(String nickname) async {
    bool exists = false;
    await usersColl
        .where('nickname', isEqualTo: nickname)
        .get()
        .then((snap) => snap.docs.isNotEmpty ? exists = true : false);
    // await usersColl.get().then((snapshot) {
    //   for (DocumentSnapshot doc in snapshot.docs) {
    //     if (doc['nickname'] == nickname) exists = true;
    //   }
    // });
    if (!exists) {
      await usersColl.doc(_auth.getUid()).update({
        'nickname': nickname,
      });
      return nickname;
    } else {
      return await getNickname();
    }
  }

  Future<String> getNickname() async {
    return usersColl.doc(_auth.getUid()).get().then((DocumentSnapshot doc) {
      if (doc.exists) {
        return doc['nickname'] as String;
      } else {
        return '';
      }
    });
  }

  Future<String> getName(String uid) async {
    return usersColl.doc(uid).get().then((doc) {
      if (doc.exists) {
        return doc['first name'] + ' ' + doc['last name'] as String;
      } else {
        return '';
      }
    });
  }

  Future sendRequest(String myNickname, String theirNickname) async {
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
        'uid': theirDoc!['uid'],
        'friend': false,
        'request': false,
      });
      theirChatsColl.doc(myDoc!['uid']).set({
        'uid': myDoc!['uid'],
        'friend': false,
        'request': true,
      });
    } else {
      return null;
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
      'reply': message.reply
    });
    theirMessagesColl.doc(message.timestamp.toString()).set({
      'to': message.to,
      'from': message.from,
      'body': message.body,
      'timestamp': message.timestamp,
      'seen': message.seen,
      'reply': message.reply
    });
  }

  Future acceptRequest(String myNickname, String theirNickname) async {
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
    final myChatsColl = FirebaseFirestore.instance.collection('users/${myDoc!['uid']}/contacts');
    final theirChatsColl = FirebaseFirestore.instance.collection('users/${theirDoc!['uid']}/contacts');
    myChatsColl.doc(theirDoc!['uid']).update({
      'friend': true,
      'request': false,
    });
    theirChatsColl.doc(myDoc!['uid']).update({
      'friend': true,
      'request': false,
    });
  }

  Future declineRequest(String myNickname, String theirNickname) async {
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
    final myChatsColl = FirebaseFirestore.instance.collection('users/${myDoc!['uid']}/contacts');
    final theirChatsColl = FirebaseFirestore.instance.collection('users/${theirDoc!['uid']}/contacts');
    myChatsColl.doc(theirDoc!['uid']).delete();
    theirChatsColl.doc(myDoc!['uid']).delete();
  }

  Future markAsRead(Message message) async {
    final myMessagesColl =
        FirebaseFirestore.instance.collection('users/${message.to}/contacts/${message.from}/messages');
    final theirMessagesColl =
        FirebaseFirestore.instance.collection('users/${message.from}/contacts/${message.to}/messages');
    myMessagesColl.doc(message.timestamp.toString()).update({
      'seen': true,
    });
    theirMessagesColl.doc(message.timestamp.toString()).update({
      'seen': true,
    });
  }

  Future updateProPic(PlatformFile platfromFile) async {
    final file = File(platfromFile.path!);
    final path = 'propics/${_auth.getUid()}';
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);
    var url = '';
    await ref.getDownloadURL().then((value) => url = value);
    await usersColl.doc(_auth.getUid()).update({
      'pro pic URL': url,
    });
    return url;
  }

  Future<List<UserData>> getUsersFromContacts(List<Contact> contact) async {
    List<UserData> users = [];
    for (Contact contact in contact) {
      users.add(await usersColl.get().then((snapshot) => snapshot.docs
          .where((doc) => doc['uid'] == contact.uid)
          .map((doc) => UserData(
                uid: doc['uid'],
                firstName: doc['first name'],
                lastName: doc['last name'],
                nickname: doc['nickname'],
                proPicURL: doc['pro pic URL'],
              ))
          .toList()
          .first));
    }
    return users;
  }
}
