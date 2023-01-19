import 'dart:convert' as convert;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_4cs/screens/view_parents.dart';
import 'package:final_year_4cs/services/auth.dart';
import 'package:final_year_4cs/services/database_service.dart';
import 'package:final_year_4cs/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Widgetsapp/AppBar.dart';
import '../components/text_field_container.dart';
import '../constants.dart';
import '../utils/colors.dart';
import '../widgets/Drawer.dart';
import 'add_pupils_to_parent.dart';
import 'backgrounds/background.dart';

enum radiobutton { Male, Female }

class AddPupils extends StatefulWidget {
  const AddPupils({Key? key}) : super(key: key);

  @override
  State<AddPupils> createState() => _AddPupilsState();
}

class _AddPupilsState extends State<AddPupils> {
  String _initialValue = "";
  late String _selectedResult;
  String _initialtype = "";
  late String _selectedtype;
  static const int status = 0;
  radiobutton? genderValues;

  @override
  void initState() {
    super.initState();
    // _initialValue = '';
    // _selectedResult = "";
    // _initialtype = "";
    // _selectedtype = "";
    _messaging.getToken().then((value) {
      fcmToken = value!;
    });
  }

  _AddPupilsState() {
    _selectedResult = _listDegree[0];
    _selectedtype = _userList[0];
  }

