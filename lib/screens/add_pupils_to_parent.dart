import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_4cs/screens/add_pupils.dart';
import 'package:final_year_4cs/screens/backgrounds/background.dart';
import 'package:flutter/material.dart';

//database services
import '../Widgetsapp/AppBar.dart';
import '../components/text_field_container.dart';
import '../constants.dart';
import '../services/database_service.dart';
import '../utils/utils.dart';
import '../widgets/Drawer.dart';

enum radiobutton { Male, Female }

class AddPupilsToParent extends StatefulWidget {
  final String uid;
  final String tel;
  const AddPupilsToParent(this.uid, this.tel);

  @override
  State<AddPupilsToParent> createState() => _AddPupilsToParentState();
}

class _AddPupilsToParentState extends State<AddPupilsToParent> {
  _AddPupilsToParentState() {
    _selectedResult = _listLevel[0];
  }
  final _formkey = GlobalKey<FormState>();
  String name = "", age = "", level = "";
  String dob = "", gender = "";
  String? _initialValue;
  late String _selectedResult;
  radiobutton? _genderValues;
  //adding controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final _listLevel = ["P1", "P2", "P3", "P4", "P5", "P6"];
  @override
  void initState() {
    super.initState();
    // _initialValue = '';
    // _selectedResult = "";
  }

  //database service
  bool _isLoading = false;
  DatabaseService databaseService = new DatabaseService();
  uploadPupilsData() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      // _selectedResult = _initialValue!;

      FirebaseFirestore.instance
          .collection("Pupils")
          .where("name", isEqualTo: name)
          .where("level", isEqualTo: _selectedResult)
          .get()
          .then((value) async {
        if (value.size == 0) {
          String uid = Random().nextInt(999999).toString().padLeft(6, '0');
          String RegNumber = "PR$uid";

          Map<String, String> pupilsMap = {
            "parent_id": widget.uid,
            "name": name,
            "parent_phone": widget.tel,
            "age": age,
            "gender": gender,
            "level": _selectedResult,
            "date": cdate2,
            "pupil_id": RegNumber,
          };

          print(widget.uid);

          await databaseService
              .addPupilsToParent(pupilsMap, widget.uid)
              .then((value) {
            setState(() {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                const snackBar = SnackBar(
                    content: Text(
                      "Pupil information saved successfully, Enter next pupils",
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 18,
                      ),
                    ),
                    duration: Duration(seconds: 2));
                messengerKey.currentState!.showSnackBar(snackBar);
              });
              _isLoading = false;
            });
          });
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text("Already Registered!"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Close"))
                  ],
                );
              });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionField = TextFieldContainer(
      child: TextFormField(
        autofocus: false,
        controller: nameController,
        keyboardType: TextInputType.text,
        onSaved: (value) {
          nameController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          icon: Icon(
            Icons.person_pin,
            color: kPrimaryColor,
          ),
          hintText: "Pupil's Name",
          border: InputBorder.none,
        ),
        onChanged: (val) {
          name = val;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (input) => input != null && input.length < 1
            ? 'pupil name is required please..'
            : null,
      ),
    );
    //quiz title field
    final option1Field = TextFieldContainer(
      child: TextFormField(
        autofocus: false,
        controller: ageController,
        onSaved: (value) {
          ageController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          icon: Icon(
            Icons.numbers_outlined,
            color: kPrimaryColor,
          ),
          hintText: "Pupil's Age",
          border: InputBorder.none,
        ),
        onChanged: (val) {
          age = val;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (input) =>
            input != null && input.length < 1 ? 'pupil age is required' : null,
      ),
    );
    final addpupilBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: kPrimaryColor,
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
        minWidth: MediaQuery.of(context).size.width * 0.4,
        onPressed: () async {
          await uploadPupilsData();
        },
        child: const Text(
          'SAVE',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
    final addsubmitBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: kPrimaryColor,
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
        minWidth: MediaQuery.of(context).size.width * 0.4,
        onPressed: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddPupils();
              },
            ),
          );
        },
        child: const Text(
          'SUBMIT',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
    return Scaffold(
      // appBar: PreferredSize(
      //     preferredSize: const Size.fromHeight(70), child: appBar(context)),
      // drawer: appDrawer(context),

      appBar: CommonAppBar(
        title: "SAving Pupils",
        menuenabled: true,
        notificationenabled: true,
        ontap: () {
          // _scaffoldKey.currentState!.openDrawer();
        },
      ),
      drawer: appDrawer(context),

      body: Background(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "Add Pupils Information",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                      questionField,
                      const SizedBox(
                        height: 25,
                      ),
                      option1Field,
                      const SizedBox(
                        height: 25,
                      ),
                      TextFieldContainer(
                        child: Row(
                          children: [
                            Expanded(
                              child: RadioListTile<radiobutton>(
                                title: Text(radiobutton.Male.name),
                                value: radiobutton.Male,
                                dense: true,
                                tileColor: Colors.teal[50],
                                groupValue: _genderValues,
                                onChanged: (value) {
                                  setState(() {
                                    _genderValues = value;
                                    gender = radiobutton.Male.name;
                                    print(gender);
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<radiobutton>(
                                tileColor: Colors.teal[50],
                                title: Text(radiobutton.Female.name),
                                dense: true,
                                value: radiobutton.Female,
                                groupValue: _genderValues,
                                onChanged: (value) {
                                  setState(() {
                                    _genderValues = value;
                                    gender = radiobutton.Female.name;
                                    print(gender);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
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
                        height: 45,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [addpupilBtn, addsubmitBtn],
                      ),
                      _isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CircularProgressIndicator(
                                  strokeWidth: 5.0,
                                  color: Colors.blueAccent,
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
                            )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
