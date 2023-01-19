import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_4cs/screens/single_chat_message.dart';
import 'package:final_year_4cs/screens/user_chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/message_model.dart';
import '../models/user_model.dart';
import '../services/auth.dart';
import '../services/database_service.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  Stream<dynamic>? userStream;
  bool _isLoading = false;
  List<UserModel> userList = [];
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
  final user = FirebaseAuth.instance.currentUser!.uid;
  var _firestore = FirebaseFirestore.instance;
  getAllUsersExceptLoginStatus() async {
    setState(() {
      _isLoading = true;
    });

    await _firestore
        .collection("Users")
        .where("uid", isNotEqualTo: user)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        UserModel userModel = UserModel(
            id: element.id,
            name: element['name'],
            imageUrl: element['photoUrl'],
            isOnline: false);
        userList.add(userModel);
      });
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getAllUsersExceptLoginStatus();
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
          "Users",
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
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return UsersList();
            }));
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
          ? Container(
              height: 200,
              // padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()))
          : ListView.builder(
              itemCount: userList.length,
              itemBuilder: (BuildContext context, int index) {
                final Message chat = chats[index];
                return GestureDetector(
                  onTap: () async {
                    print("clicked");
                    await _firestore
                        .collection("chats")
                        .where("owner", isEqualTo: "${userList[index].id}")
                        .where("parent", isEqualTo: user)
                        .get()
                        .then((value) async {
                      print(value.docs.length);
                      if (value.docs.length <= 0) {
                        await _firestore.collection("chats").add({
                          "owner": userList[index].id,
                          "parent": user
                        }).whenComplete(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SingleUserMessage(
                                  user: userList[index],
                                );
                              },
                            ),
                          );
                        });
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SingleUserMessage(
                                user: userList[index],
                              );
                            },
                          ),
                        );
                      }
                    });
                  },
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
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
                            ),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  NetworkImage(userList[index].imageUrl),
                            ),
                            // AssetImage(userList[index].imageUrl),
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
                                          userList[index].name,
                                          // chat.sender.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        false
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
