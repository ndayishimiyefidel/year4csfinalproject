import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../utils/constants.dart';
import '../widgets/appwidget.dart';
import '../widgets/usernameEmail.dart';

class ProfileScreen extends StatefulWidget {
  final String? image;

  ProfileScreen({Key? key, this.image}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
//TODO Add your own Collection Name instead of 'users'
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
          context: context,
          title: 'Account profile',
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.edit_note_outlined,
                  color: Colors.black,
                  size: 30,
                ))
          ],
          leadingIcon: Icons.arrow_back_ios_new),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: usersCollection.doc(user?.uid).snapshots(),
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }
            return Column(
              children: [
                SizedBox(height: Get.height * 0.08),
                Center(
                  //TODO Display user profile image
                  child: Container(
                    height: Get.height * 0.18,
                    width: Get.height * 0.18,
                    decoration: BoxDecoration(
                      border: Border.all(color: kPrimaryColor),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                      child: streamSnapshot.data!['photoUrl'] !=
                              'Image goes here'
                          ? Image.network(
                              streamSnapshot.data!['photoUrl'],
                              fit: BoxFit.cover,
                            )
                          : Center(
                              //TODO Place your place holder Image
                              child:
                                  Image.asset('assets/images/userprofile.png'),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.08),
                Container(
                  child: buildShowUserNameAndEmail(
                    text: streamSnapshot.data!['name'],
                    icon: Icons.person_outline,
                    onPress: () {},
                  ),
                ),
                SizedBox(height: Get.height * 0.04),
                Container(
                  child: buildShowUserNameAndEmail(
                    text: streamSnapshot.data!['email'],
                    icon: Icons.email_outlined,
                    onPress: () {},
                  ),
                ),
                SizedBox(height: Get.height * 0.04),
                Container(
                  child: buildShowUserNameAndEmail(
                    text: streamSnapshot.data!['phone'],
                    icon: Icons.phone,
                    onPress: () {},
                  ),
                ),
                SizedBox(height: Get.height * 0.04),
                Container(
                  child: buildShowUserNameAndEmail(
                    text: 'Logout',
                    onPress: () {
                      // await _authService.signOut().then((value) {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => const SignInPage()));
                      // });
                    },
                    icon: Icons.logout,
                  ),
                ),
                SizedBox(height: Get.height * 0.04),
              ],
            );
          },
        ),
      ),
    );
  }
}
