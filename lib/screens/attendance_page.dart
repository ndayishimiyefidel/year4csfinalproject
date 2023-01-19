import 'dart:convert' as convert;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//database services
import '../Widgetsapp/AppBar.dart';
import '../models/pupil_model.dart';
import '../services/auth.dart';
import '../services/database_service.dart';
import '../widgets/Drawer.dart';

class AttendancePage extends StatefulWidget {
  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

String name = "";
String level = "";
String age = "";
String gender = "";
String id = "", phone = "";
String parent_id = "";

class _AttendancePageState extends State<AttendancePage> {
  String? _initialValue;
  List<PupilsModel> students = [];
  late String _selectedResult;
  int? number;
  @override
  void initState() {
    super.initState();
    _initialValue = '';
    _selectedResult = "";

    super.initState();
  }

  Stream<dynamic>? pupilsStream;
  bool _isLoading = false;
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
  //query snapshots
  QuerySnapshot? pupilsSnapshot;
  PupilsModel getPupilModelFromDatasnapshot(DocumentSnapshot pupilsSnapshot) {
    PupilsModel pupilModel =
        PupilsModel(name, age, gender, level, id, phone, parent_id);
    pupilModel.name = pupilsSnapshot['name'];
    pupilModel.age = pupilsSnapshot['age'];
    pupilModel.level = pupilsSnapshot['level'];
    pupilModel.gender = pupilsSnapshot['gender'];
    pupilModel.phone = pupilsSnapshot["parent_phone"];
    pupilModel.parent_id = pupilsSnapshot["parent_id"];
    pupilModel.id = pupilsSnapshot["uid"];
    return pupilModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: CommonAppBar(
        title: "Take Attendance",
        menuenabled: true,
        notificationenabled: true,
        ontap: () {},
      ),
      // appBar: PreferredSize(
      //     preferredSize: const Size.fromHeight(70), child: appBar(context)),
      drawer: appDrawer(context),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(21.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Select Level",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropDownFormField(
                  titleText: 'Select Level',
                  hintText: 'Please choose one',
                  contentPadding: const EdgeInsets.all(12),
                  value: _initialValue,
                  onSaved: (value) {
                    setState(() {
                      _initialValue = value;
                    });
                  },
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      _initialValue = value;
                      _selectedResult = value;
                      getPupilsDataByLevel(value).then((value) async {
                        setState(() {
                          pupilsSnapshot = value;
                        });
                      });
                    });
                  },
                  dataSource: const [
                    {
                      "display": "P1",
                      "value": "P1",
                    },
                    {
                      "display": "P2",
                      "value": "P2",
                    },
                    {
                      "display": "P3",
                      "value": "P3",
                    },
                    {
                      "display": "P4",
                      "value": "P4",
                    },
                    {
                      "display": "P5",
                      "value": "P5",
                    },
                    {
                      "display": "P6",
                      "value": "P6",
                    },
                  ],
                  textField: 'display',
                  valueField: 'value',
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "$number Pupil(s) in Level  $_selectedResult",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _isLoading
                    ? Container(
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const ClampingScrollPhysics(),
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          return UsersTile(
                            pupilModel: students[index],
                            index: index,
                          );
                        })
              ],
            ),
          ),
        ),
      ),

      //floating button
    );
  }

  getPupilsDataByLevel(String level) async {
    setState(() {
      _isLoading = true;
      students.clear();
    });

    await FirebaseFirestore.instance
        .collectionGroup("Pupils")
        .where("level", isEqualTo: level)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        PupilsModel contentModel = PupilsModel(
            element.data()['name'],
            element.data()['age'],
            element.data()['gender'],
            element.data()['level'],
            element.id,
            element.data()['parent_phone'],
            element.data()['parent_id']);
        students.add(contentModel);
      });
      number = value.docs.length;
      print(value.docs.length);
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }
}

class UsersTile extends StatefulWidget {
  final PupilsModel pupilModel;
  final int index;
  UsersTile({required this.pupilModel, required this.index});

