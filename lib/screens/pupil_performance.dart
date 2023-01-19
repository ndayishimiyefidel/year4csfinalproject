import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Widgetsapp/AppBar.dart';
import '../Widgetsapp/BouncingButton.dart';
import '../Widgetsapp/LeaveApply/MarksCards.dart';
import '../models/marks_model.dart';
import '../services/auth.dart';
import '../services/database_service.dart';
import '../widgets/Drawer.dart';

class PupilsPerformance extends StatefulWidget {
  @override
  _PupilsPerformanceState createState() => _PupilsPerformanceState();
}

class _PupilsPerformanceState extends State<PupilsPerformance>
    with SingleTickerProviderStateMixin {
  late Animation animation, delayedAnimation, muchDelayedAnimation, LeftCurve;
  late AnimationController animationController;
  final searchFieldController = TextEditingController();
  late TextEditingController descFieldController;
  late TextEditingController nameFieldController;

  String coursecode = "";
  String name = "";
  int marks = 0;
  String coursename = "";
  String outof = "";
  String markstype = "";
  String pupil_name = "";
  String teacher_feedback = "";
  String date = "";
  String level = "";

  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
  final _firestore = FirebaseFirestore.instance;
  QuerySnapshot? marksSnapshot;
  MarksModel getMarksModelFromDatasnapshot(DocumentSnapshot marksSnapshot) {
    MarksModel marksModel = MarksModel(marks, coursecode, coursename, outof,
        markstype, pupil_name, teacher_feedback, date, level);

    marksModel.pupil_name = marksSnapshot['pupil_name'];
    marksModel.marks = marksSnapshot["marks"];
    marksModel.markstype = marksSnapshot['marksType'];
    marksModel.coursename = marksSnapshot['coursename'];
    marksModel.coursecode = marksSnapshot['coursecode'];
    marksModel.outof = marksSnapshot['outof'];
    marksModel.teacher_feedback = marksSnapshot['teacher_feedback'];
    marksModel.level = marksSnapshot['level'];
    marksModel.date = marksSnapshot["Date"];
    return marksModel;
  }

  @override
  void initState() {
    databaseService
        .getAllMarks(FirebaseAuth.instance.currentUser!.uid)
        .then((value) async {
      setState(() {
        marksSnapshot = value;
      });
    });
    // TODO: implement initState
    super.initState();
    //SystemChrome.setEnabledSystemUIOverlays([]);
    descFieldController = TextEditingController();
    nameFieldController = TextEditingController();
    animationController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    delayedAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 0.5, curve: Curves.fastOutSlowIn)));

    muchDelayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.3, 0.5, curve: Curves.fastOutSlowIn)));

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<FormState> _formkey = new GlobalKey<FormState>();
  final Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance
      .collectionGroup('Pupils')
      .where("parent_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  final Stream<QuerySnapshot> _courseStream =
      FirebaseFirestore.instance.collection('Courses').snapshots();
  Future checkMarks() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      print(userId);

      // Map<String, dynamic> userData = value.docs.first.data();
      // print(userData['email']);
      await _firestore
          .collection("PupilsMarks")
          .where("parent_id", isEqualTo: userId)
          .where("pupil_id", isEqualTo: name)
          .where("coursecode", isEqualTo: coursecode)
          .get()
          .then((value) {
        setState(() {
          marksSnapshot = value;
        });
      });
    }
  }

  Future<void> OnpupilChanged() async {
    await _firestore
        .collection("PupilsMarks")
        .where("parent_id", isEqualTo: userId)
        .where("pupil_id", isEqualTo: name)
        .get()
        .then((value) {
      setState(() {
        marksSnapshot = value;
      });
    });
  }

  Future<void> OncourseChanged() async {
    await _firestore
        .collection("PupilsMarks")
        .where("parent_id", isEqualTo: userId)
        .where("coursecode", isEqualTo: coursecode)
        .get()
        .then((value) {
      setState(() {
        marksSnapshot = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(userId);
    animationController.forward();
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        final GlobalKey<ScaffoldState> _scaffoldKey =
            new GlobalKey<ScaffoldState>();
        return Scaffold(
          key: _scaffoldKey,
          appBar: CommonAppBar(
            menuenabled: true,
            notificationenabled: false,
            title: "Performance",
            ontap: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
          // drawer: Drawer(
          //   elevation: 0,
          //   child: MainDrawer(),
          // ),
          drawer: appDrawer(context),
          body: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      color: Colors.black.withOpacity(0.5),
                      height: 1,
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          muchDelayedAnimation.value * width, 0, 0),
                      child: const Text(
                        "Registration Number",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: _userStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }
                          if (snapshot.hasData == null) {
                            return const Text("NO child");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          print(snapshot.hasData);
                          return Transform(
                            transform: Matrix4.translationValues(
                                delayedAnimation.value * width, 0, 0),
                            child: DropdownSearch<String>(
                              popupProps: PopupProps.menu(
                                showSelectedItems: true,
                                disabledItemFn: (String s) => s.startsWith('I'),
                              ),
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  hintText: "Please Select child",
                                ),
                              ),
                              validator: (v) =>
                                  v == null ? "required field" : null,
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              // enabled: true, // hint: "Please Select Leave type",
                              // mode: Mode.MENU,
                              // showSelectedItem: true,
                              items: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    return data["pupil_id"];
                                  })
                                  .toList()
                                  .cast<String>(),
                              onSaved: (val) {
                                name = val!;
                              },
                              onChanged: (val) {
                                name = val!;
                                OnpupilChanged();
                              },

                              // showClearButton: true,
                              // onChanged: print,
                            ),
                          );
                        }),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          muchDelayedAnimation.value * width, 0, 0),
                      child: const Text(
                        "Choose course code",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: _courseStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }
                          if (snapshot.hasData == null) {
                            return const Text("no course");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          return Transform(
                            transform: Matrix4.translationValues(
                                delayedAnimation.value * width, 0, 0),
                            child: DropdownSearch<String>(
                              popupProps: PopupProps.menu(
                                showSelectedItems: true,
                                disabledItemFn: (String s) => s.startsWith('I'),
                              ),
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  hintText: "Please course code",
                                ),
                              ),
                              validator: (v) =>
                                  v == null ? "required field" : null,
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              // enabled: true, // hint: "Please Select Leave type",
                              // mode: Mode.MENU,
                              // showSelectedItem: true,
                              items: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    return data["coursecode"];
                                  })
                                  .toList()
                                  .cast<String>(),
                              onSaved: (val) {},
                              onChanged: (val) {
                                coursecode = val!;
                                OncourseChanged();
                              },

                              // showClearButton: true,
                              // onChanged: print,
                            ),
                          );
                        }),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          delayedAnimation.value * width, 0, 0),
                      child: Bouncing(
                        onPress: () {},
                        child: Container(
                          //height: 20,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.blue,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  checkMarks();
                                },
                                child: const Text(
                                  "Check marks",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          muchDelayedAnimation.value * width, 0, 0),
                      child: const Divider(
                        color: Colors.black,
                        thickness: 0.9,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Transform(
                            transform: Matrix4.translationValues(
                                muchDelayedAnimation.value * width, 0, 0),
                            child: const Text(
                              "Recent Marks",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Transform(
                            transform: Matrix4.translationValues(
                                delayedAnimation.value * width, 0, 0),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: InkWell(
                                onTap: () async {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) {
                                  //       return LeaveHistory();
                                  //     },
                                  //   ),
                                  // );
                                },
                                child: const Text(
                                  "See All",
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        marksSnapshot!.docs.isEmpty
                            ? const Text("no marks yet")
                            : ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: const ClampingScrollPhysics(),
                                itemCount: marksSnapshot!.docs.length,
                                itemBuilder: (context, index) {
                                  return Transform(
                                    transform: Matrix4.translationValues(
                                        delayedAnimation.value * width, 0, 0),
                                    child: Bouncing(
                                      onPress: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: MarksCard(
                                          marksModel:
                                              getMarksModelFromDatasnapshot(
                                                  marksSnapshot!.docs[index]),
                                          index: index,
                                        ),
                                      ),
                                    ),
                                  );
                                  // return AttendanceCard(
                                  //   attendanceModel: getAttendanceModelFromDatasnapshot(
                                  //       attendanceSnapshot!.docs[index]),
                                  //   index: index,
                                  // );
                                }),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
