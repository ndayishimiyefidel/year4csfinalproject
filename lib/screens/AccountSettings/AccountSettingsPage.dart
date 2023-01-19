import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../resources/user_state_methods.dart';
import '../../widgets/ProgressWidget.dart';

class UserSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Account Settings",
          style: TextStyle(
              fontFamily: 'Courgette', letterSpacing: 1.25, fontSize: 24),
        ),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            focusColor: Colors.blueAccent,
            // icon: const FaIcon(FontAwesomeIcons.rightFromBracket),
            icon: const Icon(Icons.logout),
            onPressed: () => UserStateMethods().logoutuser(context),
          )
        ],
        centerTitle: true,
      ),
      body: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  State createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  late SharedPreferences preferences;
  late TextEditingController nameTextEditingController;
  late TextEditingController emailTextEditingController;
  late TextEditingController phoneTextEditingController;

  String id = "";
  String name = "";
  String email = "";
  String photoUrl = "";
  String phone = "";
  File? imageFileAvatar;
  final picker = ImagePicker();
  bool isLoading = false;
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  bool _status = true;
  bool isInitialLoading = false;
  final FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readDataFromLocal();
  }

  Future<String> readDataFromLocal() async {
    isInitialLoading = true;
    preferences = await SharedPreferences.getInstance();
    id = preferences.getString("uid")!;
    name = preferences.getString("name")!;
    photoUrl = preferences.getString("photo")!;
    email = preferences.getString("email")!;
    phone = preferences.getString("phone")!;

    nameTextEditingController = TextEditingController(text: name);
    emailTextEditingController = TextEditingController(text: email);
    phoneTextEditingController = TextEditingController(text: phone);

    isInitialLoading = false;
    setState(() {});
    // return Future.delayed(Duration(seconds: 2), () => "Hello");
    //return photoUrl;
    return null!;
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imageFileAvatar = File(pickedFile.path);
        isLoading = true;
      }
    });

    if (pickedFile != null) {
      // upload image to firebase storage
      uploadImageToFirestoreAndStorage();
    }
  }

  TaskSnapshot? taskSnapshot;
  Future uploadImageToFirestoreAndStorage() async {
    String mFileName = id;
    Reference reference = FirebaseStorage.instance.ref().child(mFileName);
    UploadTask uploadTask = reference.putFile(imageFileAvatar!);

    print(uploadTask);

    taskSnapshot = await (await uploadTask).ref.getDownloadURL().then(
        (newImageDownloadUrl) {
      photoUrl = newImageDownloadUrl;
      FirebaseFirestore.instance
          .collection("Users")
          .doc(id)
          .update({"photoUrl": photoUrl, "name": name}).then((data) async {
        await preferences.setString("photo", photoUrl);

        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "Updated Successfully.");
      });
    }, onError: (errorMsg) {
      setState(() {
        isLoading = false;
      });
    });

    // var imageUrl = await (await uploadTask).ref.getDownloadURL();
    // url = imageUrl.toString();
    // print(url);

    // taskSnapshot.ref.getDownloadURL().then((newImageDownloadUrl) {
    //   photoUrl = newImageDownloadUrl;
    //   FirebaseFirestore.instance
    //       .collection("Users")
    //       .doc(id)
    //       .update({"photoUrl": photoUrl, "name": name}).then((data) async {
    //     await preferences.setString("photo", photoUrl);
    //
    //     setState(() {
    //       isLoading = false;
    //     });
    //     Fluttertoast.showToast(msg: "Updated Successfully.");
    //   });
    // }, onError: (errorMsg) {
    //   setState(() {
    //     isLoading = false;
    //   });
  }

  void updateData() {
    nameFocusNode.unfocus();
    emailFocusNode.unfocus();
    phoneFocusNode.unfocus();
    setState(() {
      isLoading = false;
    });

    FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .update({"name": name, "phone": phone}).then((data) async {
      await preferences.setString("photo", photoUrl);
      await preferences.setString("name", name);

      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Updated Successfully.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return isInitialLoading
        ? oldcircularprogress()
        : Stack(
            children: <Widget>[
              SingleChildScrollView(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Column(
                  children: <Widget>[
                    //Profile Image - Avatar
                    Container(
                      child: Center(
                        child: Stack(
                          children: <Widget>[
                            (imageFileAvatar == null)
                                // ? (photoUrl != "")
                                ? Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Material(
                                            // display already existing image
                                            child: CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  Container(
                                                child:
                                                    const CircularProgressIndicator(
                                                  strokeWidth: 2.0,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Colors
                                                              .lightBlueAccent),
                                                ),
                                                width: 200.0,
                                                height: 200.0,
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                              ),
                                              imageUrl: photoUrl,
                                              width: 200.0,
                                              height: 200.0,
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(125.0)),
                                            clipBehavior: Clip.hardEdge),
                                      ],
                                    ),
                                  )
                                // : Icon(
                                //     Icons.account_circle,
                                //     size: 90.0,
                                //     color: Colors.grey,
                                //   )
                                : Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Material(
                                            // display new updated image
                                            child: Image.file(
                                              imageFileAvatar!,
                                              width: 200.0,
                                              height: 200.0,
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(125.0)),
                                            clipBehavior: Clip.hardEdge),
                                      ],
                                    ),
                                  ),
                            GestureDetector(
                              onTap: getImage,
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 150.0, right: 120.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const <Widget>[
                                      CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 25.0,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
                      width: double.infinity,
                      margin: const EdgeInsets.all(20.0),
                    ),

                    Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: isLoading ? oldcircularprogress() : Container(),
                      ),
                    ]),

                    Container(
                      color: const Color(0xFFFFFFFF),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: const <Widget>[
                                        Text(
                                          'Personal Information',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        _status ? _getEditIcon() : Container(),
                                      ],
                                    )
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: const <Widget>[
                                        Text(
                                          'Name',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          hintText: "Enter Your Name",
                                        ),
                                        controller: nameTextEditingController,
                                        enabled: !_status,
                                        autofocus: !_status,
                                        onChanged: (value) {
                                          name = value;
                                        },
                                        focusNode: nameFocusNode,
                                      ),
                                    ),
                                  ],
                                )),
                            //Telephone
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: const <Widget>[
                                        Text(
                                          'Telephone',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextField(
                                        readOnly: false,
                                        decoration: const InputDecoration(
                                            hintText: "Enter Phone number"),
                                        enabled: !_status,
                                        controller: phoneTextEditingController,
                                        focusNode: phoneFocusNode,
                                        onChanged: (value) {
                                          phone = value;
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                            //Email field
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: const <Widget>[
                                        Text(
                                          'Email ID',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextField(
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                            hintText: "Enter Email ID"),
                                        enabled: !_status,
                                        controller: emailTextEditingController,
                                        focusNode: emailFocusNode,
                                      ),
                                    ),
                                  ],
                                )),
                            !_status ? _getActionButtons() : Container(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                  child: ElevatedButton(
                child: Text("Update"),
                // textColor: Colors.white,
                // color: Colors.green,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                  updateData();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                // style: new RoundedRectangleBorder(
                //     borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                  child: ElevatedButton(
                child: Text("Cancel"),
                // textColor: Colors.white,
                // color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                  // logoutuser();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                // shape: new RoundedRectangleBorder(
                //     borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
