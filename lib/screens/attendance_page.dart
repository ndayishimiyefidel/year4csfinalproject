import 'dart:convert' as convert;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_4cs/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//database services
import '../Widgetsapp/AppBar.dart';
import '../components/text_field_container.dart';
import '../models/pupil_model.dart';
import '../services/auth.dart';
import '../services/database_service.dart';
import '../widgets/Drawer.dart';

class AttendancePage extends StatefulWidget {
  final String coursecode;
  final String coursename;
  final String courselevel;

  AttendancePage(
      {required this.coursecode,
      required this.coursename,
      required this.courselevel});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

late String _selectedTerm;

String name = "";
String level = "";
String age = "";
String gender = "";
String id = "", phone = "";
String parent_id = "";
String cname = "", ccode = "";
final _listTerm = ["TERM I", "TERM II", "TERM III"];

class _AttendancePageState extends State<AttendancePage> {
  _AttendancePageState() {
    _selectedTerm = _listTerm[0];
  }
  List<PupilsModel> students = [];

  int? number;
  @override
  void initState() {
    super.initState();

    getPupilsDataByLevel(widget.courselevel).then((value) async {
      setState(() {
        pupilsSnapshot = value;
      });
    });
    _selectedTerm = _listTerm[0];

    super.initState();
  }

