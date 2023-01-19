import 'package:flutter/material.dart';

import '../constants.dart';

class HaveForgetPassword extends StatelessWidget {
  final bool login;
  final Function press;
  const HaveForgetPassword({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login
              ? "Have you forgot password ? "
              : "Are you remember password ? ",
          style: TextStyle(color: kPrimaryColor),
        ),
        GestureDetector(
          onTap: press(),
          child: Text(
            login ? "Reset" : "Back",
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
