import 'package:final_year_4cs/screens/view_pupils.dart';
import 'package:flutter/material.dart';

//database services
import '../Widgetsapp/AppBar.dart';
import '../services/auth.dart';
import '../services/database_service.dart';
import 'add_pupils_to_parent.dart';

class ViewParents extends StatefulWidget {
  const ViewParents({Key? key}) : super(key: key);

  @override
  State<ViewParents> createState() => _ViewParentsState();
}

class _ViewParentsState extends State<ViewParents> {
  Stream<dynamic>? parentsStream;
  final bool _isLoading = false;
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
  Widget parentsList() {
    return StreamBuilder(
      stream: parentsStream,
      builder: (context, snapshot) {
        return snapshot.data == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return UsersTile(
                    uid: snapshot.data!.docs[index].data()['uid'],
                    photourl: snapshot.data!.docs[index].data()["photoUrl"],
                    name: snapshot.data.docs[index].data()["name"],
                    email: snapshot.data.docs[index].data()["email"],
                    phone: snapshot.data.docs[index].data()["phone"],
                    address: snapshot.data.docs[index].data()["address"],
                  );
                });
      },
    );
  }

  @override
  void initState() {
    databaseService.getParentsData().then((value) async {
      setState(() {
        parentsStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: CommonAppBar(
        title: "Parents List",
        menuenabled: true,
        notificationenabled: true,
        ontap: () {
          // _scaffoldKey.currentState!.openDrawer();
        },
      ),
      body: parentsList(),

      //floating button
    );
  }
}

class UsersTile extends StatelessWidget {
  final String photourl;
  final String name;
  final String email;
  final String phone;
  final String uid;
  final String address;

  UsersTile(
      {required this.name,
      required this.photourl,
      required this.email,
      required this.uid,
      required this.address,
      required this.phone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Colors.blueAccent,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: InkWell(
              onTap: () {},
              splashColor: Colors.green,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox(
                        height: 5,
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          photourl.toString(),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      //80% of screen width
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Parent Name : $name",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start),
                            Text("Email : $email", textAlign: TextAlign.start),
                            Text("Phone Number : $phone",
                                textAlign: TextAlign.start),
                            Text("Address : $address",
                                textAlign: TextAlign.start),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ViewPupils(uid, name);
                                          },
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "View",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return AddPupilsToParent(
                                                uid, phone);
                                          },
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Add New",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
