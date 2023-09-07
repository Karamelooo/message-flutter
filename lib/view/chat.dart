import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstbd233/constante/constant.dart';
import 'package:firstbd233/controller/firebase_helper.dart';
import 'package:firstbd233/model/my_user.dart';
import 'package:firstbd233/model/my_message.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

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
  List persons = [moi.uid, widget.correspondant.uid];

    // fonctions

      return StreamBuilder<QuerySnapshot>(

      stream: FirebaseHelper().cloudMessages.where('sid', whereIn: persons).snapshots(),
      builder: (context,snap){
        if(snap.data == null){
          return Center(child: Text("Aucun message"),);
        }
        else {
          List documents = snap.data!.docs;
          return (ListView.builder(
            itemCount: documents.length,
              itemBuilder: (context,index){
                MyMessage messages = MyMessage.bdd(documents[index]);
                if(persons.contains(messages.receiverId)) {
                print(messages.content);
                  
                  return Card(
                    elevation: 5,
                    color: Colors.purple,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                      ),
                      title: Text(messages.content),
                      subtitle:Text(messages.receiverId)
                        ));
              }
              
                  else {
                    return SizedBox.shrink();
                  }
                      }
                    )
          );
              }
          
      },
          );
 

    // return Scaffold(
    //   body:
    //   Column(
    //     children:[
    //       Card(
    //         elevation: 5,
    //         color: Colors.purple,
    //         child: ListTile(
    //           leading: CircleAvatar(
    //             radius: 20,
    //             backgroundImage: NetworkImage(widget.correspondant.avatar!),
    //           ),
    //           title: Text(widget.correspondant.fullName),
    //           subtitle: Text(widget.correspondant.email),
    //         ),
    //       ),
      
    //      TextField(
    //         controller:message,
    //         decoration: InputDecoration(
    //           hintText: "Tapez votre message...",
    //           prefixIcon: Icon(Icons.message),
    //           filled: true,
    //           fillColor: Colors.white,
    //           border: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(15)
    //           )
    //         ),
    //       ),
    //       ElevatedButton(
    //         onPressed: (){
    //           //enregistrer dans la base de donnée
    //           FirebaseHelper().sendMsg(message.text, moi.uid, widget.correspondant.uid)
    //           .then((value) {
    //             print('envoye');
    //           })
    //           .catchError((onError) {
    //             print('erreur');
    //             Text("error");
    //           });
    //         },
    //         child: Text("Enregistrement")
    //           ),
    //     ]
    //   )
    // );
  }
}