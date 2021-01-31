import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ChatScreen extends StatefulWidget {
  static String id ='chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  dynamic _uid ;
  String messageText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    //getMessages();
  }

  // void getMessages() async
  // {
  //   _firestore.collection("messages").get().then((querySnapshot) {
  //     querySnapshot.docs.forEach((result) {
  //       print(result.data());
  //     });
  //   });
  // }
  //

  void messageStream()async{
    await _firestore.collection("messages").snapshots().listen((result) {
      result.docs.forEach((result) {
        print(result.data());
      });
    });
    }


  void getCurrentUser() async{
    final user = await _auth.currentUser;
    final uid = user.email;
    _uid =uid;
    if(user != null)
      {
        print(uid);
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
                //getMessages();
                messageStream();
                // _auth.signOut();
                // Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: const Color(0xff0f3057),
      ),
      backgroundColor: const Color(0xffe7e7de),
      body: SafeArea(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(builder: (context,snapshot){
              if(!snapshot.hasData)
                {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: const Color(0xff00587a),
                    ),
                  );
                }
              if(snapshot.hasData )
                {
                  final messages = snapshot.data.docs.reversed;

                  List <MessageBubble> messageWidgets = [];
                  for(var message in messages)
                    {
                      final messageText = message.data()['text'];
                      final messageSender = message.data()['sender'];
                      final currentUser = _uid.toString();
                      final messageWidget = MessageBubble(text: messageText,sender: messageSender,
                      isme: currentUser==messageSender,);

                      messageWidgets.add(messageWidget);
                    }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10,),
                      children: messageWidgets,
                    ),
                  );
                }

            },
            stream: _firestore.collection('messages').snapshots(),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      style: TextStyle(color: Colors.black87),
                      onChanged: (value) {
                        messageText = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add({'text': messageText,
                                                              'sender': _uid.toString()});

                      //Implement send functionality.
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
  final String text;
  final String sender;
  final bool isme;
  MessageBubble({this.text,this.sender,this.isme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isme? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: [
          Text(sender,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),),
          Material(
            borderRadius: isme?  BorderRadius.only(topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
            : BorderRadius.only(topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
            elevation: 5,
            color: isme? const Color(0xff00587a): const Color(0xff008891),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical:10,),
              child: Text('$text',
                style: TextStyle(
                  color: const Color(0xffe7e7de),
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }
}
