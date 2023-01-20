import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_4cs/screens/backgrounds/background.dart';
import 'package:final_year_4cs/screens/view_courses.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//database services
import '../Widgetsapp/AppBar.dart';
import '../components/text_field_container.dart';
import '../constants.dart';
import '../services/database_service.dart';
import '../utils/utils.dart';
import '../widgets/Drawer.dart';

class AddCourses extends StatefulWidget {
  @override
  State<AddCourses> createState() => _AddCoursesState();
}

final _listLevel = ["P1", "P2", "P3", "P4", "P5", "P6"];

class _AddCoursesState extends State<AddCourses> {
  _AddCoursesState() {
    _selectedResult = _listLevel[0];
  }

  final _formkey = GlobalKey<FormState>();
  String coursename = "", coursedesc = "", courselevel = "", coursecode = "";
  String? _initialValue;
  late String _selectedResult;
  //adding controller
  final TextEditingController coursenameController = TextEditingController();
  final TextEditingController coursedescController = TextEditingController();
  final TextEditingController courselevelController = TextEditingController();
  final TextEditingController coursecodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _initialValue = '';
    // _selectedResult = "";
    Intl.defaultLocale = 'pt_BR';
    _getValue();
  }

  Future<void> _getValue() async {
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {});
    });
  }

  //database service
  bool _isLoading = false;
  DatabaseService databaseService = DatabaseService();
  Future savCourserData() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await FirebaseFirestore.instance
          .collection('Courses')
          .where('coursecode', isEqualTo: coursecodeController.text.toString())
          .get()
          .then((value) async {
        // print(coursecodeController.text.toString());
        if (value.size == 1) {
          print('course already exist');
          setState(() {
            const snackBar = SnackBar(
                content: Text(
                  "course already exist!",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
                duration: Duration(seconds: 2));
            messengerKey.currentState!.showSnackBar(snackBar);
            _isLoading = false;
          });
        } else {
          final user = FirebaseAuth.instance.currentUser;

          Map<String, String> courseData = {
            "tid": user!.uid,
            "coursename": coursename,
            "coursecode": coursecode,
            "coursedesc": coursedesc,
            "courselevel": _selectedResult,
          };
          await databaseService
              .addCourses(courseData, coursecode)
              .then((value) {
            setState(() {
              _isLoading = false;
            });
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final coursenameField = TextFieldContainer(
      child: TextFormField(
        autofocus: false,
        controller: coursenameController,
        keyboardType: TextInputType.text,
        onSaved: (value) {
          coursenameController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.golf_course,
            color: kPrimaryColor,
          ),
          hintText: "Course Name",
          border: InputBorder.none,
        ),
        onChanged: (val) {
          coursename = val;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (input) => input != null && input.isEmpty
            ? 'Course name is required please..'
            : null,
      ),
    );
    //quiz title field
    final coursecodeField = TextFieldContainer(
      child: TextFormField(
        autofocus: false,
        controller: coursecodeController,
        onSaved: (value) {
          coursecodeController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.qr_code_2_outlined,
            color: kPrimaryColor,
          ),
          hintText: "Course Code",
          border: InputBorder.none,
        ),
        onChanged: (val) {
          coursecode = val;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (input) => input != null && input.length < 1
            ? 'Course code is required'
            : null,
      ),
    );
    final coursedescField = TextFieldContainer(
      child: TextFormField(
        autofocus: false,
        controller: coursedescController,
        onSaved: (value) {
          coursedescController.text = value!;
        },
        textInputAction: TextInputAction.next,
        maxLines: 2,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.description_outlined,
            color: kPrimaryColor,
          ),
          hintText: "Course Description",
          border: InputBorder.none,
        ),
        onChanged: (val) {
          coursedesc = val;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (input) => input != null && input.length < 1
            ? 'Course  description is required'
            : null,
      ),
    );
    final addcourseBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: kPrimaryColor,
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
        minWidth: MediaQuery.of(context).size.width * 0.4,
        onPressed: () async {
          await savCourserData();
        },
        child: const Text(
          'ADD COURSE',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );

    final addcontentBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: kPrimaryColor,
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
        minWidth: MediaQuery.of(context).size.width * 0.4,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ViewCourses();
              },
            ),
          );
        },
        child: const Text(
          'ADD CONTENT',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
    return Scaffold(
      // appBar: PreferredSize(
      //     preferredSize: const Size.fromHeight(70), child: appBar(context)),
      appBar: CommonAppBar(
        title: "Create Courses",
        menuenabled: true,
        notificationenabled: true,
        ontap: () {},
      ),
      drawer: appDrawer(context),
      body: Background(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "CREATE COURSES",
                      style: TextStyle(
                        letterSpacing: 3,
                        fontSize: 22,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    coursenameField,
                    const SizedBox(
                      height: 25,
                    ),
                    coursecodeField,
                    const SizedBox(
                      height: 25,
                    ),
                    coursedescField,
                    const SizedBox(
                      height: 25,
                    ),
                    TextFieldContainer(
                      child: DropdownButtonFormField(
                          value: _selectedResult,
                          items: _listLevel
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedResult = val as String;
                              print(_selectedResult);
                            });
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
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        addcourseBtn,
                        addcontentBtn,
                      ],
                    ),
                    _isLoading
                        ? Container(
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container(
                            child: null,
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
