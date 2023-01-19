import 'package:final_year_4cs/screens/add_content_to_course.dart';
import 'package:flutter/material.dart';

//database services
import '../Widgetsapp/AppBar.dart';
import '../services/auth.dart';
import '../services/database_service.dart';
import '../widgets/Drawer.dart';
import 'grading.dart';
import 'view_course_content.dart';

class ViewCourses extends StatefulWidget {
  const ViewCourses({Key? key}) : super(key: key);

  @override
  State<ViewCourses> createState() => _ViewCoursesState();
}

class _ViewCoursesState extends State<ViewCourses> {
  Stream<dynamic>? courseStream;
  bool _isLoading = false;
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
  Widget teachersList() {
    return Container(
      child: StreamBuilder(
        stream: courseStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return UsersTile(
                      courseId: snapshot.data!.docs[index].data()['uid'],
                      name: snapshot.data.docs[index].data()["coursename"],
                      coursecode:
                          snapshot.data.docs[index].data()["coursecode"],
                      courselevel:
                          snapshot.data.docs[index].data()["courselevel"],
                      coursedesc:
                          snapshot.data.docs[index].data()["coursedesc"],
                    );
                  });
        },
      ),
    );
  }

  @override
  void initState() {
    databaseService.getCoursesData().then((value) async {
      setState(() {
        courseStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "All course",
        menuenabled: true,
        notificationenabled: true,
        ontap: () {},
      ),
      //appbar
      // appBar: PreferredSize(
      //     preferredSize: const Size.fromHeight(70), child: appBar(context)),
      drawer: appDrawer(context),
      body: teachersList(),

      //floating button
    );
  }
}

class UsersTile extends StatelessWidget {
  final String name;
  final String coursecode;
  final String courselevel;
  final String courseId;
  final String coursedesc;

  UsersTile(
      {required this.name,
      required this.coursecode,
      required this.courseId,
      required this.coursedesc,
      required this.courselevel});

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
              onTap: () {},
              splashColor: Colors.green,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            AssetImage('assets/images/library.png'),
                        // backgroundImage: NetworkImage(
                        //   'https://digitallearning.eletsonline.com/wp-content/uploads/2019/03/Online-courses.jpg',
                        // ),
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
                            Text(name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start),
                            Text(coursecode, textAlign: TextAlign.start),
                            Text(courselevel, textAlign: TextAlign.start),
                            Text(coursedesc,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ViewCourseContent(
                                                coursecode, name);
                                          },
                                        ),
                                      );
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
                                            return AddContentToCourse(
                                                coursecode);
                                          },
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Add New",
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
                                            return Grading(
                                                coursecode: coursecode,
                                                courselevel: courselevel,
                                                coursename: name);
                                          },
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Grading",
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
