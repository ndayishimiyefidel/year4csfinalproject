import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgetsapp/Attendance/AttendanceCard.dart';
import '../models/attendance_model.dart';
import '../services/auth.dart';
import '../services/database_service.dart';

class POverallAttendance extends StatefulWidget {
  @override
  _POverallAttendanceState createState() => _POverallAttendanceState();
}

String name = "";
String level = "";
String attendate_date = "";
String status = "";
String coursecode = "";
String coursename = "";
final _firestore = FirebaseFirestore.instance;
final userId = FirebaseAuth.instance.currentUser!.uid;
var cdate = DateTime.now();
var today = "${cdate.day}-${cdate.month}-${cdate.year}";

class _POverallAttendanceState extends State<POverallAttendance> {
  bool _isLoading = false;
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
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
    databaseService.getAllSingleAttendance(userId).then((value) async {
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Column(
            children: [
              attendanceSnapshot == null
                  ? const Text("no Attendance made Yet!")
                  : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const ClampingScrollPhysics(),
                      itemCount: attendanceSnapshot!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AttendanceCard(
                          attendanceModel: getAttendanceModelFromDatasnapshot(
                              attendanceSnapshot!.docs[index]),
                          index: index,
                        );
                      },
                      // OverallAttendanceCard(
                      //   date: "15.12.2020",
                      //   day: "sunday",
                      //   firsthalf: true,
                      //   secondhalf: false,
                      // ),
                      // OverallAttendanceCard(
                      //   date: "15.12.2020",
                      //   day: "sunday",
                      //   firsthalf: true,
                      //   secondhalf: false,
                      // ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
