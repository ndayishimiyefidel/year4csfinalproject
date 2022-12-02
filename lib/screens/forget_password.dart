import 'package:final_year_4cs/screens/sign_page.dart';
import 'package:final_year_4cs/screens/verify_otp.dart';
import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  //from
  final _formkey = GlobalKey<FormState>();
  //adding controller
  final TextEditingController emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        hintText: "Enter your email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final sendBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.blue[300],
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
        minWidth: MediaQuery.of(context).size.width * 0.5,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const OtpPage();
              },
            ),
          );
        },
        child: const Text(
          'Send',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Forget password",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const SignInPage();
            }));
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
              color: Colors.white,
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 220,
                      child: Image.asset(
                        "assets/images/forget.jpg",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Text(
                      "Forgot Password ?",
                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: "Loto",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Enter the email address associated with your account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Fasthand",
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    emailField,
                    const SizedBox(
                      height: 25,
                    ),
                    sendBtn,
                    const SizedBox(
                      height: 15,
                    ),
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
