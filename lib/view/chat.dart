import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstbd233/constante/constant.dart';
import 'package:firstbd233/controller/firebase_helper.dart';
import 'package:firstbd233/model/my_user.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final MyUser correspondant;
  const Chat({required this.correspondant, super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    // variables
  TextEditingController message = TextEditingController();

    // fonctions

    return Scaffold(
      body:
      Column(
        children:[
          Card(
            elevation: 5,
            color: Colors.purple,
            child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.correspondant.avatar!),
              ),
              title: Text(widget.correspondant.fullName),
              subtitle: Text(widget.correspondant.email),
            ),
          ),
          TextField(
            controller:message,
            decoration: InputDecoration(
              hintText: "Tapez votre message...",
              prefixIcon: Icon(Icons.message),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15)
              )
            ),
          ),
          ElevatedButton(
            onPressed: (){
              ScaffoldMessenger.of(context).clearSnackBars();
              //enregistrer dans la base de donnée
              FirebaseHelper().sendMsg(message.text, moi.uid, widget.correspondant.uid)
              .then((value) {
              })
              .catchError((onError) {
                Text("error");
              });
            },
            child: Text("Enregistrement")
              ),
        ]
      )
    );
  }
}