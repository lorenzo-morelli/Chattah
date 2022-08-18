import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/contact.dart';
import '../models/message.dart';
import '../models/user.dart';

class MapSnap {
  List<UserData> mapSnapToUserData(QuerySnapshot snap) {
    return snap.docs.map((doc) => mapDocToUserData(doc)).toList();
  }

  UserData mapDocToUserData(DocumentSnapshot doc) {
    return UserData(
      uid: doc['uid'],
      firstName: doc['first name'],
      lastName: doc['last name'],
      nickname: doc['nickname'],
      proPicURL: doc['pro pic URL'],
    );
  }

  List<Message> mapSnapToMessages(QuerySnapshot snap) {
    return snap.docs
        .map((doc) => Message(
              to: doc['to'],
              from: doc['from'],
              body: doc['body'],
              timestamp: doc['timestamp'],
              seen: doc['seen'],
              reply: doc['reply'],
            ))
        .toList();
  }

  List<Contact> mapSnapToContact(QuerySnapshot snap) {
    return snap.docs
        .map((doc) => Contact(
              uid: doc['uid'],
              friend: doc['friend'],
              request: doc['request'],
            ))
        .toList();
  }
}
