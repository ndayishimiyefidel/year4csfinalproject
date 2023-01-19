import 'package:flutter/material.dart';

String userName = "";
Widget appBar(BuildContext context) {
  return AppBar(
    leading: const Icon(
      Icons.menu,
    ),
    title: const Text('Pupils Performance'),
    actions: const [
      Icon(Icons.notifications),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Icon(Icons.search),
      ),
      Icon(Icons.more_vert),
    ],
    backgroundColor: Colors.transparent,
    elevation: 5,
  );
}
