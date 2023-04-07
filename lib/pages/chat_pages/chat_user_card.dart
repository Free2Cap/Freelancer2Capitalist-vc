import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:freelancer2capitalist/models/chat_room_model.dart';
import 'package:freelancer2capitalist/pages/chat_pages/search_page.dart';
import 'package:freelancer2capitalist/pages/chat_pages/video_call/screens/pickup_layout.dart';

import '../../models/FirebaseHelper.dart';
import '../../models/UIHelper.dart';
import '../../models/user_model.dart';
import '../../utils/applifecycle.dart';
import 'chat_room.dart';

class ChatUserCard extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const ChatUserCard(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  final ChatVisitedNotifier _isChatRoomVisited = ChatVisitedNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: Text(
          "Chats",
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chatrooms")
                .where("users", arrayContains: widget.userModel.uid)
                .orderBy('sequnece', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot chatroomSnapshot =
                      snapshot.data as QuerySnapshot;

                  return ListView.builder(
                    itemCount: chatroomSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                          chatroomSnapshot.docs[index].data()
                              as Map<String, dynamic>);

                      Map<String, dynamic> participants =
                          chatRoomModel.participants!;

                      List<String> participantsKeys =
                          participants.keys.toList();

                      participantsKeys.remove(widget.userModel.uid);

                      return FutureBuilder(
                        future: FirebaseHelper.getUserModelById(
                            participantsKeys[0]),
                        builder: (context, userData) {
                          if (userData.connectionState ==
                              ConnectionState.done) {
                            if (userData.data != null) {
                              UserModel targetUser = userData.data as UserModel;
                              final ChatVisitedNotifierId _isChatRoomVisitedId =
                                  ChatVisitedNotifierId(
                                      widget.userModel.uid.toString());
                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return ChatRoom(
                                        chatVisitedNotifierId:
                                            _isChatRoomVisitedId,
                                        chatVisitedNotifier: _isChatRoomVisited,
                                        firebaseUser: widget.firebaseUser,
                                        userModel: widget.userModel,
                                        targetUser: targetUser,
                                        chatRoom: chatRoomModel,
                                      );
                                    }),
                                  );
                                },
                                leading: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.purple,
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      targetUser.profilepic.toString(),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  targetUser.fullname.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                subtitle:
                                    (chatRoomModel.lastMessage.toString() != "")
                                        ? Text(
                                            chatRoomModel.lastMessage
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                          )
                                        : Text(
                                            "Say hi to ${targetUser.fullname}",
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                trailing: Icon(
                                  Icons.chat,
                                  color: Colors.grey[600],
                                  size: 30,
                                ),
                              );
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: Text("No chats"),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //UIHelper.showLoadingDialog(context, "Loading...");
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SearchPage(
                userModel: widget.userModel, firebaseUser: widget.firebaseUser);
          }));
        },
        child: const Icon(Icons.search,color: Colors.white,size: 30,),
        
      ),
    );
  }
}
