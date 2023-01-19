import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_4cs/screens/sign_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enum/user_state.dart';
import '../utils/utils1.dart';

class UserStateMethods {
  late SharedPreferences preferences;

  void setUserState({required String userId, required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);
    FirebaseFirestore.instance.collection("Users").doc(userId).update({
      "state": stateNum,
      "lastSeen": DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  Stream<DocumentSnapshot> getUserStream({required String uid}) =>
      FirebaseFirestore.instance.collection("Users").doc(uid).snapshots();

  Future<Null> logoutuser(BuildContext context) async {
    preferences = await SharedPreferences.getInstance();
    setUserState(
        userId: preferences.getString("uid").toString(),
        userState: UserState.Offline);
    await FirebaseAuth.instance.signOut();
    await preferences.clear();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SignInPage()),
        (route) => false);
  }
}
