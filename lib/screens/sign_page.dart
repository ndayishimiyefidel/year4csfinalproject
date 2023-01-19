import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_4cs/screens/admin_screen.dart';
import 'package:final_year_4cs/screens/parent_screens.dart';
import 'package:final_year_4cs/screens/teacher_screen.dart';
import 'package:final_year_4cs/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/already_have_an_account_acheck.dart';
import '../components/text_field_container.dart';
import 'backgrounds/background.dart';
import 'forget_password.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _messaging.getToken().then((value) {
      fcmToken = value!;
    });
  }

  //from
  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  late bool _passwordVisible;
  static const kPrimaryColor = Color(0xFF6F35A5);
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  late String fcmToken;
  late SharedPreferences preferences;
  AuthService _authService = AuthService();
  //adding controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //firebase auth

  Future<void> userLogin() async {
    final isValid = _formkey.currentState!.validate();
    if (!isValid) return;
    setState(() {
      _isLoading = true;
    });

    preferences = await SharedPreferences.getInstance();
    await _authService
        .loginUser(
            email: emailController.text.toString().trim(),
            password: passwordController.text.toString().trim())
        .then((value) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .where('email', isEqualTo: emailController.text.toString())
            .get()
            .then((value) async {
          if (value.size == 1) {
            int status = 1;
            FirebaseFirestore.instance
                .collection("Users")
                .doc(user.uid)
                .update({"fcmToken": fcmToken, "state": status});

            FirebaseFirestore.instance
                .collection("Users")
                .doc(user.uid)
                .get()
                .then((datasnapshot) async {
              // print(datasnapshot.data["photoUrl"]);

              await preferences.setString("uid", datasnapshot.data()!["uid"]);
              await preferences.setString("name", datasnapshot.data()!["name"]);
              await preferences.setString(
                  "photo", datasnapshot.data()!["photoUrl"]);
              await preferences.setString(
                  "email", datasnapshot.data()!["email"]);
              await preferences.setString(
                  "phone", datasnapshot.data()!["phone"]);
              await preferences.setString(
                  "password", datasnapshot.data()!["password"]);
              await preferences.setString("role", datasnapshot.data()!["role"]);
              await preferences.setString(
                  "address", datasnapshot.data()!["address"]);

              setState(() {
                _isLoading = false;
              });

              Map<String, dynamic> userData = value.docs.first.data();
              if (userData['password'] ==
                      passwordController.text.toString().trim() &&
                  userData['role'] == "Admin") {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminScreen(
                                currentUser: user.uid,
                              )));
                  _isLoading = false;
                });
              } else if (userData['password'] ==
                      passwordController.text.toString().trim() &&
                  userData['role'] == "Teacher") {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TeacherScreen(
                                currentUser: user.uid,
                              )));
                  _isLoading = false;
                });
              } else if (userData['password'] ==
                      passwordController.text.toString().trim() &&
                  userData['role'] == "Parent") {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ParentScreen(
                                currentUser: user.uid,
                              )));
                  _isLoading = false;
                });
              } else {}
            });
          } else {
            print('Email not found');
            setState(() {
              _isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(msg: "Login Failed");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          hintText: "Your Email",
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
    //password field
    final passwordField = TextFieldContainer(
      child: TextFormField(
        autofocus: false,
        controller: passwordController,
        onSaved: (value) {
          passwordController.text = value!;
        },
        obscureText: !_passwordVisible,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: "Password",
          icon: const Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility_off : Icons.visibility,
              color: kPrimaryColor,
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
          border: InputBorder.none,
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (pwValue) {
          if (pwValue!.isEmpty) {
            return 'This field is mandatory';
          }
          if (pwValue.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
      ),
    );
    final signibBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: kPrimaryColor,
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
        minWidth: MediaQuery.of(context).size.width * 0.6,
        onPressed: () async {
          await userLogin();
        },
        child: const Text(
          'SIGN IN',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Background(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: size.height * 0.03),
                    SvgPicture.asset(
                      "assets/icons/login.svg",
                      height: size.height * 0.35,
                    ),
                    SizedBox(height: size.height * 0.03),
                    const Text(
                      "SIGN / LOGIN IN",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    emailField,
                    SizedBox(height: size.height * 0.03),
                    passwordField,
                    SizedBox(height: size.height * 0.03),
                    Padding(
                      padding: const EdgeInsets.only(left: 120),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const ForgetPasswordPage();
                              },
                            ),
                          );
                        },
                        child: const Text(
                          "Forget password ?",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    signibBtn,
                    SizedBox(height: size.height * 0.03),
                    AlreadyHaveAnAccountCheck(
                      press: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) {
                        //       return SignUpScreen();
                        //     },
                        //   ),
                        // );
                      },
                    ),
                    SizedBox(height: size.height * 0.03),
                    _isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CircularProgressIndicator(
                                strokeWidth: 5.0,
                                color: Colors.blueAccent,
                                backgroundColor: kPrimaryColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Loading,Please Wait...",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 14,
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
    );
  }
}
