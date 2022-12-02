import 'package:flutter/material.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Container(
            child: const FittedBox(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/img4.jpg'),
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
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.indigo,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Create Your Classroom",
                  style: TextStyle(
                      fontSize: 26,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 40,
                    top: 25,
                    right: 25,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Sign up as Teacher and create your first class",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Lato",
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
