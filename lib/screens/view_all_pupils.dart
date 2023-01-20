import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//database services
import '../Widgetsapp/AppBar.dart';
import '../services/auth.dart';
import '../services/database_service.dart';
import '../widgets/Drawer.dart';

class ViewAllPupils extends StatefulWidget {
  const ViewAllPupils({Key? key}) : super(key: key);

  @override
  State<ViewAllPupils> createState() => _ViewAllPupilsState();
}

class _ViewAllPupilsState extends State<ViewAllPupils> {
  Stream<dynamic>? pupilStream;
  final bool _isLoading = false;
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
  final user = FirebaseAuth.instance.currentUser;

  Widget pupilsList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collectionGroup("Pupils").snapshots(),
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
      appBar: CommonAppBar(
        title: "All Pupils",
        menuenabled: true,
        notificationenabled: true,
        ontap: () {
          // _scaffoldKey.currentState!.openDrawer();
        },
      ),
      drawer: appDrawer(context),
      body: pupilsList(),

      //floating button
    );
  }
}

class UsersTile extends StatelessWidget {
  final String name;
  final String gender;
  final String age;
  final String level;
  final String id;

  UsersTile(
      {required this.name,
      required this.id,
      required this.level,
      required this.gender,
      required this.age});

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
                  padding: const EdgeInsets.only(
                    left: 8,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Registration Number : $id",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start),
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
                                ElevatedButton(
                                  onPressed: () {
                                    //view mark report
                                  },
                                  child: const Text(
                                    "Marks Report",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Attendance Report",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
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
