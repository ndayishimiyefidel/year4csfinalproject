import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/chat_for_chats_screen.dart';
import '../../constants.dart';
import '../ChatDetail/ChattingPage.dart';
import 'UserList.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  // List allUsers = [];
  var allUsersWithDetails = [];
  late String? currentuserid;
  late String currentusername;
  late String currentuserphoto;
  late SharedPreferences preferences;
  // bool isLoading = false;

  @override
  initState() {
    super.initState();
    _getUsersDetails();
  }

  getCurrUserId() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      currentuserid = preferences.getString("uid")!;
      currentusername = preferences.getString("name")!;
      currentuserphoto = preferences.getString("photo")!;
    });
  }

  _getUsersDetails() async {
    await getCurrUserId();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Users").get();

    setState(() {
      allUsersWithDetails = querySnapshot.docs;
      allUsersWithDetails
          .removeWhere((element) => element["uid"] == currentuserid!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chats',
          style: TextStyle(
              fontFamily: 'Courgette', letterSpacing: 1.25, fontSize: 24),
        ),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: DataSearch(
                      allUsersList: allUsersWithDetails,
                      currentuserid: currentuserid!,
                      currentusername: currentusername,
                      currentuserphoto: currentuserphoto));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(currentuserid!)
                  .collection("chatList")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                        kPrimaryColor,
                      )),
                    ),
                    height: MediaQuery.of(context).copyWith().size.height -
                        MediaQuery.of(context).copyWith().size.height / 5,
                    width: MediaQuery.of(context).copyWith().size.width,
                  );
                } else if (snapshot.data!.docs.length == 0) {
                  return Container(
                    child: Column(
                      children: [
                        Text(
                          "No recent chats found",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Start searching to chat",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    height: MediaQuery.of(context).copyWith().size.height -
                        MediaQuery.of(context).copyWith().size.height / 5,
                    width: MediaQuery.of(context).copyWith().size.width,
                  );
                } else {
                  print("current user Id  ${currentuserid!}");
                  return ListView.builder(
                    padding: EdgeInsets.only(top: 16),
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ChatChatsScreen(
                        data: snapshot.data!.docs[index],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
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

// Search Bar

class DataSearch extends SearchDelegate {
  DataSearch(
      {this.allUsersList,
      required this.currentuserid,
      required this.currentusername,
      required this.currentuserphoto});
  var allUsersList;
  String? currentuserid;
  String currentusername;
  String currentuserphoto;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
    // Actions for AppBar
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading Icon on left of appBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some result based on selection

    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show when someone searches for something
    var userList = [];
    allUsersList.forEach((e) {
      userList.add(e);
    });
    var suggestionList = userList;

    if (query.isNotEmpty) {
      suggestionList = [];
      userList.forEach((element) {
        if (element["name"].toLowerCase().startsWith(query.toLowerCase())) {
          suggestionList.add(element);
        }
      });
    }
    return ListView.builder(
        itemBuilder: (context, index) => ListTile(
              onTap: () {
                close(context, null);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Chat(
                    receiverId: suggestionList[index]["uid"],
                    receiverAvatar: suggestionList[index]["photoUrl"],
                    receiverName: suggestionList[index]["name"],
                    currUserId: currentuserid!,
                    currUserName: currentusername,
                    currUserAvatar: currentuserphoto,
                  );
                }));
              },
              leading: Icon(Icons.person),
              title: RichText(
                text: TextSpan(
                    text: suggestionList[index]["name"]
                        .toLowerCase()
                        .substring(0, query.length),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: suggestionList[index]["name"]
                              .toLowerCase()
                              .substring(query.length),
                          style: TextStyle(color: Colors.grey))
                    ]),
              ),
            ),
        itemCount: suggestionList.length);
    throw UnimplementedError();
  }
}
