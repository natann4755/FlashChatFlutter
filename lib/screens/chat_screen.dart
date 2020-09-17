import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  static String id = "chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextControler = TextEditingController(); 
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  String messageText;

  set loggedInUserEmail(String loggedInUserEmail) {
    loggedInUserEmail = loggedInUserEmail;
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
        StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messagesSnapshot = snapshot.data.docs.toList();
            List messages = messagesSnapshot.reversed.toList();
            List<MessageBubble> messagesWidgets = [];
            for (var i = 0; i < messages.length; i++) {
              final messageText = messages[i].data()['text'];
              final messageSender = messages[i].data()['sender'];
              print(loggedInUser.email);
              print(messageSender);
              final messageWidget = MessageBubble(
                text: messageText,
                sender: messageSender,
                isMe: messageSender == loggedInUser.email,
              );
              messagesWidgets.add(messageWidget);
            }
            return Expanded(
              child: ListView(
                reverse: true,
                padding: EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 12.0),
                children: messagesWidgets,
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
        },
      ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextControler,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextControler.clear();
                      _firestore.collection('messages').add(
                          {'text': messageText, 'sender': loggedInUser.email});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.sender, this.isMe});
  final String text;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              color: Colors.black54,
                  fontSize: 12.0
            ),
          ),
          Material(
            borderRadius: isMe ? BorderRadius.only(
              topLeft: Radius.circular(30.0,),bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0)) : BorderRadius.only(
                topRight: Radius.circular(30.0,),bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0)),
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            elevation: 6.0,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0 ,horizontal: 15.0),
              child: Text(
                 text,
                style: TextStyle(fontSize: 15,
                    color: isMe ? Colors.white : Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
