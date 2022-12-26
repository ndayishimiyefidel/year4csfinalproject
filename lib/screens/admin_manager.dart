import 'package:final_year_4cs/screens/add_pupils.dart';
import 'package:final_year_4cs/screens/admin_screen.dart';
import 'package:flutter/material.dart';

class AdminManagePage extends StatefulWidget {
  const AdminManagePage({Key? key}) : super(key: key);

  @override
  State<AdminManagePage> createState() => _AdminManagePageState();
}

class _AdminManagePageState extends State<AdminManagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
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
                  "Manage Information",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Icon(
                Icons.notifications_active_outlined,
                color: Colors.black,
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
              return const AdminScreen();
            }));
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  //search bar
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.blueGrey[400],
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/openb.jpg",
                          fit: BoxFit.contain,
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 20, left: 10, right: 10),
                  child: Column(
                    children: [
                      //explore heading,
                      //courses and pupils
                      GridView.count(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        crossAxisCount: 2,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
                        padding: const EdgeInsets.all(20.0),
                        physics: const ScrollPhysics(),
                        children: <Widget>[
                          Card(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.blueAccent,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: InkWell(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) {
                                //       return const PupilsPage();
                                //     },
                                //   ),
                                // );
                              },
                              splashColor: Colors.green,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/pupils.png",
                                      fit: BoxFit.contain,
                                      height: 100,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "View Pupils",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //information
                          Card(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.blueAccent,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: InkWell(
                              onTap: () {
                                //on tap go to adds pupils and class
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const AddPupils();
                                }));
                              },
                              splashColor: Colors.green,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/stud.png",
                                      fit: BoxFit.contain,
                                      height: 100,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      "Add pupils",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //pupils
                          Card(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.blueAccent,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: InkWell(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) {
                                //       return const PupilsPage();
                                //     },
                                //   ),
                                // );
                              },
                              splashColor: Colors.green,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/teachers.jpg",
                                      fit: BoxFit.contain,
                                      height: 100,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "View Teacher",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //information
                          Card(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.blueAccent,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: InkWell(
                              onTap: () {},
                              splashColor: Colors.green,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/academic.png",
                                      fit: BoxFit.contain,
                                      height: 100,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      "Performance",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
