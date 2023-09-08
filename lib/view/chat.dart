import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstbd233/constante/constant.dart';
import 'package:firstbd233/controller/firebase_helper.dart';
import 'package:firstbd233/model/my_user.dart';
import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart'; 

class ChatApp extends StatefulWidget {
  final MyUser correspondant;
  const ChatApp({required this.correspondant, super.key});

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      home: ChatScreen(correspondant:widget.correspondant),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final MyUser correspondant;
  const ChatScreen({required this.correspondant, super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatModel(),
      child: ChatScreenContent(correspondant: widget.correspondant),
    );
  }
}

class ChatMessage extends StatefulWidget {
  final dynamic message;
  final MyUser correspondant;
  ChatMessage({required this.message, required this.correspondant, super.key}); 
  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  Widget build(BuildContext context) {
    List persons = [moi.uid, widget.correspondant.uid];
    print(widget.message.data()['message']);
    final AlignmentGeometry alignment =
        (widget.message.data()['sid'] == moi.uid) ? Alignment.centerRight : Alignment.centerLeft;
    final Color messageColor =  (widget.message.data()['sid'] == moi.uid) ? Colors.green : Colors.white;
    if(
      (widget.message.data()['sid'] == widget.correspondant.uid || widget.message.data()['sid'] == moi.uid) &&
      (widget.message.data()['rid'] == widget.correspondant.uid || widget.message.data()['rid'] == moi.uid)) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: alignment,
              child: Text(
                (widget.message.data()['sid'] == moi.uid) ? moi.fullName : widget.correspondant.fullName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: alignment,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: messageColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(widget.message.data()['message']),
            ),
          ],
        ),
      );
    }
    else {
      return SizedBox.shrink();
    }
  }
}



class ChatScreenContent extends StatefulWidget {
    final MyUser correspondant;
  const ChatScreenContent({required this.correspondant, super.key});
  
  @override
  State<ChatScreenContent> createState() => _ChatScreenContentState();
}

  class _ChatScreenContentState extends State<ChatScreenContent> {
  final TextEditingController _textController = TextEditingController();
    List<DocumentSnapshot> mesMess = [];
    bool cond = false;
  @override
  Widget build(BuildContext context) {
    getMyMessages() async {
      List persons = [moi.uid, widget.correspondant.uid];
      List<DocumentSnapshot> myMessages = await FirebaseHelper().getMessages();
      //print(myMessages[1]['message']);
      print(myMessages.length);
      return myMessages;
    }
    final chatModel = getMyMessages();
    if(cond == false) {
      print('test');
    chatModel.then((value) {
      //print(value[0]['message']);
      setState(() {

      mesMess = value;
      });
      cond = true;
    })
    .catchError((error) {
      
      });
    }
      //print('test');
      if( true) {
        //print(mesMess);
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.correspondant.fullName),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: mesMess.length,
                  itemBuilder: (context, index) {
                    final message = mesMess[index];
                    return ChatMessage(message: message, correspondant: widget.correspondant);
                  },
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: _buildTextComposer(context),
              ),
            ],
          ),
        );
      }
      else {
        print('else');
      return SizedBox.shrink();
      }
  }

  Widget _buildTextComposer(BuildContext context) {
    final TextEditingController _textController = TextEditingController();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
              textInputAction: TextInputAction.send,
              onSubmitted: (text) {
                _handleSubmitted(context, text);
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Envoyer un message',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _handleSubmitted(context, _textController.text);
            },
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(BuildContext context, String text) {
                  //enregistrer dans la base de donnée
                  print('test');
                  print(text);
              FirebaseHelper().sendMsg(text, moi.uid, widget.correspondant.uid)
              .then((value) {
                print('envoye');
              })
              .catchError((onError) {
                print('erreur');
                Text("error");
              });
  }
}

class ChatModel extends ChangeNotifier {
  List<Message> _messages = [
    Message(
      text: 'Bonjour',
      isSentByMe: false,
    ),
    Message(
      text: 'Bonjour',
      isSentByMe: true,
    ),
  ];

  List<Message> get messages => _messages;

  void addMessage(Message message) {
    _messages.insert(0, message);
    notifyListeners();
  }
}

class Message {
  final String text;
  final bool isSentByMe;

  Message({required this.text, required this.isSentByMe});
}
