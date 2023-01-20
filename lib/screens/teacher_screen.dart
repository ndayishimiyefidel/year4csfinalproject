import 'package:final_year_4cs/constants.dart';
import 'package:final_year_4cs/screens/backgrounds/background.dart';
import 'package:final_year_4cs/screens/teacher_manage_leave.dart';
import 'package:final_year_4cs/screens/view_all_pupils.dart';
import 'package:final_year_4cs/screens/view_courses.dart';
import 'package:flutter/material.dart';

import '../Widgetsapp/AppBar.dart';
import '../widgets/Drawer.dart';
import 'Attendance.dart';
import 'Chats/Chats.dart';
import 'assignments.dart';
import 'courses.dart';

class TeacherScreen extends StatefulWidget {
  String currentUser;

  TeacherScreen({required this.currentUser});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //     preferredSize: const Size.fromHeight(70), child: appBar(context)),
      appBar: CommonAppBar(
        title: "Home",
        menuenabled: true,
        notificationenabled: true,
        ontap: () {},
      ),
      drawer: appDrawer(context),
      body: Background(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 25, bottom: 25, left: 30, right: 30),
                  child: Column(
                    children: [
                      //explore heading,
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
                                      return const ViewAllPupils();
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
                                      "assets/images/profile.png",
                                      fit: BoxFit.contain,
                                      height: 100,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Pupils",
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
                          //attendance
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
                                      return ViewCourses();
                                    },
                                  ),
                                );
                              },
                              splashColor: Colors.green,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/exam.png",
                                      fit: BoxFit.contain,
                                      height: 100,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Take attendance",
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
                                      return Attendance();
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
                                      "assets/images/attendance.png",
                                      fit: BoxFit.contain,
                                      height: 100,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Attendance",
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
                          //courses
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
                                      return const Courses();
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
                                      "assets/images/library.png",
                                      fit: BoxFit.contain,
                                      height: 100,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Courses",
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
                          //grading
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
                                      return ViewCourses();
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
                                      "assets/images/grading.png",
                                      fit: BoxFit.contain,
                                      height: 100,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Grading",
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
                          //chats
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
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ChatsPage();
                                      },
                                    ),
                                  );
                                });
                              },
                              splashColor: Colors.green,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/message.png",
                                      fit: BoxFit.contain,
                                      height: 100,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Chats",
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
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return TeacherLeaveHistory();
                                      },
                                    ),
                                  );
                                });
                              },
                              splashColor: Colors.green,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/leave_apply.png",
                                      fit: BoxFit.contain,
                                      height: 100,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Leave History",
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
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Assignments();
                                      },
                                    ),
                                  );
                                });
                              },
                              splashColor: Colors.green,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/homeassignment.png",
                                      fit: BoxFit.contain,
                                      height: 100,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Assignments",
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
