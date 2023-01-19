import 'package:final_year_4cs/screens/AccountSettings/AccountSettingsPage.dart';
import 'package:final_year_4cs/screens/Chats/UserList.dart';
import 'package:final_year_4cs/screens/admin_manager.dart';
import 'package:final_year_4cs/screens/backgrounds/background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgetsapp/AppBar.dart';
import '../constants.dart';
import '../services/auth.dart';
import '../widgets/Drawer.dart';

class AdminScreen extends StatefulWidget {
  String currentUser;

  AdminScreen({required this.currentUser});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}
//firebase auth service
//
// void _openDrawer() {
//   messengerKey.currentState?.appDrawer();
// }
//
// void _closeDrawer(BuildContext context) {
//   Navigator.of(context).pop();
// }

AuthService _authService = new AuthService();
final user = FirebaseAuth.instance.currentUser;
bool _isLoading = false;

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "Admin Dashboard",
        menuenabled: true,
        notificationenabled: true,
        ontap: () {
          // _scaffoldKey.currentState?.openDrawer();
        },
      ),
      drawer: appDrawer(context),
      body: SafeArea(
        child: Background(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //card explore more information
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.all(30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Explore all modules ',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
              //card view in body
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(25.0),
                  child: Center(
                    child: Column(
                      children: [
                        //courses and pupils
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                          children: <Widget>[
                            //pupils
                            Card(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: kPrimaryColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const AdminManagePage();
                                      },
                                    ),
                                  );
                                },
                                splashColor: Colors.green,
                                child: Center(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Image.asset(
                                          "assets/images/profile.png",
                                          fit: BoxFit.contain,
                                          height: 100,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Text(
                                          "Pupil & Teacher",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //profile
                            Card(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: kPrimaryColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return UserSettings();
                                      },
                                    ),
                                  );
                                },
                                splashColor: Colors.green,
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/images/userprofile.jpg",
                                        fit: BoxFit.contain,
                                        height: 100,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        "Profile",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //courses
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                          children: <Widget>[
                            //Announcement
                            Card(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: kPrimaryColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: InkWell(
                                onTap: () {},
                                splashColor: Colors.green,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/images/announce.png",
                                        fit: BoxFit.fill,
                                        height: 100,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        "Announcement",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //chats with teacher
                            Card(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: kPrimaryColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return UserList();
                                  }));
                                },
                                splashColor: Colors.green,
                                child: Center(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Image.asset(
                                          "assets/images/message.png",
                                          fit: BoxFit.cover,
                                          height: 100,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          "Chats",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
