import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstbd233/constante/constant.dart';
import 'package:firstbd233/controller/firebase_helper.dart';
import 'package:firstbd233/model/my_user.dart';
import 'package:firstbd233/view/chat.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    // variables

    List myFavoris = moi.favoris;

    // fonctions

  
    return StreamBuilder<QuerySnapshot>(

      stream: FirebaseHelper().cloudUsers.where(FieldPath.documentId, whereIn: myFavoris).snapshots(),
      builder: (context,snap){
        if(snap.data == null){
          return const Center(child: Text("Aucun utilisateur"),);
        }
        else {
          List documents = snap.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
              itemBuilder: (context,index){
                MyUser users = MyUser.bdd(documents[index]);
                  return Card(
                    elevation: 5,
                    color: Colors.purple,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(users.avatar!),
                      ),
                      title: Text(users.fullName),
                      subtitle: Text(users.email),
                      onTap: () {  
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            //return Chat(correspondant:users);
                            return ChatApp(correspondant:users);
                          }
                        ));
                      }
                    ),
                  );
              }
            );
          }
        }
    );
  }
}