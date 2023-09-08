import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstbd233/constante/constant.dart';
import 'package:firstbd233/controller/firebase_helper.dart';
import 'package:firstbd233/model/my_user.dart';
import 'package:flutter/material.dart'; 

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
    return MaterialApp(
      home: Scaffold(
        body: ChatScreenContent(correspondant: widget.correspondant),
      ),
    );
  }
}


class ChatMessage extends StatefulWidget {
  final dynamic message;
  final MyUser correspondant;
  const ChatMessage({required this.message, required this.correspondant, super.key}); 
  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  Widget build(BuildContext context) {
    final AlignmentGeometry alignment =
        (widget.message.data()['sid'] == moi.uid) ? Alignment.centerRight : Alignment.centerLeft;
    final Color messageColor =  (widget.message.data()['sid'] == moi.uid) ? Colors.green : Colors.white;
    if(
      (widget.message.data()['sid'] == widget.correspondant.uid || widget.message.data()['sid'] == moi.uid) &&
      (widget.message.data()['rid'] == widget.correspondant.uid || widget.message.data()['rid'] == moi.uid)) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: alignment,
              child: Text(
                (widget.message.data()['sid'] == moi.uid) ? moi.fullName : widget.correspondant.fullName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: alignment,
              padding: const EdgeInsets.all(10.0),
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
      return const SizedBox.shrink();
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
    List<DocumentSnapshot> mesMess = [];
    int count = 0;
  @override
  Widget build(BuildContext context) {
    getMyMessages() async {
      List<DocumentSnapshot> myMessages = await FirebaseHelper().getMessages();
      return myMessages;
    }
    final chatModel = getMyMessages();
    chatModel.then((value) {
      if(count < value.length) {
        setState(() {
        mesMess = value;
        count = value.length;
        });
      }
    })
    .catchError((error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:const Text("L'application a rencontré une erreur"),
            content:const Text("La conversation n'a pas pu être récupérée"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok")
              )
            ],
          );
        }
      );
    });
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
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildTextComposer(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: textController,
              textInputAction: TextInputAction.send,
              onSubmitted: (text) {
                _handleSubmitted(context, text);
              },
              decoration: const InputDecoration.collapsed(
                hintText: 'Envoyer un message',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _handleSubmitted(context, textController.text);
            },
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(BuildContext context, String text) {
    //enregistrer dans la base de données
    FirebaseHelper().sendMsg(text, moi.uid, widget.correspondant.uid)
    .then((value) {
      setState(() {});
    })
    .catchError((onError) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:const Text("L'application a rencontré une erreur"),
            content:const Text("Le message n'a pas pu s'envoyer"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok")
              )
            ],
          );
        }
      );
    });
  }
}