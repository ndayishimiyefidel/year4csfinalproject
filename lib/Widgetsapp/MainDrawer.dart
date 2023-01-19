import 'package:flutter/material.dart';

import 'DrawerListTile.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DrawerListTile(
            imgpath: "assets/images/home.png",
            name: "Home",
            ontap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (BuildContext context) => Home(),
              //   ),
              // );
            }),
        DrawerListTile(
          imgpath: "assets/images/attendance.png",
          name: "Attendance",
          ontap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (BuildContext context) => Attendance(),
            //   ),
            // );
          },
        ),
        DrawerListTile(
            imgpath: "assets/images/classroom.png",
            name: "Class work",
            ontap: () {}),
        DrawerListTile(
            imgpath: "assets/images/profile.png",
            name: "Profile",
            ontap: () {}),
        DrawerListTile(
          imgpath: "assets/images/exam.png",
          name: "Examination",
          ontap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (BuildContext context) => ExamResult(),
            //   ),
            // );
          },
        ),
        DrawerListTile(
            imgpath: "assets/images/fee.png", name: "Fees", ontap: () {}),
        DrawerListTile(
            imgpath: "assets/images/calendar.png",
            name: "Time Table",
            ontap: () {}),
        DrawerListTile(
            imgpath: "assets/images/library.png",
            name: "Library",
            ontap: () {}),
        DrawerListTile(
          imgpath: "assets/images/downloads.png",
          name: "Downloads",
          ontap: () {},
        ),
        DrawerListTile(imgpath: "images/bus.png", name: "Track ", ontap: () {}),
        DrawerListTile(
          imgpath: "assets/images/leave_apply.png",
          name: "Leave apply",
          ontap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (BuildContext context) => LeaveApply(),
            //   ),
            // );
          },
        ),
        DrawerListTile(
            imgpath: "assets/images/activity.png",
            name: "Activity",
            ontap: () {}),
        DrawerListTile(
            imgpath: "assets/images/notification.png",
            name: "Notification",
            ontap: () {}),
      ],
    );
  }
}
