import 'dart:typed_data';

import 'package:firstbd233/view/contacts.dart';
import 'package:firstbd233/view/liste_personne.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firstbd233/constante/constant.dart';
import 'package:firstbd233/controller/firebase_helper.dart';
import 'package:firstbd233/view/my_background.dart';
import 'package:firstbd233/constante/constant.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firstbd233/view/my_carte.dart';

import 'package:flutter/material.dart';

class MyDashBoard extends StatefulWidget {
  const MyDashBoard({super.key});

  @override
  State<MyDashBoard> createState() => _MyDashBoardState();
}

class _MyDashBoardState extends State<MyDashBoard> {
  // variables
  int indexPage = 0;
  @override
  Widget build(BuildContext context) {
    // variables
    String? nameFile;
    Uint8List? bytesFile;
    // fonctions
    pickPhoto() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:Text("Souhaitez-vous envoyer cette image ?"),
            content:Image.memory(bytesFile!),
            actions: [
              TextButton(
                onPressed: () {
                  nameFile = null;
                  bytesFile = null;
                  Navigator.pop(context);
                },
                child: Text("Annuler")
              ),
              TextButton(
                onPressed: () {
                  FirebaseHelper().stockage("IMAGES", moi.uid, nameFile!, bytesFile!)
                  .then((value) {
                    setState(() {
                      moi.avatar = value;
                    });
                    Map<String,dynamic> map = {
                      "AVATAR": moi.avatar
                    };
                    FirebaseHelper().updateUser(moi.uid, map);
                    Navigator.pop(context);
                  });
                },
                child: Text("Enregistrer")
              ),
            ],
          );
        }
      );
    }

    pickFile() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true
      );
      if(result != null) {
        nameFile = result.files.first.name;
        bytesFile = result.files.first.bytes;
        pickPhoto();
      }
    }
    return Scaffold(
      drawer: Container(
        color: Colors.purple,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.6,
        child:Column(
          children: [
            SizedBox(height: 30,),
            GestureDetector(
              onTap: () {
                pickFile();
              },
              child: CircleAvatar(
                radius:50,
                backgroundImage: NetworkImage(moi.avatar!),
              ),
            ),
            Divider(
              thickness:1,
              color: Colors.black
            ),
            Text("${moi.prenom} ${moi.nom}"),
            Text(moi.email),
            Text("Naissance le ${moi.birthday!.day.toString()}/${moi.birthday!.month.toString()}/${moi.birthday!.year.toString()}"),
          ]
        )
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple,
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            indexPage = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Personnes"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favoris"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chat"
          )
        ]
      ),
      body: Stack(
        children: [
          MyBackGroundPage(),
          bodyPage()
        ],
      )
    );
  }
  Widget bodyPage() {
    switch(indexPage) {
      case 0 : return ListPersonne(show:"all");
      case 1 : return ListPersonne(show:"fav");
      case 2 : return Contacts(); // TODO: chat
      default: return Text("Erreur");
    }
  }
}
