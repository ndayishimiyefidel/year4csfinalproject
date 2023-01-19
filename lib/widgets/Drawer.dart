import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_4cs/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../resources/user_state_methods.dart';
import '../screens/AccountSettings/AccountSettingsPage.dart';

String userName = "";
String url = "";
String cdate2 = DateFormat("MMMM, dd, yyyy").format(DateTime.now());
Widget appDrawer(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser;
  // print(user!.displayName.toString());
  FirebaseFirestore.instance
      .collection('Users')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .get()
      .then((value) {
    if (value.size == 1) {
      Map<String, dynamic> userData = value.docs.first.data();
      // print(userData['name']);
      userName = userData["name"];
      url = userData['photoUrl'];
    }
  });

  return Drawer(
    backgroundColor: kPrimaryColor,
    child: ListView(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(
            userName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          accountEmail: Text(
            user!.email.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
              fontStyle: FontStyle.italic,
            ),
          ),
          currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage(url),
            // backgroundImage: AssetImage("assets/images/images1.jpg"),
          ),
          decoration: const BoxDecoration(
              // color: kPrimaryColor,
              ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Text(
            cdate2,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.blueAccent,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Row(
            children: const [
              Text(
                "Basic",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.account_circle,
            color: Colors.white,
            size: 30,
          ),
          title: const Text(
            "profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: 'Montserrat',
            ),
          ),
          onTap: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => UserSettings()));
          },
        ),
        const ListTile(
          leading: Icon(
            Icons.notifications_active,
            color: Colors.white,
            size: 30,
          ),
          title: Text(
            "Notifications",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        const ListTile(
          leading: Icon(
            Icons.lock,
            color: Colors.white,
            size: 30,
          ),
          title: Text(
            "Account privacy",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        const ListTile(
          leading: Icon(
            Icons.place,
            color: Colors.white,
            size: 30,
          ),
          title: Text(
            "Location",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        const ListTile(
          leading: Icon(
            Icons.dark_mode,
            color: Colors.white,
            size: 30,
          ),
          title: Text(
            "Dark mode",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Row(
            children: const [
              Text(
                "More",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        //more

        const ListTile(
          leading: Icon(
            Icons.language,
            color: Colors.white,
            size: 30,
          ),
          title: Text(
            "Language",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        const ListTile(
          leading: Icon(
            Icons.privacy_tip,
            color: Colors.white,
            size: 30,
          ),
          title: Text(
            "Terms & condition",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.logout,
            color: Colors.white,
            size: 30,
          ),
          title: const Text(
            "Sign out",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: 'Montserrat',
            ),
          ),
          onTap: () => UserStateMethods().logoutuser(context),
        ),
      ],
    ),
  );
}
