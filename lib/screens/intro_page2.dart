import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({Key? key}) : super(key: key);

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
                backgroundImage: AssetImage('assets/images/img5.jpg'),
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
                  "Add Students",
                  style: TextStyle(
                      fontSize: 30,
                      letterSpacing: 2,
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
                      "Register students for starting learning,"
                      "let's collaborate together",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
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