  final _formkey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  late String fcmToken;
  String pname = "", phone = "", pemail = "", pqualifiction = "";
  String paddress = "";
  late SharedPreferences preferences;
  bool isLoggedin = false;
  Future<void> sendCredentialsToUser(
      String names, String email, String password, String tel) async {
    var headers = {
      'x-api-key': '136|moXSu4zlDA0bpzAyWw49rchY0IoRttvwsSU08DBE',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://api.mista.io/sms'));
    request.body = convert.json.encode({
      "to": "25$tel",
      "from": "studperf",
      "unicode": "0",
      "sms": """
Hello $names below find credentials to use to login via Student Performance app \n email: $email , password:$password \n Thank you""",
      "action": "send-sms"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

//adding controller
  final AuthService _authService = AuthService();
  String password = "password";
  final String defaultphotoUrl =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwXRWqD0MOgB-qXln3O7R3-V4_4HFpes9TRjBUi3Q&s";

  String gender = ""; //no radio button will be selected
  String? martialStatus; //no radio button will be selected
  DatabaseService databaseService = DatabaseService();

  final TextEditingController classNameController = TextEditingController();
  final TextEditingController classDescController = TextEditingController();
  final _listDegree = [
    "A2 (Diplome)",
    "A1 (Advanced Diplome)",
    "A2 (Bachelor)",
    "Masters",
    "Dr.",
    "PHD"
  ];
  final _userList = ["Admin", "Teacher"];
  //adding controller
  final TextEditingController parentnameController = TextEditingController();
  final TextEditingController parentaddressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();

  TabBar get _tabBar => const TabBar(
        indicatorColor: purple,
        indicatorWeight: 1.0,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.black87,
        unselectedLabelColor: Colors.white,
        indicator: BoxDecoration(
          color: Colors.green,
        ),
        tabs: [
          Tab(
            icon: Icon(Icons.group_add_outlined),
            text: 'Users',
          ),
          Tab(
            icon: Icon(Icons.group_add_outlined),
            text: 'Pupils',
          ),
        ],
      );

  Future saveUserData() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      preferences = await SharedPreferences.getInstance();
      await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: emailController.text.toString())
          .get()
          .then((value) async {
        print(emailController.text.toString());
        if (value.size == 1) {
          print('Email already exist');
          setState(() {
            const snackBar = SnackBar(
                content: Text(
                  "Email already exit, may be there is another account of this email!",
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
          _authService
              .createUser(email: pemail, password: password)
              .then((value) async {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              final QuerySnapshot result = await FirebaseFirestore.instance
                  .collection("Users")
                  .where("uid", isEqualTo: user.uid)
                  .get();

              final List<DocumentSnapshot> documents = result.docs;
              if (documents.length == 0) {
                Map<String, dynamic> userData = {
                  "uid": user.uid,
                  "name": pname,
                  "email": user.email.toString(),
                  "phone": phone,
                  "address": paddress,
                  "password": password,
                  "role": "Parent",
                  "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
                  "state": status,
                  "lastSeen": DateTime.now().millisecondsSinceEpoch.toString(),
                  "fcmToken": fcmToken,
                  "photoUrl": defaultphotoUrl,
                };
                await databaseService
                    .createUserAccount(userData, user.uid)
                    .then((value) async {
                  final currentuser = user;
                  await preferences.setString("uid", currentuser.uid);
                  await preferences.setString("name", pname);
                  await preferences.setString("photo", defaultphotoUrl);
                  await preferences.setString(
                      "email", currentuser.email.toString());

                  sendCredentialsToUser(pname, pemail, password, phone)
                      .then((value) {
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AddPupilsToParent(user.uid, phone);
                        },
                      ),
                    );
                    // });
                  });
                });
              } else {
                //document contain some data
                await preferences.setString("uid", documents[0]["uid"]);
                await preferences.setString("name", documents[0]["name"]);
                await preferences.setString("photo", documents[0]["photoUrl"]);
                await preferences.setString("email", documents[0]["email"]);
                this.setState(() {
                  _isLoading = false;
                });
              }
            } else {
              setState(() {
                _isLoading = false;
              });
            }
          });
        }
      });
    }
  }

  Future saveAdminTeacherData() async {
    if (_formkey1.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      // _selectedResult = _initialValue;
      // _selectedtype = _initialtype;
      preferences = await SharedPreferences.getInstance();

      await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: emailController.text.toString())
          .get()
          .then((value) async {
        print(emailController.text.toString());
        if (value.size == 1) {
          print('Email already exist');
          setState(() {
            const snackBar = SnackBar(
                content: Text(
                  "User  already exit, may be there is another email address ",
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
          // Map<String, dynamic> userData = value.docs.first.data();
          // print(userData['email']);
          _authService
              .createUser(email: pemail, password: password)
              .then((value) async {
            final user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              final QuerySnapshot result = await FirebaseFirestore.instance
                  .collection("Users")
                  .where("uid", isEqualTo: user.uid)
                  .get();

              final List<DocumentSnapshot> documents = result.docs;
              if (documents.length == 0) {
                Map<String, dynamic> userData = {
                  "uid": user.uid,
                  "name": pname,
                  "email": user.email.toString(),
                  "phone": phone,
                  "password": password,
                  "degree": _selectedResult,
                  "qualification": pqualifiction,
                  "gender": gender,
                  "role": _selectedtype,
                  "address": paddress,
                  "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
                  "state": status,
                  "lastSeen": DateTime.now().millisecondsSinceEpoch.toString(),
                  "fcmToken": fcmToken,
                  "photoUrl": defaultphotoUrl,
                };
                await databaseService
                    .createUserAccount(userData, user.uid)
                    .then((value) async {
                  final currentuser = user;
                  await preferences.setString("uid", currentuser.uid);
                  await preferences.setString("name", pname);
                  await preferences.setString("photo", defaultphotoUrl);
                  await preferences.setString(
                      "email", currentuser.email.toString());
                  sendCredentialsToUser(pname, pemail, password, phone)
                      .then((value) {
                    setState(() {
                      _isLoading = false;
                    });
                    const snackBar = SnackBar(
                        content: Text(
                          "User information saved and received login credentials successfully!",
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 18,
                          ),
                        ),
                        duration: Duration(seconds: 2));
                    messengerKey.currentState!.showSnackBar(snackBar);
                    // });
                  });
                });
              } else {
                //document contain some data
                await preferences.setString("uid", documents[0]["uid"]);
                await preferences.setString("name", documents[0]["name"]);
                await preferences.setString("photo", documents[0]["photoUrl"]);
                await preferences.setString("email", documents[0]["email"]);
                this.setState(() {
                  _isLoading = false;
                });
              }
            } else {
              setState(() {
                _isLoading = false;
              });
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final saveTeacherBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: kPrimaryColor,
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
        minWidth: MediaQuery.of(context).size.width * 0.6,
        onPressed: () async {
          await saveAdminTeacherData();
        },
        child: const Text(
          'SAVE DATA',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );

    //add parent info
    final parentnameField = TextFieldContainer(
      child: TextFormField(
        autofocus: false,
        controller: parentnameController,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          parentnameController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          icon: Icon(
            Icons.person,
            color: kPrimaryColor,
          ),
          hintText: "Names",
          border: InputBorder.none,
        ),
        onChanged: (val) {
          pname = val;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) =>
            value == null ? 'name should filled please...' : null,
      ),
    );
    //last name field
    final parentaddressField = TextFieldContainer(
      child: TextFormField(
        autofocus: false,
        controller: parentaddressController,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          parentaddressController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          icon: Icon(
            Icons.location_on,
            color: kPrimaryColor,
          ),
          hintText: "Address or Location",
          border: InputBorder.none,
        ),
        onChanged: (val) {
          paddress = val;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) =>
            value == null ? 'Address or Location  should filled..' : null,
      ),
    );
    //phone field
    final phoneField = TextFieldContainer(
      child: TextFormField(
        autofocus: false,
        controller: phoneController,
        keyboardType: TextInputType.phone,
        onSaved: (value) {
          phoneController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          icon: Icon(
            Icons.phone,
            color: kPrimaryColor,
          ),
          hintText: "Phone Number",
          border: InputBorder.none,
        ),
        onChanged: (val) {
          phone = val;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => value != null && value.length < 10
            ? 'Phone number must have at least 10 character'
            : null,
      ),
    );
    //email field
    final emailField = TextFieldContainer(
      child: TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        cursorColor: kPrimaryColor,
        decoration: const InputDecoration(
          icon: Icon(
            Icons.email,
            color: kPrimaryColor,
          ),
          hintText: "Email",
          border: InputBorder.none,
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (emailValue) {
          if (emailValue!.isEmpty) {
            return 'This field is mandatory';
          }
          String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
              "\\@" +
              "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
              "(" +
              "\\." +
              "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
              ")+";
          RegExp regExp = new RegExp(p);

          if (regExp.hasMatch(emailValue)) {
            // So, the email is valid
            return null;
          }

          return 'This is not a valid email';
        },
      ),
    );

    final qualificationField = TextFieldContainer(
      child: TextFormField(
        autofocus: false,
        controller: qualificationController,
        keyboardType: TextInputType.text,
        onSaved: (value) {
          qualificationController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          icon: Icon(
            Icons.high_quality_outlined,
            color: kPrimaryColor,
          ),
          hintText: "Qualification",
          border: InputBorder.none,
        ),
        onChanged: (val) {
          pqualifiction = val;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (input) =>
            input == null ? 'Enter qualification obtained' : null,
      ),
    );
    //password field
    final continueBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: kPrimaryColor,
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
        minWidth: MediaQuery.of(context).size.width * 0.6,
        onPressed: () async {
          await saveUserData();
        },
        child: const Text(
          'CONTINUE',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CommonAppBar(
          title: "Users & Pupils",
          menuenabled: true,
          notificationenabled: true,
          ontap: () {
            // _scaffoldKey.currentState!.openDrawer();
          },
        ),
        // appBar: Prefer redSize(
        //     preferredSize: const Size.fromHeight(70), child: appBar(context)),
        drawer: appDrawer(context),
        bottomSheet: PreferredSize(
          preferredSize: _tabBar.preferredSize,
          child: Material(
            color: Colors.blueAccent,
            child: _tabBar,
          ),
        ),
        backgroundColor: Colors.white,
        body: TabBarView(
          children: [
            Background(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(25.0),
                  child: Form(
                    key: _formkey1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Manage User Information",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Feel free to create new user, \n It is easy and simple!",
                          style: TextStyle(
                            fontSize: 16,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        parentnameField,
                        const SizedBox(
                          height: 20,
                        ),
                        phoneField,
                        const SizedBox(
                          height: 20,
                        ),
                        emailField,
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<radiobutton>(
                                title: const Text("Male"),
                                value: radiobutton.Male,
                                tileColor: Colors.teal[50],
                                groupValue: genderValues,
                                onChanged: (value) {
                                  setState(() {
                                    genderValues = value;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<radiobutton>(
                                tileColor: Colors.teal[50],
                                title: const Text("Female"),
                                value: radiobutton.Female,
                                groupValue: genderValues,
                                onChanged: (value) {
                                  setState(() {
                                    genderValues = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        parentaddressField,
                        const SizedBox(
                          height: 20,
                        ),
                        TextFieldContainer(
                          child: DropdownButtonFormField(
                              value: _selectedResult,
                              items: _listDegree
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedResult = val as String;
                                });
                              },
                              icon: const Icon(
                                Icons.arrow_drop_down_circle,
                                // color: kPrimaryColor,
                              ),
                              dropdownColor:Colors.white12,
                              decoration: const InputDecoration(
                                hintText: "Select Degree",
                                border: InputBorder.none,
                              )),
                        )
                        // TextFieldContainer(
                        //   child: DropDownFormField(
                        //     titleText: 'Teacher Degree',
                        //     hintText: 'Please choose one',
                        //     errorText: 'Select an option',
                        //     contentPadding: const EdgeInsets.all(12),
                        //     value: _initialValue,
                        //     onSaved: (value) {
                        //       setState(() {
                        //         _initialValue = value;
                        //       });
                        //     },
                        //     onChanged: (value) {
                        //       setState(() {
                        //         _initialValue = value;
                        //       });
                        //     },
                        //     dataSource: const [
                        //       {
                        //         "display": "A2",
                        //         "value": "A2",
                        //       },
                        //       {
                        //         "display": "Bachelor",
                        //         "value": "Bachelor",
                        //       },
                        //       {
                        //         "display": "Masters",
                        //         "value": "Masters",
                        //       },
                        //       {
                        //         "display": "Doctor(Dr.)",
                        //         "value": "Dr",
                        //       },
                        //       {
                        //         "display": "PhD",
                        //         "value": "PHD",
                        //       },
                        //     ],
                        //     textField: 'display',
                        //     valueField: 'value',
                        //   ),
                        // ),
                        ,
                        const SizedBox(
                          height: 20,
                        ),
                        qualificationField,
                        const SizedBox(
                          height: 20,
                        ),
                        TextFieldContainer(
                          child: DropdownButtonFormField(
                            value: _selectedtype,
                            items: _userList
                                .map((e) => DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                    ))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedtype = val as String;
                              });
                            },
                            icon: const Icon(
                              Icons.arrow_drop_down_circle,
                              // color: kPrimaryColor,
                            ),
                            dropdownColor: kPrimaryColor,
                            decoration: const InputDecoration(
                              hintText: "Select type",
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.group_add_outlined,
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                        ),

                        // Container(
                        //   decoration: BoxDecoration(color: Colors.teal[50]),
                        //   child: DropDownFormField(
                        //     titleText: 'User type',
                        //     hintText: 'Please choose one',
                        //     contentPadding: const EdgeInsets.all(12),
                        //     value: _initialtype,
                        //     onSaved: (value) {
                        //       setState(() {
                        //         _initialtype = value;
                        //       });
                        //     },
                        //     onChanged: (value) {
                        //       setState(() {
                        //         _initialtype = value;
                        //       });
                        //     },
                        //     dataSource: const [
                        //       {
                        //         "display": "Admin",
                        //         "value": "Admin",
                        //       },
                        //       {
                        //         "display": "Teacher",
                        //         "value": "Teacher",
                        //       },
                        //     ],
                        //     textField: 'display',
                        //     valueField: 'value',
                        //   ),
                        // ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            saveTeacherBtn,
                            _isLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        backgroundColor: Colors.orange,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Saving,Please Wait...",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: kPrimaryColor,
                                        ),
                                      )
                                    ],
                                  )
                                : Container(
                                    child: null,
                                  )
                          ],
                        ),
                        const SizedBox(
                          height: 100,
                        ),

                        //parent information
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Background(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Add Pupils",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Parents Information",
                          style: TextStyle(
                            fontSize: 20,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        parentnameField,
                        const SizedBox(
                          height: 20,
                        ),
                        phoneField,
                        const SizedBox(
                          height: 20,
                        ),
                        emailField,
                        const SizedBox(
                          height: 20,
                        ),
                        parentaddressField,
                        const SizedBox(
                          height: 20,
                        ),
                        continueBtn,
                        SizedBox(
                          height: 20,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              "Already have child ?",
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 16,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const ViewParents();
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                "add new",
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        _isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  CircularProgressIndicator(
                                    strokeWidth: 5.0,
                                    color: Colors.blueAccent,
                                    semanticsLabel: "Loading...",
                                    semanticsValue: "Loading..",
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

                        //parent information
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
