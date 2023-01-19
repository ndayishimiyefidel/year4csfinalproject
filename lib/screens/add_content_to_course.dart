import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//database services
import '../services/database_service.dart';
import '../utils/utils.dart';
import '../widgets/Drawer.dart';
import '../widgets/appBar.dart';

class AddContentToCourse extends StatefulWidget {
  final String coursecode;
  const AddContentToCourse(this.coursecode);

  @override
  State<AddContentToCourse> createState() => _AddContentToCourseState();
}

class _AddContentToCourseState extends State<AddContentToCourse> {
  final _formkey = GlobalKey<FormState>();
  String contentname = "", subcontentname = "";
  //adding controller
  final TextEditingController contentnameController = TextEditingController();
  final TextEditingController subcontenameController = TextEditingController();

  //database service
  bool _isLoading = false;
  DatabaseService databaseService = DatabaseService();
  uploadConentData() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      Map<String, String> conetentMap = {
        "content-name": contentname,
        "date": cdate2
      };
      print(widget.coursecode);
      print(contentname);

      await FirebaseFirestore.instance
          .collection("Course-Content")
          .where("content-name", isEqualTo: contentname.toString())
          .get()
          .then((value) async {
        if (value.size == 1) {
          print("content already exist");
          setState(() {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              const snackBar = SnackBar(
                  content: Text(
                    "content already exist",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18,
                    ),
                  ),
                  duration: Duration(seconds: 2));
              messengerKey.currentState!.showSnackBar(snackBar);
              _isLoading = false;
            });
          });
        } else {
          await databaseService
              .addContentToCourse(conetentMap, widget.coursecode)
              .then((value) {
            setState(() {
              //save is sub content
              WidgetsBinding.instance.addPostFrameCallback((_) {
                const snackBar = SnackBar(
                    content: Text(
                      "Content information saved successfully",
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 18,
                      ),
                    ),
                    duration: Duration(seconds: 2));
                messengerKey.currentState!.showSnackBar(snackBar);
              });
              _isLoading = false;
            });
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentField = TextFormField(
      autofocus: false,
      controller: contentnameController,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        contentnameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
          ),
        ),
        prefixIcon: const Icon(
          Icons.content_paste,
          color: Colors.green,
        ),
        filled: true,
        fillColor: Colors.green[50],
        labelText: "Content Name",
        labelStyle: const TextStyle(color: Colors.green),
      ),
      onChanged: (val) {
        contentname = val;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (input) => input != null && input.isEmpty
          ? 'Content name is required please..'
          : null,
    );
    //quiz title field
    final subcontentField = TextFormField(
      autofocus: false,
      controller: subcontenameController,
      onSaved: (value) {
        subcontenameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
          ),
        ),
        prefixIcon: const Icon(
          Icons.subject_outlined,
          color: Colors.green,
        ),
        filled: true,
        fillColor: Colors.green[50],
        labelText: "Sub Content",
        labelStyle: const TextStyle(color: Colors.green),
      ),
      onChanged: (val) {
        subcontentname = val;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (input) =>
          input != null && input.length < 1 ? 'pupil age is required' : null,
    );
    final addConntentBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.blue[300],
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
        minWidth: MediaQuery.of(context).size.width * 0.3,
        onPressed: () {
          uploadConentData();
        },
        child: const Text(
          'Add Content',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    final addsubmitBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.blue[300],
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
        minWidth: MediaQuery.of(context).size.width * 0.3,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text(
          'Finish',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70), child: appBar(context)),
      drawer: appDrawer(context),
      body: _isLoading
          ? Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: _isLoading
                      ? Container(
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Form(
                          key: _formkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "Add Course Content",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Feel free to create content,it's simple and easy!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const SizedBox(
                                height: 45,
                              ),
                              contentField,
                              const SizedBox(
                                height: 25,
                              ),
                              subcontentField,
                              const SizedBox(
                                height: 45,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [addConntentBtn, addsubmitBtn],
                              )
                            ],
                          ),
                        ),
                ),
              ),
            ),
    );
  }
}
