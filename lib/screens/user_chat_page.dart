import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_4cs/screens/Chats/UserList.dart';
import 'package:final_year_4cs/screens/parent_screens.dart';
import 'package:final_year_4cs/screens/single_chat_message.dart';
import 'package:final_year_4cs/screens/teacher_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/message_model.dart';
import '../models/msg_model.dart';
import '../models/user_model.dart';
import 'admin_screen.dart';

class UsersList extends StatefulWidget {
  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  bool _isLoading = false;
  List<UserModel> userList = [];
  List<Message> messageList = [];
  List<newUserModel> msgLit = [];

  Future<void> getAllUsersExceptLoginStatus() async {
    setState(() {
      _isLoading = true;
    });
    print(userId);
    await _firestore
        .collection("chats")
        .where("parent", isEqualTo: userId)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        var userData =
            await _firestore.collection("Users").doc(element['owner']).get();
        _firestore
            .collectionGroup("messages")
            .where("owner", isEqualTo: element['owner'])
            .where("parent", isEqualTo: userId)
            .get()
            .then((value) {
          Timestamp time = value.docs.last['createdAt'];
          var dateTime =
              DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
          var realtime = DateFormat('dd-MM-yyyy hh:mm:ss a').format(dateTime);
          newUserModel newUser = newUserModel(
              owner_id: element['owner'],
              parent_id: element['parent'],
              time: realtime,
              text: value.docs.last['mesage'],
              name: userData['name'],
              imageUrl: userData['photoUrl'],
              isOnline: true);
          setState(() {
            msgLit.add(newUser);
          });
        });
      });
      // print(value.docs.length);
      // value.docs.forEach((element) {
      //   UserModel userModel = UserModel(
      //       id: element.id,
      //       name: element['name'],
      //       imageUrl: element['photoUrl'],
      //       isOnline: false);
      //   setState(() {
      //     userList.add(userModel);
      //   });
      // });
    });
  }

  @override
  void initState() {
    getAllUsersExceptLoginStatus().whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Chats",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('Users')
                .where('uid', isEqualTo: userId)
                .get()
                .then((value) async {
              if (value.size == 1) {
                Map<String, dynamic> userData = value.docs.first.data();
                if (userData['role'] == "Admin") {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminScreen(
                                  currentUser: userId,
                                )));
                    _isLoading = false;
                  });
                } else if (userData['role'] == "Teacher") {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TeacherScreen(currentUser: userId)));
                    _isLoading = false;
                  });
                } else if (userData['role'] == "Parent") {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ParentScreen(currentUser: userId)));
                    _isLoading = false;
                  });
                } else {}
              } else {
                print('Email not found');
                setState(() {
                  _isLoading = false;
                });
              }
            });
          },
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            color: Colors.black,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : ListView.builder(
              itemCount: msgLit.length,
              itemBuilder: (BuildContext context, int index) {
                // final Message chat = messageList[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SingleUserMessage(
                          user: UserModel(
                              id: msgLit[index].owner_id,
                              name: msgLit[index].name,
                              imageUrl: msgLit[index].imageUrl,
                              isOnline: false),
                        );
                      },
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: //chat.unread
                              true
                                  ? BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      // shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 2,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                        ),
                                      ],
                                    )
                                  : BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(msgLit[index].imageUrl),
                            // backgroundImage: AssetImage(chat.sender.imageUrl),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        msgLit[index].name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // chat.sender.isOnline
                                      true
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  left: 5),
                                              width: 7,
                                              height: 7,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            )
                                          : Container(
                                              child: null,
                                            ),
                                    ],
                                  ),
                                  Text(
                                    msgLit[index].time,
                                    // "12:45 pm",
                                    // chat.time,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  // "Hello everyone"
                                  msgLit[index].text,
                                  // chat.text,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return UserList();
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
