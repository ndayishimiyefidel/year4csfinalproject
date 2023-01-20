import 'package:final_year_4cs/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//database services
import '../Widgetsapp/AppBar.dart';
import '../services/auth.dart';
import '../services/database_service.dart';
import '../widgets/Drawer.dart';
import 'assign_teacher.dart';

class ViewTeachers extends StatefulWidget {
  const ViewTeachers({Key? key}) : super(key: key);

  @override
  State<ViewTeachers> createState() => _ViewTeachersState();
}

class _ViewTeachersState extends State<ViewTeachers> {
  Stream<dynamic>? quizStream;
  bool _isLoading = false;
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
  final user = FirebaseAuth.instance.currentUser;

  Widget teachersList() {
    return StreamBuilder(
      stream: quizStream,
      builder: (context, snapshot) {
        return snapshot.data == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return UsersTile(
                    uid: snapshot.data!.docs[index].data()['uid'],
                    photourl: snapshot.data!.docs[index].data()["photoUrl"],
                    name: snapshot.data.docs[index].data()["name"],
                    email: snapshot.data.docs[index].data()["email"],
                    phone: snapshot.data.docs[index].data()["phone"],
                    degree: snapshot.data.docs[index].data()["degree"],
                    qualification:
                        snapshot.data.docs[index].data()["qualification"],
                  );
                });
      },
    );
  }

  @override
  void initState() {
    databaseService.getTeacherData().then((value) async {
      setState(() {
        quizStream = value;
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
        title: "Teachers",
        menuenabled: true,
        notificationenabled: true,
        ontap: () {
          // _scaffoldKey.currentState!.openDrawer();
        },
      ),
      drawer: appDrawer(context),
      body: teachersList(),

      //floating button
    );
  }
}

class UsersTile extends StatelessWidget {
  final String photourl;
  final String name;
  final String email;
  final String phone;
  final String uid;
  final String qualification;
  final String degree;

  UsersTile(
      {required this.name,
      required this.photourl,
      required this.email,
      required this.uid,
      required this.degree,
      required this.qualification,
      required this.phone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox(
                        height: 5,
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          photourl.toString(),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      //80% of screen width
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Teacher Name: $name",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start),
                            Text("Email : $email", textAlign: TextAlign.start),
                            Text("Telphone: $phone",
                                textAlign: TextAlign.start),
                            Text("Hold $degree  in" " $qualification",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) {
                                      //       // return ViewCourseContent(
                                      //       //     coursecode, name);
                                      //       return AttendancePage(
                                      //         coursecode: coursecode,
                                      //         coursename: name,
                                      //         courselevel: courselevel,
                                      //       );
                                      //     },
                                      //   ),
                                      // );
                                    },
                                    child: const Text(
                                      "View class",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return AssignTeacher(
                                              teacher_id: uid,
                                              teacher_phone: phone,
                                              name: name,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Assign level",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
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
