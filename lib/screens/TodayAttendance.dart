import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgetsapp/Attendance/AttendanceCard.dart';
import '../models/attendance_model.dart';
import '../services/auth.dart';
import '../services/database_service.dart';

class TodayAttendance extends StatefulWidget {
  @override
  _TodayAttendanceState createState() => _TodayAttendanceState();
}

String name = "";
String level = "";
String attendate_date = "";
String status = "";
String coursecode = "";
String coursename = "";

var cdate = DateTime.now();
var today = "${cdate.day}-${cdate.month}-${cdate.year}";
var newToday = today.toString();
var userId = FirebaseAuth.instance.currentUser!.uid;

class _TodayAttendanceState extends State<TodayAttendance> {
  bool _isLoading = false;
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
  final _firestore = FirebaseFirestore.instance;
  QuerySnapshot? attendanceSnapshot;
  AttendanceModel getAttendanceModelFromDatasnapshot(
      DocumentSnapshot attendanceSnapshot) {
    AttendanceModel attendanceModel = AttendanceModel(
        name, level, attendate_date, status, coursecode, coursename);
    attendanceModel.name = attendanceSnapshot['name'];
    attendanceModel.level = attendanceSnapshot['level'];
    attendanceModel.attendance_date = attendanceSnapshot['attendate_date'];
    attendanceModel.status = attendanceSnapshot['status'];
    attendanceModel.coursecode = attendanceSnapshot["coursecode"];
    attendanceModel.coursename = attendanceSnapshot['coursename'];
    return attendanceModel;
  }

  @override
  void initState() {
    //check which  logged in
    databaseService.getTodayAttendance(today).then((value) async {
      setState(() {
        attendanceSnapshot = value;
        print(today);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          attendanceSnapshot == null
              ? Text("no Attendance for $today")
              : ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const ClampingScrollPhysics(),
                  itemCount: attendanceSnapshot!.docs.length,
                  itemBuilder: (context, index) {
                    return AttendanceCard(
                      attendanceModel: getAttendanceModelFromDatasnapshot(
                          attendanceSnapshot!.docs[index]),
                      index: index,
                    );
                  }),
          // AttendanceCard(
          //   attendance: false,
          //   endtime: "10 AM",
          //   staff: "Deepak",
          //   starttime: "9 AM",
          //   subject: "English",
          // ),
        ],
      ),
    );
  }
}
