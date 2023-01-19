import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//database services
import '../services/auth.dart';
import '../services/database_service.dart';
import '../widgets/Drawer.dart';
import '../widgets/appBar.dart';

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
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70), child: appBar(context)),
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

  UsersTile(
      {required this.name,
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
                        padding: const EdgeInsets.all(16.0),
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
