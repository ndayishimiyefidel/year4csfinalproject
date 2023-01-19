import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Widgetsapp/AppBar.dart';
import '../Widgetsapp/BouncingButton.dart';
import '../services/auth.dart';
import '../services/database_service.dart';
import '../utils/utils.dart';
import '../widgets/Drawer.dart';

class AddMarks extends StatefulWidget {
  final String coursecode,
      pupil_name,
      pupil_id,
      level,
      coursename,
      parent_id,
      parent_phone;

  AddMarks(
      {required this.coursecode,
      required this.pupil_name,
      required this.pupil_id,
      required this.level,
      required this.coursename,
      required this.parent_id,
      required this.parent_phone});

  @override
  _AddMarksState createState() => _AddMarksState();
}

class _AddMarksState extends State<AddMarks>
    with SingleTickerProviderStateMixin {
  late Animation animation, delayedAnimation, muchDelayedAnimation, LeftCurve;
  late AnimationController animationController;
  final searchFieldController = TextEditingController();
  late TextEditingController descFieldController;
  late TextEditingController marksFieldController;

  late TextEditingController _applyleavecontroller;
  String _applyleavevalueChanged = '';
  String _applyleavevalueToValidate = '';
  String _applyleavevalueSaved = '';

  String applyleavedate = "";
  String fromdate = "";
  String todate = "";
  String desc = "";
  String markstype = "";
  String name = "";
  int marks = 0;
  String outof = "";

  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //SystemChrome.setEnabledSystemUIOverlays([]);
    descFieldController = TextEditingController();
    marksFieldController = TextEditingController();

    _applyleavecontroller = TextEditingController();
    animationController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    delayedAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 0.5, curve: Curves.fastOutSlowIn)));

    muchDelayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.3, 0.5, curve: Curves.fastOutSlowIn)));

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<FormState> _formkey = new GlobalKey<FormState>();
  Future saveMarks() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      print(userId);
      // Map<String, dynamic> userData = value.docs.first.data();
      // print(userData['email']);
      // var finalMarks = int.parse(marks);
      _firestore.collection("PupilsMarks").add({
        //leave field
        "pupil_name": widget.pupil_name,
        "teacher_id": userId,
        "parent_id": widget.parent_id,
        "coursecode": widget.coursecode,
        "coursename": widget.coursename,
        "pupil_id": widget.pupil_id,
        "level": widget.level,
        "marksType": markstype,
        "marks": marks,
        "outof": outof,
        "Date": _applyleavevalueChanged,
        "teacher_feedback": desc
      }).then((value) {
        setState(() {
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          const snackBar = SnackBar(
              content: Text(
                "Marks saved successfully!!",
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 18,
                ),
              ),
              duration: Duration(seconds: 2));
          messengerKey.currentState!.showSnackBar(snackBar);
          // });
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(userId);
    animationController.forward();
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        final GlobalKey<ScaffoldState> _scaffoldKey =
            new GlobalKey<ScaffoldState>();
        return Scaffold(
          key: _scaffoldKey,
          appBar: CommonAppBar(
            menuenabled: true,
            notificationenabled: false,
            title: "Add Marks",
            ontap: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
          // drawer: Drawer(
          //   elevation: 0,
          //   child: MainDrawer(),
          // ),
          drawer: appDrawer(context),
          body: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      color: Colors.black.withOpacity(0.5),
                      height: 1,
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.blueAccent,
                      ),
                      padding: EdgeInsets.all(8.0),
                      width: width * 0.9,
                      child: Transform(
                        transform: Matrix4.translationValues(
                            muchDelayedAnimation.value * width, 0, 0),
                        child: Text(
                          "Pupil's Name : ${widget.pupil_name}\n\nLevel : ${widget.level}\n\nCourse Name : ${widget.coursename}\n\nCourse Code : ${widget.coursecode}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          muchDelayedAnimation.value * width, 0, 0),
                      child: const Text(
                        "Date",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 13,
                      ),
                      child: Container(
                        // height: height * 0.06,
                        padding: const EdgeInsets.only(
                          left: 10,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Transform(
                              transform: Matrix4.translationValues(
                                  muchDelayedAnimation.value * width, 0, 0),
                              child: Container(
                                width: width * 0.75,
                                child: DateTimePicker(
                                  type: DateTimePickerType.date,
                                  dateMask: 'dd/MM/yyyy',
                                  dateLabelText: "Choose date",
                                  controller: _applyleavecontroller,
                                  //initialValue: _initialValue,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  calendarTitle: "Marks Date",
                                  confirmText: "Confirm",
                                  enableSuggestions: true,
                                  //locale: Locale('en', 'US'),
                                  onChanged: (val) => setState(
                                      () => _applyleavevalueChanged = val),
                                  validator: (val) {
                                    setState(() =>
                                        _applyleavevalueToValidate = val!);
                                    return null;
                                  },
                                  onSaved: (val) => setState(
                                      () => _applyleavevalueSaved = val!),
                                ),
                              ),
                            ),
                            Transform(
                              transform: Matrix4.translationValues(
                                  delayedAnimation.value * width, 0, 0),
                              child: const Icon(
                                Icons.calendar_today,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          muchDelayedAnimation.value * width, 0, 0),
                      child: const Text(
                        "Choose Marks Category",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          delayedAnimation.value * width, 0, 0),
                      child: DropdownSearch<String>(
                        popupProps: PopupProps.menu(
                          showSelectedItems: true,
                          disabledItemFn: (String s) => s.startsWith('I'),
                        ),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            hintText: "Please Select  marks category",
                          ),
                        ),
                        validator: (v) => v == null ? "required field" : null,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        // enabled: true, // hint: "Please Select Leave type",
                        // mode: Mode.MENU,
                        // showSelectedItem: true,
                        items: const [
                          "Exams",
                          "Exercises",
                          "Homework",
                          'Others'
                        ],
                        onSaved: (val) {},
                        onChanged: (val) {
                          markstype = val!;
                        },

                        // showClearButton: true,
                        // onChanged: print,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          muchDelayedAnimation.value * width, 0, 0),
                      child: const Text(
                        "marks out of",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          delayedAnimation.value * width, 0, 0),
                      child: DropdownSearch<String>(
                        popupProps: PopupProps.menu(
                          showSelectedItems: true,
                          disabledItemFn: (String s) => s.startsWith('I'),
                        ),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            hintText: "Please Select",
                          ),
                        ),
                        validator: (v) => v == null ? "required field" : null,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        // enabled: true, // hint: "Please Select Leave type",
                        // mode: Mode.MENU,
                        // showSelectedItem: true,
                        items: const ["5", "10", "20", '30', '50', '100'],
                        onSaved: (val) {},
                        onChanged: (val) {
                          outof = val!;
                        },

                        // showClearButton: true,
                        // onChanged: print,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          muchDelayedAnimation.value * width, 0, 0),
                      child: const Text(
                        "Pupils marks",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          delayedAnimation.value * width, 0, 0),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 13,
                        ),
                        child: Container(
                          // height: height * 0.06,
                          height: height * 0.07,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            //autofocus: true,
                            minLines: 1,
                            controller: marksFieldController,
                            onChanged: (val) {
                              marks = int.parse(val);
                            },
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              suffixIcon: searchFieldController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () => WidgetsBinding.instance
                                          .addPostFrameCallback((_) =>
                                              searchFieldController.clear()))
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(7),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          muchDelayedAnimation.value * width, 0, 0),
                      child: const Text(
                        "Teacher Feedback",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          delayedAnimation.value * width, 0, 0),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 13,
                        ),
                        child: Container(
                          // height: height * 0.06,
                          height: height * 0.20,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            //autofocus: true,
                            minLines: 1,
                            controller: descFieldController,
                            onChanged: (val) {
                              desc = val;
                            },
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              suffixIcon: searchFieldController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () => WidgetsBinding.instance
                                          .addPostFrameCallback((_) =>
                                              searchFieldController.clear()))
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(7),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          delayedAnimation.value * width, 0, 0),
                      child: Bouncing(
                        onPress: () {},
                        child: Container(
                          //height: 20,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.blue,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  saveMarks();
                                },
                                child: const Text(
                                  "Save marks",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CircularProgressIndicator(
                                strokeWidth: 5.0,
                                color: Colors.blueAccent,
                                semanticsLabel: "Saving...",
                                semanticsValue: "Saving..",
                                backgroundColor: Colors.orange,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Loading,Please Wait...",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                ),
                              )
                            ],
                          )
                        : Container(
                            child: null,
                          ),
                    const SizedBox(
                      height: 30,
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          delayedAnimation.value * width, 0, 0),
                      child: Bouncing(
                        onPress: () {},
                        child: Container(
                          //height: 20,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.blue,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  // saveMarks();
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Back",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
