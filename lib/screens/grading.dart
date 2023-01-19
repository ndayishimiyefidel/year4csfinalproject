import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//database services
import '../services/auth.dart';
import '../services/database_service.dart';
import '../widgets/Drawer.dart';
import '../widgets/appBar.dart';
import 'add_marks.dart';

class Grading extends StatefulWidget {
  final String coursecode, courselevel, coursename;

  Grading(
      {required this.coursecode,
      required this.courselevel,
      required this.coursename});

  @override
  State<Grading> createState() => _GradingState();
}

class _GradingState extends State<Grading> {
  Stream<dynamic>? pupilStream;
  final bool _isLoading = false;
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
  final user = FirebaseAuth.instance.currentUser;

  Widget pupilsList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collectionGroup("Pupils")
          .where("level", isEqualTo: widget.courselevel)
          .snapshots(),
      builder: (context, snapshot) {
        return snapshot.data == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return UsersTile(
                    id: snapshot.data!.docs[index].data()["pupil_id"],
                    name: snapshot.data!.docs[index].data()["name"],
                    age: snapshot.data!.docs[index].data()["age"],
                    gender: snapshot.data!.docs[index].data()["gender"],
                    level: snapshot.data!.docs[index].data()["level"],
                    parent_id: snapshot.data!.docs[index].data()["parent_id"],
                    parent_phone:
                        snapshot.data!.docs[index].data()["parent_phone"],
                    coursecode: widget.coursecode,
                    courselevel: widget.courselevel,
                    coursename: widget.coursename,
                  );
                });
      },
    );
  }

  @override
  void initState() {
    databaseService.getAllPupilsData().then((value) {
      setState(() {
        pupilStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70), child: appBar(context)),
      drawer: appDrawer(context),
      body: pupilsList(),

      //floating button
    );
  }
}

class UsersTile extends StatelessWidget {
  final String coursecode, courselevel, coursename;

  final String id;
  final String name;
  final String gender;
  final String age;
  final String level;
  final String parent_id;
  final String parent_phone;

  UsersTile(
      {required this.id,
      required this.name,
      required this.level,
      required this.gender,
      required this.age,
      required this.parent_id,
      required this.parent_phone,
      required this.coursecode,
      required this.courselevel,
      required this.coursename});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox(
                        height: 5,
                      ),
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            "https://cdn-icons-png.flaticon.com/512/3135/3135715.png"
                            // photourl.toString(),
                            ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      //80% of screen width
                      Container(
                        padding: const EdgeInsets.all(14.0),
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Names: $name",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start),
                            Text("Age: $age", textAlign: TextAlign.start),
                            Text("Gender: $gender", textAlign: TextAlign.start),
                            Text("Level: $level", textAlign: TextAlign.start),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) {
                                      //       return ViewCourseContent(
                                      //           coursecode, name);
                                      //     },
                                      //   ),
                                      // );
                                    },
                                    child: const Text(
                                      "View",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return AddMarks(
                                              coursecode: coursecode,
                                              pupil_name: name,
                                              level: courselevel,
                                              coursename: coursename,
                                              parent_phone: parent_phone,
                                              parent_id: parent_id,
                                              pupil_id: id,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Add marks",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) {
                                      //       return Grading(
                                      //           coursecode: coursecode,
                                      //           courselevel: courselevel,
                                      //           coursename: name);
                                      //     },
                                      //   ),
                                      // );
                                    },
                                    child: const Text(
                                      "marks",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ))
                              ],
                            ),
                          ],
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
    );
  }
}
