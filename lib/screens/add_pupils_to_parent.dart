import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:final_year_4cs/screens/add_pupils.dart';
import 'package:flutter/material.dart';

//database services
import '../services/database_service.dart';
import '../utils/utils.dart';
import '../widgets/Drawer.dart';
import '../widgets/appBar.dart';

class AddPupilsToParent extends StatefulWidget {
  final String uid;
  final String tel;
  const AddPupilsToParent(this.uid, this.tel);

  @override
  State<AddPupilsToParent> createState() => _AddPupilsToParentState();
}

class _AddPupilsToParentState extends State<AddPupilsToParent> {
  final _formkey = GlobalKey<FormState>();
  String name = "", age = "", level = "";
  String dob = "", gender = "";
  String? _initialValue;
  late String _selectedResult;
  //adding controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  TextEditingController? _controller3;
  String _valueChanged3 = '';
  String _valueToValidate3 = '';
  String _valueSaved3 = '';
  @override
  void initState() {
    super.initState();
    _initialValue = '';
    _selectedResult = "";
  }

  //database service
  bool _isLoading = false;
  DatabaseService databaseService = new DatabaseService();
  uploadPupilsData() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _selectedResult = _initialValue!;

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
    final questionField = TextFormField(
      autofocus: false,
      controller: nameController,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        nameController.text = value!;
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
          Icons.person,
          color: Colors.green,
        ),
        filled: true,
        fillColor: Colors.green[50],
        labelText: "Pupils Name",
        labelStyle: const TextStyle(color: Colors.green),
      ),
      onChanged: (val) {
        name = val;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (input) => input != null && input.length < 1
          ? 'pupil name is required please..'
          : null,
    );
    //quiz title field
    final option1Field = TextFormField(
      autofocus: false,
      controller: ageController,
      onSaved: (value) {
        ageController.text = value!;
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
          Icons.numbers,
          color: Colors.green,
        ),
        filled: true,
        fillColor: Colors.green[50],
        labelText: "Pupil Age",
        labelStyle: const TextStyle(color: Colors.green),
      ),
      onChanged: (val) {
        age = val;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (input) =>
          input != null && input.length < 1 ? 'pupil age is required' : null,
    );
    final addpupilBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.blue[300],
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
        minWidth: MediaQuery.of(context).size.width * 0.3,
        onPressed: () {
          uploadPupilsData();
        },
        child: const Text(
          'Add Pupil',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    final addsubmitBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.blue[300],
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
        minWidth: MediaQuery.of(context).size.width * 0.3,
        onPressed: () {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return AddPupils();
          }));
        },
        child: const Text(
          'Submit',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70), child: appBar(context)),
      drawer: appDrawer(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
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
                    height: 5,
                  ),
                  const Text(
                    "Feel free to add pupils,it's simple and easy!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
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
                  RadioListTile(
                    title: const Text("Male"),
                    value: "Male",
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text("Female"),
                    value: "Female",
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                      });
                    },
                  ),
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
                  // option4Field,
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
    );
  }
}
