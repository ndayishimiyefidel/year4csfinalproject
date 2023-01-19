import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:final_year_4cs/screens/view_courses.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//database services
import '../services/database_service.dart';
import '../utils/utils.dart';
import '../widgets/Drawer.dart';
import '../widgets/appBar.dart';

class AddCourses extends StatefulWidget {
  @override
  State<AddCourses> createState() => _AddCoursesState();
}

class _AddCoursesState extends State<AddCourses> {
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
    _initialValue = '';
    _selectedResult = "";
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
        print(coursecodeController.text.toString());
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
          _selectedResult = _initialValue!;

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
    final coursenameField = TextFormField(
      autofocus: false,
      controller: coursenameController,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        coursenameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
          ),
        ),
        prefixIcon: const Icon(
          Icons.golf_course,
          color: Colors.green,
        ),
        filled: true,
        fillColor: Colors.green[50],
        labelText: "Course Name",
        labelStyle: const TextStyle(color: Colors.green),
      ),
      onChanged: (val) {
        coursename = val;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (input) => input != null && input.length < 1
          ? 'Course name is required please..'
          : null,
    );
    //quiz title field
    final coursecodeField = TextFormField(
      autofocus: false,
      controller: coursecodeController,
      onSaved: (value) {
        coursecodeController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
          ),
        ),
        prefixIcon: const Icon(
          Icons.qr_code_2_outlined,
          color: Colors.green,
        ),
        filled: true,
        fillColor: Colors.green[50],
        labelText: "Enter Course Code",
        labelStyle: const TextStyle(color: Colors.green),
      ),
      onChanged: (val) {
        coursecode = val;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (input) =>
          input != null && input.length < 1 ? 'Course code is required' : null,
    );
    final coursedescField = TextFormField(
      autofocus: false,
      controller: coursedescController,
      onSaved: (value) {
        coursedescController.text = value!;
      },
      textInputAction: TextInputAction.next,
      maxLines: 2,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
          ),
        ),
        prefixIcon: const Icon(
          Icons.description,
          color: Colors.green,
        ),
        filled: true,
        fillColor: Colors.green[50],
        labelText: "Course Description",
        labelStyle: const TextStyle(color: Colors.green),
      ),
      onChanged: (val) {
        coursedesc = val;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (input) => input != null && input.length < 1
          ? 'Course  description is required'
          : null,
    );
    final addcourseBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.blue[300],
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
        minWidth: MediaQuery.of(context).size.width * 0.3,
        onPressed: () {
          savCourserData();
        },
        child: const Text(
          'Add course',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70), child: appBar(context)),
      drawer: appDrawer(context),
      body: _isLoading
          ? Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: _isLoading
                      ? Container(
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Form(
                          key: _formkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "Create Course",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Feel free to create course,it's simple and easy!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const SizedBox(
                                height: 45,
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
                                  setState(() {
                                    _initialValue = value;
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
                                height: 25,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  addcourseBtn,
                                  TextButton(
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
                                        "Add content",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                ],
                              ),
                              const SizedBox(
                                height: 45,
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
    );
  }
}
