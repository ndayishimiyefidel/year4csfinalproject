import 'package:final_year_4cs/screens/admin_manager.dart';
import 'package:final_year_4cs/screens/single_chat_message.dart';
import 'package:flutter/material.dart';

import '../models/message_model.dart';

class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
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
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const AdminManagePage();
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
      body: ListView.builder(
          itemCount: chats.length,
          itemBuilder: (BuildContext context, int index) {
            final Message chat = chats[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SingleUserMessage(
                      user: chat.sender,
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
                      decoration: chat.unread
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
                        backgroundImage: AssetImage(chat.sender.imageUrl),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    chat.sender.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  chat.sender.isOnline
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          width: 7,
                                          height: 7,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        )
                                      : Container(
                                          child: null,
                                        ),
                                ],
                              ),
                              Text(
                                chat.time,
                                style: const TextStyle(
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
                              chat.text,
                              style: const TextStyle(
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
    );
  }
}
