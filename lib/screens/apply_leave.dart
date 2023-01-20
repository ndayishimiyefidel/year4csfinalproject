import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Widgetsapp/AppBar.dart';
import '../Widgetsapp/BouncingButton.dart';
import '../Widgetsapp/LeaveApply/LeaveHistoryCard.dart';
import '../models/leavemodel.dart';
import '../services/auth.dart';
import '../services/database_service.dart';
import '../utils/utils.dart';
import '../widgets/Drawer.dart';
import 'leavehistory.dart';

class LeaveApply extends StatefulWidget {
  @override
  _LeaveApplyState createState() => _LeaveApplyState();
}

class _LeaveApplyState extends State<LeaveApply>
    with SingleTickerProviderStateMixin {
  late Animation animation, delayedAnimation, muchDelayedAnimation, LeftCurve;
  late AnimationController animationController;
  final searchFieldController = TextEditingController();
  late TextEditingController descFieldController;
  late TextEditingController nameFieldController;

  late TextEditingController _applyleavecontroller;
  String _applyleavevalueChanged = '';
  String _applyleavevalueToValidate = '';
  String _applyleavevalueSaved = '';

  late TextEditingController _fromcontroller;
  String _fromvalueChanged = '';
  String _fromvalueToValidate = '';
  String _fromvalueSaved = '';

  late final TextEditingController _tocontroller;
  String _tovalueChanged = '';
  String _tovalueToValidate = '';
  String _tovalueSaved = '';

  String applyleavedate = "";
  String fromdate = "";
  String todate = "";
  String desc = "";
  String leavetype = "";
  String name = "";
  String pupil_id = "";
  String level = "";

  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
  final _firestore = FirebaseFirestore.instance;
  QuerySnapshot? leaveSnapshot;
  LeaveModel getLeaveModelFromDatasnapshot(DocumentSnapshot leaveSnapshot) {
    LeaveModel leaveModel = LeaveModel(name, applyleavedate, fromdate, todate,
        leavetype, desc, pupil_id, level);
    leaveModel.pupil_name = leaveSnapshot['pupil_name'];
    leaveModel.leavetype = leaveSnapshot["leaveType"];
    leaveModel.startdate = leaveSnapshot['startDate'];
    leaveModel.enddate = leaveSnapshot['endDate'];
    leaveModel.applyleavedate = leaveSnapshot['leaveDate'];
    leaveModel.desc = leaveSnapshot['leaveDesc'];
    leaveModel.level = leaveSnapshot['level'];
    leaveModel.pupil_id = leaveSnapshot['pupil_id'];
    return leaveModel;
  }

  @override
  void initState() {
    databaseService
        .getPupilsLeave(FirebaseAuth.instance.currentUser!.uid)
        .then((value) async {
      setState(() {
        leaveSnapshot = value;
        print(userId);
      });
    });
    // TODO: implement initState
    super.initState();
    //SystemChrome.setEnabledSystemUIOverlays([]);
    descFieldController = TextEditingController();
    nameFieldController = TextEditingController();

    _applyleavecontroller =
        TextEditingController(text: DateTime.now().toString());
    _fromcontroller = TextEditingController(text: DateTime.now().toString());
    _tocontroller = TextEditingController(text: DateTime.now().toString());

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

    // initializeDateFormatting();

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
  final Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance
      .collectionGroup('Pupils')
      .where("parent_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  Future<void> checkName() async {
    await _firestore
        .collectionGroup("Pupils")
        .where("pupil_id", isEqualTo: pupil_id)
        .get()
        .then((value) {
      Map<String, dynamic> names = value.docs.first.data();
      name = names["name"];
      level = names["level"];
      print(name);
      print(level);
    });
  }

  Future applyLeave() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      print(userId);
      // Map<String, dynamic> userData = value.docs.first.data();
      // print(userData['email']);

      _firestore.collection("Leaves").add({
        //leave field
        "pupil_id": pupil_id,
        "pupil_name": name,
        "parent_id": userId,
        "level": level,
        "leaveType": leavetype,
        "startDate": _fromvalueChanged,
        "endDate": _tovalueChanged,
        "leaveDate": _applyleavevalueChanged,
        "leaveDesc": desc
      }).then((value) {
        setState(() {
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          const snackBar = SnackBar(
              content: Text(
                "Your leave application have sent!!",
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
            title: "Apply Leave",
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
                      height: height * 0.05,
                    ),

                    Transform(
                      transform: Matrix4.translationValues(
                          muchDelayedAnimation.value * width, 0, 0),
                      child: const Text(
                        "Pupil Registration",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: _userStream,
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
                            transform: Matrix4.translationValues(
                                delayedAnimation.value * width, 0, 0),
                            child: DropdownSearch<String>(
                              popupProps: PopupProps.menu(
                                showSelectedItems: true,
                                disabledItemFn: (String s) => s.startsWith('I'),
                              ),
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  hintText: "Please Select child",
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
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;

                                    return data["pupil_id"];
                                  })
                                  .toList()
                                  .cast<String>(),
                              onSaved: (val) {
                                pupil_id = val!;
                              },
                              onChanged: (val) {
                                pupil_id = val!;
                                checkName();
                              },

                              // showClearButton: true,
                              // onChanged: print,
                            ),
                          );
                        }),
                    SizedBox(
                      height: height * 0.05,
                    ),

                    Transform(
                      transform: Matrix4.translationValues(
                          muchDelayedAnimation.value * width, 0, 0),
                      child: const Text(
                        "Apply Leave Date",
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
                                width: width * 0.73,
                                child: DateTimePicker(
                                  type: DateTimePickerType.date,
                                  dateMask: 'dd/MM/yyyy',
                                  controller: _applyleavecontroller,
                                  //initialValue: _initialValue,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  calendarTitle: "Leave Date",
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
                        "Choose Leave Type",
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
                            hintText: "Please Select Leave type",
                          ),
                        ),
                        validator: (v) => v == null ? "required field" : null,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        // enabled: true, // hint: "Please Select Leave type",
                        // mode: Mode.MENU,
                        // showSelectedItem: true,
                        items: const [
                          "Medical",
                          "Family",
                          "Sick",
                          'Function',
                          'Others'
                        ],
                        onSaved: (val) {},
                        onChanged: (val) {
                          leavetype = val!;
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
                        "Leave Date",
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
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black12,
                              )
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Transform(
                              transform: Matrix4.translationValues(
                                  muchDelayedAnimation.value * width, 0, 0),
                              child: const Icon(
                                Icons.calendar_today,
                                color: Colors.black,
                              ),
                            ),
                            Transform(
                              transform: Matrix4.translationValues(
                                  muchDelayedAnimation.value * width, 0, 0),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Container(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  width: width * 0.28,
                                  decoration: const BoxDecoration(
                                      color: Colors.white38,
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 1),
                                          blurRadius: 2,
                                          color: Colors.black26,
                                        )
                                      ]),
                                  child: DateTimePicker(
                                    fieldLabelText: "From",
                                    type: DateTimePickerType.date,
                                    dateMask: 'dd/MM/yyyy',
                                    controller: _fromcontroller,
                                    //initialValue: _initialValue,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                    calendarTitle: "Title",
                                    confirmText: "Confirm",
                                    enableSuggestions: true,
                                    //locale: Locale('en', 'US'),
                                    onChanged: (val) =>
                                        setState(() => _fromvalueChanged = val),
                                    validator: (val) {
                                      setState(
                                          () => _fromvalueToValidate = val!);
                                      return null;
                                    },
                                    onSaved: (val) =>
                                        setState(() => _fromvalueSaved = val!),
                                  )
                                ),
                              ),
                            ),
                            Transform(
                              transform: Matrix4.translationValues(
                                  muchDelayedAnimation.value * width, 0, 0),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: Colors.black,
                              ),
                            ),
                            Transform(
                              transform: Matrix4.translationValues(
                                  delayedAnimation.value * width, 0, 0),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Container(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  width: width * 0.28,
                                  decoration: const BoxDecoration(
                                    color: Colors.white38,
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 1),
                                        blurRadius: 2,
                                        color: Colors.black26,
                                      )
                                    ],
                                  ),
                                  child: DateTimePicker(
                                    fieldLabelText: "To",
                                    type: DateTimePickerType.date,
                                    dateMask: 'dd/MM/yyyy',
                                    controller: _tocontroller,
                                    //initialValue: _initialValue,
                                    firstDate: DateTime(2023),
                                    lastDate: DateTime(2100),
                                    calendarTitle: "Title",
                                    confirmText: "Confirm",
                                    enableSuggestions: true,
                                    //locale: Locale('en', 'US'),
                                    onChanged: (val) =>
                                        setState(() => _tovalueChanged = val),
                                    validator: (val) {
                                      setState(() => _tovalueToValidate = val!);
                                      return null;
                                    },
                                    onSaved: (val) =>
                                        setState(() => _tovalueSaved = val!),
                                  ),
                                  // child: CustomDatePicker(
                                  //   controller: _tocontroller,
                                  //   title: "To",
                                  //   onchanged: (val) => setState(() {
                                  //     _tovalueChanged = val;
                                  //     print(val);
                                  //   }),
                                  //   validator: (val) {
                                  //     setState(() => _tovalueToValidate = val);
                                  //     return null;
                                  //   },
                                  //   saved: (val) =>
                                  //       setState(() => _tovalueSaved = val),
                                  // ),
                                ),
                              ),
                            ),
                          ],
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
                        "Apply Leave Description",
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
                    // Transform(
                    //   transform: Matrix4.translationValues(
                    //       muchDelayedAnimation.value * width, 0, 0),
                    //   child: const Text(
                    //     "Attach Document",
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 15,
                    //     ),
                    //   ),
                    // ),
                    // Transform(
                    //   transform: Matrix4.translationValues(
                    //       delayedAnimation.value * width, 0, 0),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: InkWell(
                    //       onTap: () async {},
                    //       child: const Text(
                    //         "Click Here",
                    //         style: TextStyle(
                    //           color: Colors.blue,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
                                  applyLeave();
                                },
                                child: const Text(
                                  "Apply Leave",
                                  style: TextStyle(
                                    fontSize: 15,
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
                      height: 7,
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          muchDelayedAnimation.value * width, 0, 0),
                      child: const Divider(
                        color: Colors.black,
                        thickness: 0.9,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Transform(
                            transform: Matrix4.translationValues(
                                muchDelayedAnimation.value * width, 0, 0),
                            child: const Text(
                              "Leave History",
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
                              padding: const EdgeInsets.all(4.0),
                              child: InkWell(
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return LeaveHistory();
                                      },
                                    ),
                                  );
                                },
                                child: const Text(
                                  "See All",
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        leaveSnapshot == null
                            ? Text("no applied leave yet")
                            : ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: const ClampingScrollPhysics(),
                                itemCount: leaveSnapshot!.docs.length,
                                itemBuilder: (context, index) {
                                  return Transform(
                                    transform: Matrix4.translationValues(
                                        delayedAnimation.value * width, 0, 0),
                                    child: Bouncing(
                                      onPress: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: LeaveHistoryCard(
                                          leaveModel:
                                              getLeaveModelFromDatasnapshot(
                                                  leaveSnapshot!.docs[index]),
                                          index: index,
                                        ),
                                      ),
                                    ),
                                  );
                                  // return AttendanceCard(
                                  //   attendanceModel: getAttendanceModelFromDatasnapshot(
                                  //       attendanceSnapshot!.docs[index]),
                                  //   index: index,
                                  // );
                                }),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
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
