import 'package:final_year_4cs/screens/verify_otp.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  //from
  final _formkey = GlobalKey<FormState>();
  //adding controller
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController cfpwdController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      onSaved: (value) {
        passwordController.text = value!;
      },
      obscureText: true,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: const Icon(Icons.remove_red_eye),
        contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        hintText: "Enter your password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    //password field
    final cfpwdField = TextFormField(
      autofocus: false,
      controller: cfpwdController,
      onSaved: (value) {
        cfpwdController.text = value!;
      },
      obscureText: true,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: const Icon(Icons.remove_red_eye),
        contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        hintText: "Confirm your password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final saveBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
        minWidth: MediaQuery.of(context).size.width * 0.5,
        onPressed: () {},
        child: const Text(
          'Save',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Center(
                child: Text(
                  "Create new password",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const OtpPage();
            }));
          },
        ),
      ),
      backgroundColor: Colors.white,
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
                    const SizedBox(
                      height: 100,
                    ),
                    const Text(
                      "Change Password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Enter the new password associated with your account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    passwordField,
                    const SizedBox(
                      height: 25,
                    ),
                    cfpwdField,
                    const SizedBox(
                      height: 25,
                    ),
                    saveBtn,
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
