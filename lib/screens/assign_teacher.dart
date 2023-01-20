import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:final_year_4cs/screens/backgrounds/background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//database services
import '../Widgetsapp/AppBar.dart';
import '../components/text_field_container.dart';
import '../constants.dart';
import '../services/database_service.dart';
import '../widgets/Drawer.dart';

class AssignTeacher extends StatefulWidget {
  final String teacher_id, teacher_phone, name;

  AssignTeacher(
      {required this.teacher_id,
      required this.teacher_phone,
      required this.name});

  @override
  State<AssignTeacher> createState() => _AssignTeacherState();
}

final _listLevel = ["P1", "P2", "P3", "P4", "P5", "P6"];
String? coursecode;

class _AssignTeacherState extends State<AssignTeacher> {
  _AssignTeacherState() {
    _selectedResult = _listLevel[0];
  }

  final _formkey = GlobalKey<FormState>();

  late String _selectedResult;

  //adding controller
  final TextEditingController coursenameController = TextEditingController();
  final TextEditingController courselevelController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
  final _firestore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _courseStream =
      FirebaseFirestore.instance.collection('Courses').snapshots();
  String coursename = "", coursedesc = "", courselevel = "", coursecode = "";
  Future<void> checkLevel() async {
    await _firestore
        .collection("Courses")
        .where("coursecode", isEqualTo: coursecode)
        .get()
        .then((value) {
      Map<String, dynamic> names = value.docs.first.data();

      setState(() {
        coursename = names["coursename"];
        courselevel = names["courselevel"];
        print(coursename);
        print(courselevel);
      });
    });
  }

  Future AssignTeacher() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await FirebaseFirestore.instance
          .collection('Teacherclass')
          // .where('teacher_id', isEqualTo: widget.teacher_id)
          .where("courselevel", isEqualTo: courselevel)
          .where("coursecode", isEqualTo: coursecode)
          .get()
          .then((value) async {
        // print(coursecodeController.text.toString());
        if (value.size == 1) {
          print('Teacher already assigned this course and level');
          setState(() {
            // const snackBar = SnackBar(
            //     content: Text(
            //       "Teacher already assigned this course and level",
            //       style: TextStyle(
            //         color: Colors.red,
            //         fontSize: 18,
            //       ),
            //     ),
            //     duration: Duration(seconds: 2));
            // messengerKey.currentState!.showSnackBar(snackBar);
            _isLoading = false;
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: const Text(
                      "This course already have a teacher!",
                      style: TextStyle(color: Colors.redAccent, fontSize: 14),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("close"))
                    ],
                  );
                });
          });
        } else {
          final user = FirebaseAuth.instance.currentUser;
          await _firestore.collection("Teacherclass").add({
            "admin_id": user!.uid,
            "teacher_id": widget.teacher_id,
            "teacher_name": widget.name,
            "teacher_phone": widget.teacher_phone,
            "coursename": coursename,
            "coursecode": coursecode,
            "courselevel": courselevel,
          }).then((value) {
            setState(() {
              _isLoading = false;
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text(
                          "Teacher assigned to course successfully!"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("ok"))
                      ],
                    );
                  });
            });
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final teachernameField = TextFieldContainer(
      child: TextFormField(
        autofocus: false,
        controller: coursenameController,
        keyboardType: TextInputType.text,
        onSaved: (value) {
          coursenameController.text = value!;
        },
        readOnly: true,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.person_pin,
            color: kPrimaryColor,
          ),
          hintText: "Teacher Name: ${widget.name}",
          border: InputBorder.none,
        ),
        onChanged: (val) {
          coursename = val;
        },
      ),
    );
    final coursenameField = TextFieldContainer(
      child: TextFormField(
        autofocus: false,
        controller: courselevelController,
        keyboardType: TextInputType.text,
        onSaved: (value) {
          courselevelController.text = value!;
        },
        readOnly: true,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.subject_outlined,
            color: kPrimaryColor,
          ),
          hintText: "course level:$courselevel",
          border: InputBorder.none,
        ),
        onChanged: (val) {
          courselevel = val;
        },
      ),
    );
    final courselevelField = TextFieldContainer(
      child: TextFormField(
        autofocus: false,
        controller: coursenameController,
        keyboardType: TextInputType.text,
        onSaved: (value) {
          coursenameController.text = value!;
        },
        readOnly: true,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.class_outlined,
            color: kPrimaryColor,
          ),
          hintText: "course name: $coursename",
          border: InputBorder.none,
        ),
        onChanged: (val) {
          courselevel = val;
        },
      ),
    );
    //quiz title field
    final assignBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: kPrimaryColor,
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
        minWidth: MediaQuery.of(context).size.width * 0.4,
        onPressed: () async {
          await AssignTeacher();
        },
        child: const Text(
          'ASSIGN',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );

    final backBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.white30,
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
        minWidth: MediaQuery.of(context).size.width * 0.4,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text(
          'BACK',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black45,
          ),
        ),
      ),
    );
    return Scaffold(
      // appBar: PreferredSize(
      //     preferredSize: const Size.fromHeight(70), child: appBar(context)),
      appBar: CommonAppBar(
        title: "Assign Teacher",
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
                      "ASSIGNING TEACHER TO CLASS OR LEVEL",
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
                    teachernameField,
                    const SizedBox(
                      height: 25,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: _courseStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }
                          if (snapshot.hasData == null) {
                            return Text("NO child");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          print(snapshot.hasData);
                          return Transform(
                            transform: Matrix4.translationValues(0, 0, 0),
                            child: TextFieldContainer(
                              child: DropdownSearch<String>(
                                popupProps: PopupProps.menu(
                                  showSelectedItems: true,
                                  showSearchBox: true,
                                  disabledItemFn: (String s) =>
                                      s.startsWith('I'),
                                ),
                                dropdownDecoratorProps:
                                    const DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    hintText: "Please Select course",
                                    border: InputBorder.none,
                                  ),
                                ),
                                validator: (v) =>
                                    v == null ? "required field" : null,
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                // enabled: true, // hint: "Please Select Leave type",
                                // mode: Mode.MENU,
                                // showSelectedItem: true,
                                items: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                      Map<String, dynamic> data = document
                                          .data()! as Map<String, dynamic>;

                                      return data["coursecode"];
                                    })
                                    .toList()
                                    .cast<String>(),
                                onSaved: (val) {
                                  coursecode = val!;
                                },
                                onChanged: (val) {
                                  coursecode = val!;

                                  print(coursecode);
                                  checkLevel();
                                },

                                // showClearButton: true,
                                // onChanged: print,
                              ),
                            ),
                          );
                        }),
                    SizedBox(
                      height: 25,
                    ),
                    coursenameField,
                    SizedBox(
                      height: 25,
                    ),
                    courselevelField,
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        assignBtn,
                        backBtn,
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
