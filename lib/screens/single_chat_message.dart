import 'package:final_year_4cs/models/message_model.dart';
import 'package:final_year_4cs/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SingleUserMessage extends StatefulWidget {
  final User user;
  const SingleUserMessage({super.key, required this.user});
  @override
  State<SingleUserMessage> createState() => _SingleUserMessageState();
}

class _SingleUserMessageState extends State<SingleUserMessage> {
  int prevUserId = 0;
  _chatbuble(Message message, bool isMe, bool isSameUser) {
    if (isMe) {
      //current user or sender of the message
      return Column(
        children: <Widget>[
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
                        backgroundImage: AssetImage(message.sender.imageUrl),
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
                  backgroundImage: AssetImage(widget.user.imageUrl),
                  maxRadius: 20,
                ),
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
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              scrollDirection: Axis.vertical,
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final Message message = messages[index];
                final bool isMe = message.sender.id == currentUser.id;
                final bool isSameUser = prevUserId == message.sender.id;
                prevUserId = message.sender.id;

                return _chatbuble(message, isMe, isSameUser);
              },
            ),
          ),
          const SizedBox(
            height: 5,
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
          const Expanded(
            child: TextField(
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
            onPressed: () {},
            icon: const Icon(Icons.send),
            iconSize: 30,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
