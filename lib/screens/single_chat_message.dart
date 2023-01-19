import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_4cs/models/message_model.dart';
import 'package:final_year_4cs/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SingleUserMessage extends StatefulWidget {
  final UserModel user;
  const SingleUserMessage({super.key, required this.user});
  @override
  State<SingleUserMessage> createState() => _SingleUserMessageState();
}

class _SingleUserMessageState extends State<SingleUserMessage> {
  final fieldText = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!.uid;
  bool _isLoading = false;
  String prevUserId = "";
  String? msg;
  _chatbuble(Message message, bool isMe, bool isSameUser) {
    if (isMe) {
      //current user or sender of the message
      return Column(
        children: <Widget>[
          Column(
            children: [
              Container(
                alignment: Alignment.topRight,
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.80,
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                message.time,
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          !isSameUser
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      message.time,
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
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
                        radius: 15,
                        backgroundImage: NetworkImage(message.sender.imageUrl),
                        // backgroundImage: AssetImage(message.sender.imageUrl),
                      ),
                    ),
                  ],
                )
              : Container(
                  child: null,
                ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.80,
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                message.time,
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 12,
                ),
              )
            ],
          ),
          !isSameUser
              ? Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
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
                        radius: 15,
                        backgroundImage: AssetImage(message.sender.imageUrl),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      message.time,
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 12,
                      ),
                    ),
                  ],
                )
              : Container(
                  child: null,
                ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  maxRadius: 20,
                  backgroundImage: NetworkImage(widget.user.imageUrl),
                ),
                // backgroundImage: AssetImage(widget.user.imageUrl),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.user.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      widget.user.isOnline
                          ? Text(
                              "Online",
                              style: TextStyle(
                                  color: Colors.green.shade600, fontSize: 12),
                            )
                          : Text(
                              "Offline",
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 12),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.call_outlined,
              color: Colors.blue[200],
              size: 25,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.videocam_outlined,
              color: Colors.blue[200],
              size: 25,
            ),
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _firestore
                    .collectionGroup("messages")
                    .where("owner", isEqualTo: widget.user.id)
                    .where("parent", isEqualTo: user)
                    .snapshots(),
                builder: (context, snapshot) {
                  // print(snapshot.data!.docs.length);
                  if (!snapshot.hasData) {
                    return Text(
                      'No Data...',
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CircularProgressIndicator(
                                color: Colors.blueAccent,
                                backgroundColor: Colors.orange,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "sending,Please Wait...",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                ),
                              )
                            ],
                          )
                        : Container(
                            child: null,
                          );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(15),
                    scrollDirection: Axis.vertical,
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      UserModel usesrModel = UserModel(
                          id: "", name: "", imageUrl: "", isOnline: true);
                      var userData = _firestore
                          .collection("Users")
                          .doc(snapshot.data!.docs[index]['senderId'])
                          .get()
                          .then((value) {
                        usesrModel = UserModel(
                            id: snapshot.data!.docs[index]['senderId'],
                            name: value.data()!['name'],
                            imageUrl: value.data()!['photoUrl'],
                            isOnline: true);
                      });
                      Timestamp time = snapshot.data!.docs[index]['createdAt'];
                      var dateTime = DateTime.fromMillisecondsSinceEpoch(
                          time.millisecondsSinceEpoch);
                      var realtime =
                          DateFormat('dd-MM-yyyy hh:mm:ss a').format(dateTime);
                      print(realtime);
                      // print(dateTime);
                      final Message message = Message(
                          sender: usesrModel,
                          time: "$realtime",
                          text: snapshot.data!.docs[index]['mesage'],
                          unread: true);

                      final bool isMe =
                          snapshot.data!.docs[index]['senderId'] == user;
                      // final bool isSameUser =
                      //     prevUserId == snapshot.data!.docs[index]['senderId'];
                      // prevUserId = snapshot.data!.docs[index]['senderId'];

                      return _chatbuble(message, isMe, true);
                    },
                  );
                }),
          ),
          const SizedBox(
            height: 5,
          ),
          _isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      color: Colors.blueAccent,
                      backgroundColor: Colors.orange,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "sending,Please Wait...",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    )
                  ],
                )
              : Container(
                  child: null,
                ),
          _sendMessageArea(),
        ],
      ),
    );
  }

  _sendMessageArea() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(6),
      height: 50,
      child: Row(
        children: <Widget>[
          IconButton(
            alignment: Alignment.topLeft,
            onPressed: () {},
            icon: const Icon(Icons.mic_none_rounded),
            iconSize: 30,
            color: Colors.grey,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              onChanged: (val) {
                msg = val;
              },
              controller: fieldText,
              decoration:
                  InputDecoration.collapsed(hintText: 'send message...'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            alignment: Alignment.topRight,
            onPressed: () {},
            icon: const Icon(Icons.copy),
            iconSize: 30,
            color: Colors.grey,
          ),
          IconButton(
            alignment: Alignment.topRight,
            onPressed: () async {
              //send chat to firestore
              setState(() {
                _isLoading = true;
              });
              _firestore
                  .collection("chats")
                  .where("owner", isEqualTo: "${widget.user.id}")
                  .where("parent", isEqualTo: user)
                  .get()
                  .then((value) async {
                var now = DateTime.now();
                var dateTime = DateTime.fromMillisecondsSinceEpoch(
                    now.millisecondsSinceEpoch);
                var realtime =
                    DateFormat('dd-MM-yyyy hh:mm:ss a').format(dateTime);
                print(realtime);
                var formatterDate = DateFormat('yyyy-MM-dd – kk:mm');
                // var formatterTime = DateFormat('hh:mm:ss');
                String actualDate = formatterDate.format(now);
                print(actualDate);

                _firestore
                    .collection("chats")
                    .doc(value.docs.first.id)
                    .collection("messages")
                    .add({
                  "mesage": msg,
                  "owner": "${widget.user.id}",
                  "parent": user,
                  "senderId": user,
                  "createdAt": DateTime.now()
                }).then((value) {
                  setState(() {
                    _isLoading = false;
                    fieldText.clear();
                  });
                });
              });
            },
            icon: const Icon(Icons.send),
            iconSize: 30,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