  Stream<dynamic>? pupilsStream;
  bool _isLoading = false;
  final _firestore = FirebaseFirestore.instance;
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
  //query snapshots
  QuerySnapshot? pupilsSnapshot;
  PupilsModel getPupilModelFromDatasnapshot(DocumentSnapshot pupilsSnapshot) {
    PupilsModel pupilModel = PupilsModel(
        name, age, gender, level, id, phone, parent_id, cname, ccode);
    pupilModel.name = pupilsSnapshot['name'];
    pupilModel.age = pupilsSnapshot['age'];
    pupilModel.level = pupilsSnapshot['level'];
    pupilModel.gender = pupilsSnapshot['gender'];
    pupilModel.phone = pupilsSnapshot["parent_phone"];
    pupilModel.parent_id = pupilsSnapshot["parent_id"];
    pupilModel.id = pupilsSnapshot["uid"];
    pupilModel.coursecode = widget.coursecode;
    pupilModel.coursename = widget.coursename;
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
            padding:
                const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "SELECT TERM",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontFamily: '',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                // StreamBuilder<QuerySnapshot>(
                //     stream: _teacherStream,
                //     builder: (BuildContext context,
                //         AsyncSnapshot<QuerySnapshot> snapshot) {
                //       if (snapshot.hasError) {
                //         return Text('Something went wrong');
                //       }
                //       if (snapshot.hasData == null) {
                //         return Text("NO data");
                //       }
                //
                //       if (snapshot.connectionState == ConnectionState.waiting) {
                //         return CircularProgressIndicator();
                //       }
                //       print(snapshot.hasData);
                //       return Transform(
                //         transform: Matrix4.translationValues(0, 0, 0),
                //         child: TextFieldContainer(
                //           child: DropdownSearch<String>(
                //             popupProps: PopupProps.menu(
                //               showSelectedItems: true,
                //               showSearchBox: true,
                //               disabledItemFn: (String s) => s.startsWith('I'),
                //             ),
                //             dropdownDecoratorProps:
                //                 const DropDownDecoratorProps(
                //               dropdownSearchDecoration: InputDecoration(
                //                 hintText: "Please Select course",
                //                 border: InputBorder.none,
                //               ),
                //             ),
                //             validator: (v) =>
                //                 v == null ? "required field" : null,
                //             autoValidateMode:
                //                 AutovalidateMode.onUserInteraction,
                //             // enabled: true, // hint: "Please Select Leave type",
                //             // mode: Mode.MENU,
                //             // showSelectedItem: true,
                //             items: snapshot.data!.docs
                //                 .map((DocumentSnapshot document) {
                //                   Map<String, dynamic> data =
                //                       document.data()! as Map<String, dynamic>;
                //
                //                   return data["courselevel"];
                //                 })
                //                 .toList()
                //                 .cast<String>(),
                //             onSaved: (val) {
                //               _selectedResult = val!;
                //             },
                //             onChanged: (val) {
                //               setState(() {
                //                 _selectedResult = val!;
                //
                //                 print(_selectedResult);
                //                 // _selectedResult = val as String;
                //                 getPupilsDataByLevel(val).then((value) async {
                //                   setState(() {
                //                     pupilsSnapshot = value;
                //                   });
                //                 });
                //               });
                //             },
                //
                //             // showClearButton: true,
                //             // onChanged: print,
                //           ),
                //         ),
                //       );
                //     }),

                TextFieldContainer(
                  child: DropdownButtonFormField(
                      value: _selectedTerm,
                      items: _listTerm
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedTerm = val!;
                          print(_selectedTerm);
                        });
                        // setState(() {
                        //   _selectedResult = val as String;
                        //   getPupilsDataByLevel(val).then((value) async {
                        //     setState(() {
                        //       pupilsSnapshot = value;
                        //     });
                        //   });
                        // });
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down_circle,
                        // color: kPrimaryColor,
                      ),
                      dropdownColor: Colors.white,
                      decoration: const InputDecoration(
                        hintText: "Select Level",
                        border: InputBorder.none,
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "$number Pupil(s) in Level  ${widget.courselevel}",
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
                Container(
                  width: 650,
                  height: 100,
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Course code : ${widget.coursecode}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Course Name : ${widget.coursename}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
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
          element.data()['parent_id'],
          widget.coursecode,
          widget.coursename,
        );

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
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: kPrimaryColor,
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
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
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
                          // Text("Course code : ${widget.pupilModel.coursecode}",
                          //     textAlign: TextAlign.start),
                          // Text("Course Name : ${widget.pupilModel.coursename}",
                          //
                          //     textAlign: TextAlign.start),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    var cdate = DateTime.now();
                                    var cdate2 =
                                        "${cdate.day}-${cdate.month}-${cdate.year}";
                                    print(cdate2);

                                    await FirebaseFirestore.instance
                                        .collection("attendance")
                                        .where("coursecode",
                                            isEqualTo:
                                                widget.pupilModel.coursecode)
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
                                          "coursecode":
                                              widget.pupilModel.coursecode,
                                          "coursename":
                                              widget.pupilModel.coursename,
                                          "name": widget.pupilModel.name,
                                          "parent_id":
                                              widget.pupilModel.parent_id,
                                          "st_id": widget.pupilModel.id,
                                          "status": "Present",
                                          "term": _selectedTerm,
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
                                                "st_id": widget.pupilModel.id,
                                                "n_present": 1,
                                                "n_absent": 0
                                              });
                                            } else {
                                              Map<String, dynamic>
                                                  studentAttendance =
                                                  value.docs.first.data();

                                              int numAtt = studentAttendance[
                                                  "n_present"];
                                              String stId =
                                                  studentAttendance['st_id'];
                                              int total = numAtt + 1;
                                              print(stId);
                                              print(total);
                                              //update number of attendance times
                                              var collection = FirebaseFirestore
                                                  .instance
                                                  .collection('attendees');
                                              collection
                                                  .where("st_id",
                                                      isEqualTo: stId)
                                                  .get()
                                                  .then((value) {
                                                value.docs.length;
                                                String docId =
                                                    value.docs.first.id;
                                                print(docId);
                                                collection.doc(docId).update({
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
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text("Close"))
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
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  )),
                              const SizedBox(
                                width: 50,
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    var cdate = DateTime.now();
                                    var cdate2 =
                                        "${cdate.day}-${cdate.month}-${cdate.year}";
                                    print(cdate2);

                                    await FirebaseFirestore.instance
                                        .collection("attendance")
                                        .where("coursecode",
                                            isEqualTo:
                                                widget.pupilModel.coursecode)
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
                                          "coursecode":
                                              widget.pupilModel.coursecode,
                                          "coursename":
                                              widget.pupilModel.coursename,
                                          "name": widget.pupilModel.name,
                                          "term": _selectedTerm,
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
                                                "st_id": widget.pupilModel.id,
                                                "n_present": 0,
                                                "n_absent": 1
                                              });
                                            } else {
                                              Map<String, dynamic>
                                                  studentAttendance =
                                                  value.docs.first.data();

                                              int numAtt =
                                                  studentAttendance["n_absent"];
                                              String stId =
                                                  studentAttendance['st_id'];
                                              int total = numAtt + 1;
                                              print(stId);
                                              print(total);
                                              //update number of attendance times
                                              var collection = FirebaseFirestore
                                                  .instance
                                                  .collection('attendees');
                                              collection
                                                  .where("st_id",
                                                      isEqualTo: stId)
                                                  .get()
                                                  .then((value) {
                                                // value.docs.length;
                                                String docId =
                                                    value.docs.first.id;
                                                print(docId);
                                                collection.doc(docId).update({
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
                                                      ElevatedButton(
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
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text("Close"))
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
                            ],
                          ),

                          //set present or absent
                        ],
                      ),
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