  @override
  State<UsersTile> createState() => _UsersTileState();
}

class _UsersTileState extends State<UsersTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 0),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Colors.blueAccent,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return OpenQuiz(quizId);
                //     },
                //   ),
                // );
              },
              splashColor: Colors.green,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const SizedBox(
                          height: 5,
                        ),
                        //80% of screen width
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Name : ${widget.pupilModel.name}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start),
                              Text("Level : ${widget.pupilModel.level}",
                                  textAlign: TextAlign.start),
                              Text("Age : ${widget.pupilModel.age}",
                                  textAlign: TextAlign.start),
                              Text("Gender : ${widget.pupilModel.gender}",
                                  textAlign: TextAlign.start),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      onPressed: () async {
                                        var cdate = DateTime.now();
                                        var cdate2 =
                                            "${cdate.day}-${cdate.month}-${cdate.year}";
                                        print(cdate2);

                                        await FirebaseFirestore.instance
                                            .collection("attendance")
                                            .where("attendate_date",
                                                isEqualTo: cdate2)
                                            .where("st_id",
                                                isEqualTo: widget.pupilModel.id)
                                            .get()
                                            .then((value) {
                                          if (value.docs.length <= 0) {
                                            print("found");

                                            FirebaseFirestore.instance
                                                .collection("attendance")
                                                .add({
                                              "attendate_date": cdate2,
                                              "level": widget.pupilModel.level,
                                              "name": widget.pupilModel.name,
                                              "parent_id":
                                                  widget.pupilModel.parent_id,
                                              "st_id": widget.pupilModel.id,
                                              "status": "Present",
                                              "teacher_id": FirebaseAuth
                                                  .instance.currentUser!.uid
                                            }).then((value) {
                                              //save number of attendance
                                              //collection number attendees
                                              FirebaseFirestore.instance
                                                  .collection("attendees")
                                                  .where("st_id",
                                                      isEqualTo:
                                                          widget.pupilModel.id)
                                                  .get()
                                                  .then((value) {
                                                if (value.docs.length <= 0) {
                                                  FirebaseFirestore.instance
                                                      .collection("attendees")
                                                      .add({
                                                    "st_id":
                                                        widget.pupilModel.id,
                                                    "n_present": 1,
                                                    "n_absent": 0
                                                  });
                                                } else {
                                                  Map<String, dynamic>
                                                      studentAttendance =
                                                      value.docs.first.data();

                                                  int numAtt =
                                                      studentAttendance[
                                                          "n_present"];
                                                  String stId =
                                                      studentAttendance[
                                                          'st_id'];
                                                  int total = numAtt + 1;
                                                  print(stId);
                                                  print(total);
                                                  //update number of attendance times
                                                  var collection =
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'attendees');
                                                  collection
                                                      .where("st_id",
                                                          isEqualTo: stId)
                                                      .get()
                                                      .then((value) {
                                                    value.docs.length;
                                                    String docId =
                                                        value.docs.first.id;
                                                    print(docId);
                                                    collection
                                                        .doc(docId)
                                                        .update({
                                                      "n_present": total
                                                    }).whenComplete(() {
                                                      print("success");
                                                    });
                                                  });
                                                }
                                              });
                                              print(widget.pupilModel.phone);
                                              sendCredentialsToUser(
                                                      widget.pupilModel.name,
                                                      widget.pupilModel.phone,
                                                      "attended today")
                                                  .then((value) {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        content: const Text(
                                                            "Attendance Taken Successfully!"),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  "Close"))
                                                        ],
                                                      );
                                                    });
                                              });
                                              print(value);
                                            });
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: const Text(
                                                        "Already Attended today!"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                              "Close"))
                                                    ],
                                                  );
                                                });
                                          }
                                        });
                                      },
                                      child: const Text(
                                        "Present",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      )),
                                  TextButton(
                                      onPressed: () async {
                                        var cdate = DateTime.now();
                                        var cdate2 =
                                            "${cdate.day}-${cdate.month}-${cdate.year}";
                                        print(cdate2);

                                        await FirebaseFirestore.instance
                                            .collection("attendance")
                                            .where("attendate_date",
                                                isEqualTo: cdate2)
                                            .where("st_id",
                                                isEqualTo: widget.pupilModel.id)
                                            .get()
                                            .then((value) {
                                          if (value.docs.length <= 0) {
                                            FirebaseFirestore.instance
                                                .collection("attendance")
                                                .add({
                                              "attendate_date": cdate2,
                                              "level": widget.pupilModel.level,
                                              "name": widget.pupilModel.name,
                                              "parent_id":
                                                  widget.pupilModel.parent_id,
                                              "st_id": widget.pupilModel.id,
                                              "status": "Absent",
                                              "teacher_id": FirebaseAuth
                                                  .instance.currentUser!.uid
                                            }).then((value) {
                                              //save number of attendance
                                              //collection number attendees
                                              FirebaseFirestore.instance
                                                  .collection("attendees")
                                                  .where("st_id",
                                                      isEqualTo:
                                                          widget.pupilModel.id)
                                                  .get()
                                                  .then((value) {
                                                if (value.docs.length <= 0) {
                                                  FirebaseFirestore.instance
                                                      .collection("attendees")
                                                      .add({
                                                    "st_id":
                                                        widget.pupilModel.id,
                                                    "n_present": 0,
                                                    "n_absent": 1
                                                  });
                                                } else {
                                                  Map<String, dynamic>
                                                      studentAttendance =
                                                      value.docs.first.data();

                                                  int numAtt =
                                                      studentAttendance[
                                                          "n_absent"];
                                                  String stId =
                                                      studentAttendance[
                                                          'st_id'];
                                                  int total = numAtt + 1;
                                                  print(stId);
                                                  print(total);
                                                  //update number of attendance times
                                                  var collection =
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'attendees');
                                                  collection
                                                      .where("st_id",
                                                          isEqualTo: stId)
                                                      .get()
                                                      .then((value) {
                                                    // value.docs.length;
                                                    String docId =
                                                        value.docs.first.id;
                                                    print(docId);
                                                    collection
                                                        .doc(docId)
                                                        .update({
                                                      "n_absent": total
                                                    }).whenComplete(() {
                                                      print("success");
                                                    });
                                                  });
                                                }
                                              });
                                              print(widget.pupilModel.phone);
                                              sendCredentialsToUser(
                                                      widget.pupilModel.name,
                                                      widget.pupilModel.phone,
                                                      "absent today")
                                                  .then((value) {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        content: const Text(
                                                            "Attendance Taken Successfully!"),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  "Close"))
                                                        ],
                                                      );
                                                    });
                                              });
                                              print(value);
                                            });
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: const Text(
                                                        "Already Attended today!"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                              "Close"))
                                                    ],
                                                  );
                                                });
                                          }
                                        });
                                      },
                                      child: const Text(
                                        "Absent",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  TextButton(
                                      onPressed: () {},
                                      child: const Icon(
                                        Icons.edit_outlined,
                                        size: 30,
                                        color: Colors.orangeAccent,
                                      ))
                                ],
                              ),

                              //set present or absent
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendCredentialsToUser(
      String names, String tel, String sms) async {
    var headers = {
      'x-api-key': '136|moXSu4zlDA0bpzAyWw49rchY0IoRttvwsSU08DBE',
      'Content-Type': 'application/json'
    };
    var today = DateTime.now();
    print(tel);
    var request = http.Request('POST', Uri.parse('https://api.mista.io/sms'));
    request.body = convert.json.encode({
      "to": "25$tel",
      "from": "studperf",
      "unicode": "0",
      "sms": "Hello your student $names  $sms at  $today  \n Thank you",
      "action": "send-sms"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      setState(() {});
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<bool> verifyAttendence(String cdate2, String studentId) async {
    return true;
  }
}
