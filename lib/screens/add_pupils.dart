import 'package:final_year_4cs/screens/pupils_page.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class AddPupils extends StatefulWidget {
  const AddPupils({Key? key}) : super(key: key);

  @override
  State<AddPupils> createState() => _AddPupilsState();
}

class _AddPupilsState extends State<AddPupils> {
  final _formkey = GlobalKey<FormState>();
//adding controller
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController classDescController = TextEditingController();
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
            icon: Icon(Icons.class_outlined),
            text: 'Class',
          ),
          Tab(
            icon: Icon(Icons.group_add_outlined),
            text: 'Pupils',
          ),
        ],
      );
  @override
  Widget build(BuildContext context) {
    final classNameField = TextFormField(
      autofocus: false,
      controller: classNameController,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        classNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.class_outlined),
        contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        hintText: "Enter Class name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    //password field
    final classDescField = TextFormField(
      autofocus: false,
      controller: classDescController,
      onSaved: (value) {
        classDescController.text = value!;
      },
      textInputAction: TextInputAction.done,
      maxLines: 3,
      maxLength: 200,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.description_outlined),
        contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        hintText: "Enter Class Description",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final addClassBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.blue[300],
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
        minWidth: MediaQuery.of(context).size.width * 0.5,
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) {
          //     return const HomePage();
          //   }),
          // );
        },
        child: const Text(
          'Add Class',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: Text(
                    "Manage Class Students",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.normal),
                  ),
                ),
                Icon(
                  Icons.notifications_active_outlined,
                  color: Colors.black87,
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
                return const PupilsPage();
              }));
            },
          ),

          //tabs
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: Material(
              color: Colors.blueAccent,
              child: _tabBar,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(25.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Add Class",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      classNameField,
                      const SizedBox(
                        height: 20,
                      ),
                      classDescField,
                      const SizedBox(
                        height: 30,
                      ),
                      addClassBtn,
                      const SizedBox(
                        height: 50,
                      ),
                      const Text(
                        "List of Class",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Add Pupils",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
