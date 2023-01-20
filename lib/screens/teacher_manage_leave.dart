import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_4cs/screens/backgrounds/background.dart';
import 'package:flutter/material.dart';

import '../Widgetsapp/AppBar.dart';
import '../Widgetsapp/BouncingButton.dart';
import '../Widgetsapp/LeaveApply/LeaveHistoryCard.dart';
import '../models/leavemodel.dart';
import '../services/auth.dart';
import '../services/database_service.dart';
import '../widgets/Drawer.dart';

class TeacherLeaveHistory extends StatefulWidget {
  const TeacherLeaveHistory({Key? key}) : super(key: key);

  @override
  State<TeacherLeaveHistory> createState() => _TeacherLeaveHistoryState();
}

class _TeacherLeaveHistoryState extends State<TeacherLeaveHistory> {
  String applyleavedate = "";
  String fromdate = "";
  String todate = "";
  String desc = "";
  String leavetype = "";
  String name = "";
  String level = "";
  String pupil_id = "";
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
  final _firestore = FirebaseFirestore.instance;
  QuerySnapshot? leaveSnapshot;
  LeaveModel getLeaveModelFromDatasnapshot(DocumentSnapshot leaveSnapshot) {
    LeaveModel leaveModel = LeaveModel(name, applyleavedate, fromdate, todate,
        leavetype, desc, pupil_id, level);
    leaveModel.pupil_name = leaveSnapshot['pupil_name'];
    leaveModel.leavetype = leaveSnapshot["leaveType"];
    leaveModel.startdate = leaveSnapshot['startDate'];
    leaveModel.enddate = leaveSnapshot['endDate'];
    leaveModel.applyleavedate = leaveSnapshot['leaveDate'];
    leaveModel.desc = leaveSnapshot['leaveDesc'];
    leaveModel.level = leaveSnapshot['level'];
    leaveModel.pupil_id = leaveSnapshot['pupil_id'];
    return leaveModel;
  }

  @override
  void initState() {
    databaseService.getAllLeaveHistory().then((value) async {
      setState(() {
        leaveSnapshot = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CommonAppBar(
        menuenabled: true,
        notificationenabled: false,
        title: "Manage Leave",
        ontap: () {},
      ),
      drawer: appDrawer(context),
      body: Background(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                leaveSnapshot == null
                    ? const Text("no apply for leave yet")
                    : ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const ClampingScrollPhysics(),
                        itemCount: leaveSnapshot!.docs.length,
                        itemBuilder: (context, index) {
                          return Transform(
                            transform: Matrix4.translationValues(0.6, 0.2, 0.5),
                            child: Bouncing(
                              onPress: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: LeaveHistoryCard(
                                  leaveModel: getLeaveModelFromDatasnapshot(
                                      leaveSnapshot!.docs[index]),
                                  index: index,
                                ),
                              ),
                            ),
                          );
                        }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
