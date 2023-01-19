import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//database services
import '../Widgetsapp/AppBar.dart';
import '../models/course_content.dart';
import '../services/auth.dart';
import '../services/database_service.dart';
import '../widgets/Drawer.dart';

class ViewCourseContent extends StatefulWidget {
  final coourseId;
  String name;

  ViewCourseContent(this.coourseId, this.name);

  @override
  State<ViewCourseContent> createState() => _ViewCourseContentState();
}

String cname = "";
String csubcontent = "";

class _ViewCourseContentState extends State<ViewCourseContent> {
  bool _isLoading = false;
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
  //query snapshots
  QuerySnapshot? courseSnapshot;
  ContentModel getContentModelFromDatasnapshot(
      DocumentSnapshot courseSnapshot) {
    ContentModel contentModel = ContentModel(cname);
    contentModel.contentname = courseSnapshot['content-name'];

    return contentModel;
  }

  @override
  void initState() {
    print(widget.coourseId);
    databaseService.getCoursesContent(widget.coourseId).then((value) {
      setState(() {
        courseSnapshot = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      // appBar: PreferredSize(
      //       //     preferredSize: const Size.fromHeight(70), child: appBar(context)),
      appBar: CommonAppBar(
        title: "Course Content",
        menuenabled: true,
        notificationenabled: true,
        ontap: () {},
      ),
      drawer: appDrawer(context),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                "Content in ${widget.name}",
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              courseSnapshot == null
                  ? Container(
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const ClampingScrollPhysics(),
                      itemCount: courseSnapshot!.docs.length,
                      itemBuilder: (context, index) {
                        return UsersTile(
                          courseModel: getContentModelFromDatasnapshot(
                              courseSnapshot!.docs[index]),
                          index: index,
                        );
                      })
            ],
          ),
        ),
      ),

      //floating button
    );
  }
}

class UsersTile extends StatefulWidget {
  final ContentModel courseModel;
  final int index;
  UsersTile({required this.courseModel, required this.index});

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
                        const CircleAvatar(),
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
                              Text(
                                  "Content Name : ${widget.courseModel.contentname}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start),
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
}
