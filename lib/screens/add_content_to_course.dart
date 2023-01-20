import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_4cs/components/text_field_container.dart';
import 'package:final_year_4cs/screens/backgrounds/background.dart';
import 'package:flutter/material.dart';

//database services
import '../Widgetsapp/AppBar.dart';
import '../constants.dart';
import '../services/database_service.dart';
import '../utils/utils.dart';
import '../widgets/Drawer.dart';

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
    final contentField = TextFieldContainer(
      child: TextFormField(
        autofocus: false,
        controller: contentnameController,
        keyboardType: TextInputType.text,
        onSaved: (value) {
          contentnameController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.content_paste,
            color: kPrimaryColor,
          ),
          hintText: "Content Name",
          border: InputBorder.none,
        ),
        onChanged: (val) {
          contentname = val;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (input) => input != null && input.isEmpty
            ? 'Content name is required please..'
            : null,
      ),
    );
    //quiz title field
    final subcontentField = TextFieldContainer(
      child: TextFormField(
        autofocus: false,
        controller: subcontenameController,
        onSaved: (value) {
          subcontenameController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.subject_outlined,
            color: kPrimaryColor,
          ),
          hintText: "Sub Content",
          border: InputBorder.none,
        ),
        onChanged: (val) {
          subcontentname = val;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
    final addConntentBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: kPrimaryColor,
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
        minWidth: MediaQuery.of(context).size.width * 0.4,
        onPressed: () async {
          await uploadConentData();
        },
        child: const Text(
          'ADD CONTENT',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
    final addsubmitBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: kPrimaryColor,
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
        minWidth: MediaQuery.of(context).size.width * 0.4,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text(
          'FINISH',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
    return Scaffold(
      // appBar: PreferredSize(
      //       //     preferredSize: const Size.fromHeight(70), child: appBar(context)),
      appBar: CommonAppBar(
        title: "Add Content",
        menuenabled: true,
        notificationenabled: true,
        ontap: () {},
      ),
      drawer: appDrawer(context),

      body: Background(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.only(left: 30, right: 20),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text(
                      "Add Course Contents",
                      style: TextStyle(
                        fontSize: 22,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Feel free to create content,it's simple and easy!",
                      textAlign: TextAlign.left,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [addConntentBtn, addsubmitBtn],
                    ),
                    _isLoading
                        ? Container(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            child: null,
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
