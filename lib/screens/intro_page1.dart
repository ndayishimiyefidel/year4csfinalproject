import 'package:final_year_4cs/constants.dart';
import 'package:final_year_4cs/screens/backgrounds/background.dart';
import 'package:flutter/material.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Container(
            child: const FittedBox(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/img2.jpg'),
                radius: 140,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            width: 350,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "You are all set",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 40,
                    top: 30,
                    right: 25,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Take live class, Share study materials,Manage fees and much more",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
