import 'package:chattah/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

import '../main.dart';
import '../shared/map_snap.dart';
import 'database.dart';

class NotificationService {
  final _auth = AuthService();

  void listenToNewMessages() async {
    final myContacts = FirebaseFirestore.instance.collection('users/${_auth.getUid()}/contacts');
    await myContacts.get().then((QuerySnapshot snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        FirebaseFirestore.instance
            .collection('users/${_auth.getUid()}/contacts/${doc['uid']}/messages')
            .snapshots()
            .map((snap) => MapSnap().mapSnapToMessages(snap).last)
            .listen((message) async {
          if (message.from != _auth.getUid() && message.seen == false) {
            var name = await DatabaseService().getName(message.from);
            showNotification(message.from, name, message.body.toString());
          } else if (message.from != _auth.getUid() && message.seen == true) {
            cancelNotifications();
          }
        });
      }
    });
  }

  void showNotification(String fromUid, String title, String subtitle) {
    initializeTimeZones();
    flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      subtitle,
      TZDateTime.now(local).add(const Duration(seconds: 1)),
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name,
            channelDescription: channel.description,
            importance: Importance.high,
            color: Colors.blue,
            playSound: true,
            // groupKey: channel.groupId,
            icon: '@mipmap/ic_launcher'),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  void cancelNotifications() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }
}
