import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_4cs/screens/OverallAttendance.dart';
import 'package:final_year_4cs/screens/onboarding_screen.dart';
import 'package:final_year_4cs/screens/parent_screens.dart';
import 'package:final_year_4cs/screens/sign_page.dart';
import 'package:final_year_4cs/screens/teacher_screen.dart';
import 'package:final_year_4cs/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../utils/utils.dart';
import 'firebase_options.dart';
import 'screens/admin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: messengerKey,
      // theme: ThemeData(
      //   scaffoldBackgroundColor: kBackgroundColor,
      //   textTheme: Theme.of(context).textTheme.apply(
      //         bodyColor: kPrimaryColor,
      //         fontFamily: 'Montserrat',
      //       ),
      // ),
      home: const OnBoardingScreen(),
      builder: EasyLoading.init(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            UserHelper.saveUser(snapshot.data!);
            return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(snapshot.data!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final userDoc = snapshot.data;
                    final user = userDoc?.get(snapshot);
                    if (user["role"] == 'Admin') {
                      return AdminScreen(
                        currentUser: userId,
                      );
                    } else if (user["role"] == "Teacher") {
                      return TeacherScreen(
                        currentUser: user.uid,
                      );
                    } else if (user["role"] == "Parent") {
                      return ParentScreen(
                        currentUser: userId,
                      );
                    }
                  } else {
                    return const OnBoardingScreen();
                  }
                  return null!;
                }
                // else{
                //   return Material(
                //     child: Center(child: CircularProgressIndicator(),),
                //   );
                // }

                );
          }
          return const SignInPage();
        });
  }
}
