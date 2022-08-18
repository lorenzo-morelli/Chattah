import 'package:chattah/pages/requests.dart';
import 'package:flutter/material.dart';

import '../services/notification.dart';
import 'friends.dart';

class PageSelector extends StatefulWidget {
  const PageSelector({Key? key}) : super(key: key);

  @override
  State<PageSelector> createState() => _PageSelectorState();
}

class _PageSelectorState extends State<PageSelector> {
  int currentIndex = 0;
  List<Widget> screens = [
    const Friends(),
    const Requests(),
  ];

  @override
  void initState() {
    super.initState();
    NotificationService().listenToNewMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Friends'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Requests'),
        ],
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}
