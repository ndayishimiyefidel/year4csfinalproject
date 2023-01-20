import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//database services
import '../Widgetsapp/AppBar.dart';
import '../models/pupil_model.dart';
import '../services/auth.dart';
import '../services/database_service.dart';
import '../widgets/Drawer.dart';

class ViewPupils extends StatefulWidget {
  final uid;
  final String name;

  ViewPupils(this.uid, this.name);

  @override
  State<ViewPupils> createState() => _ViewPupilsState();
}

String name = "";
String level = "";
String age = "";
String gender = "";
String pupil_id = "";
int num = 0;

class _ViewPupilsState extends State<ViewPupils> {
  Stream<dynamic>? pupilsStream;
  bool _isLoading = false;
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
  //query snapshots
  QuerySnapshot? pupilsSnapshot;
  PupilsModel getPupilModelFromDatasnapshot(DocumentSnapshot pupilsSnapshot) {
    PupilsModel pupilModel =
        PupilsModel(name, age, gender, level, pupil_id, "", "", "", "");
    pupilModel.name = pupilsSnapshot['name'];
    pupilModel.age = pupilsSnapshot['age'];
    pupilModel.level = pupilsSnapshot['level'];
    pupilModel.gender = pupilsSnapshot['gender'];
    pupilModel.id = pupilsSnapshot['pupil_id'];
    return pupilModel;
  }

  @override
  void initState() {
    databaseService.getParentChildrens(widget.uid).then((value) async {
      setState(() {
        pupilsSnapshot = value;
        num = value.docs.length;
        print(num);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      // appBar: PreferredSize(
      //     preferredSize: const Size.fromHeight(70), child: appBar(context)),
      // drawer: appDrawer(context),
      appBar: CommonAppBar(
        title: "Pupils",
        menuenabled: true,
        notificationenabled: true,
        ontap: () {
          // _scaffoldKey.currentState!.openDrawer();
        },
      ),
      drawer: appDrawer(context),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              pupilsSnapshot == null
                  ? Text(
                      "No  pupils : ${widget.name}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      "${num} Pupil(s) for ${widget.name}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              pupilsSnapshot == null
                  ? Container(
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const ClampingScrollPhysics(),
                      itemCount: pupilsSnapshot!.docs.length,
                      itemBuilder: (context, index) {
                        return UsersTile(
                          pupilModel: getPupilModelFromDatasnapshot(
                              pupilsSnapshot!.docs[index]),
                          index: index,
                        );
                      })
            ],
          ),
        ),
      ),
    );
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
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Registration Number : ${widget.pupilModel.id}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start),
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
