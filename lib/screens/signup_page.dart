import 'package:final_year_4cs/screens/sign_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //from
  final _formkey = GlobalKey<FormState>();
  //adding controller
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cfpwdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //first name field
    final firstnameField = TextFormField(
      autofocus: false,
      controller: firstnameController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        firstnameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_circle),
        contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        hintText: "Enter your first name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    //last name field
    final lastnameField = TextFormField(
      autofocus: false,
      controller: lastnameController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        lastnameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_circle),
        contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        hintText: "Enter your last name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    //phone field
    final phoneField = TextFormField(
      autofocus: false,
      controller: phoneController,
      keyboardType: TextInputType.phone,
      onSaved: (value) {
        phoneController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.phone_callback_rounded),
        contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        hintText: "Enter your phone number",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        hintText: "Enter your email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    //password field
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
        prefixIcon: const Icon(Icons.key),
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
        prefixIcon: const Icon(Icons.key),
        suffixIcon: const Icon(Icons.remove_red_eye),
        contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        hintText: "Confirm your password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final signupbBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.blue[300],
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
        minWidth: MediaQuery.of(context).size.width * 0.5,
        onPressed: () {},
        child: const Text(
          'sign up',
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
        backgroundColor: Colors.transparent,
        elevation: 0,
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
              color: Colors.white,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 180,
                      child: Image.asset(
                        "assets/images/logo1.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: "Loto",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Please fill the details and create account",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Fasthand",
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    firstnameField,
                    const SizedBox(
                      height: 20,
                    ),
                    lastnameField,
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
                    passwordField,
                    const SizedBox(
                      height: 20,
                    ),
                    cfpwdField,
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    signupbBtn,
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "Already have an account ?",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const SignInPage();
                            }));
                          },
                          child: const Text(
                            "Sign in",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Lato",
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "OR",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: "Loto",
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        //social media icons
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Color(0xFF3b5998),
                          child: Icon(
                            FontAwesomeIcons.facebookF,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.redAccent,
                          child: Icon(
                            FontAwesomeIcons.google,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.lightBlueAccent,
                          child: Icon(
                            FontAwesomeIcons.twitter,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            FontAwesomeIcons.apple,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      ],
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
