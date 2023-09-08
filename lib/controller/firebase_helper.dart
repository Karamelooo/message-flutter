import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firstbd233/model/my_user.dart';

class FirebaseHelper {
  final auth = FirebaseAuth.instance;
  final cloudUsers = FirebaseFirestore.instance.collection("UTILISATEURS");
  final cloudMessages = FirebaseFirestore.instance.collection("messages");
  final storage = FirebaseStorage.instance;


  //inscrire un utiisateur
  Future<MyUser> inscription(String nom , String prenom , String email , String password) async {
    UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
    String uid = credential.user!.uid;
    Map<String,dynamic> data = {
      "NOM":nom,
      "PRENOM":prenom,
      "EMAIL": email,
    };
    addUser(uid, data);
    return getUser(uid);
}

Future<MyUser> getUser(String uid) async {
  DocumentSnapshot snapshot = await cloudUsers.doc(uid).get();
  return MyUser.bdd(snapshot);
}

Future<List<DocumentSnapshot>> getMessages() async {
  QuerySnapshot querySnapshot = await FirebaseHelper()
      .cloudMessages
      .orderBy('date', descending: true)
      .get();
  return querySnapshot.docs;
}
  //ajouter un utilisateur dans la base de donnée
  addUser(String uid,Map<String,dynamic>data ){
    cloudUsers.doc(uid).set(data);
  }
  
  //me connecter
  Future<MyUser> connexion(String email, String password) async {
    UserCredential credential = await auth.signInWithEmailAndPassword(email: email, password: password);
    String uid = credential.user!.uid;
    return getUser(uid);
  }

  //mise à jour d'un utilisateur

  updateUser(String uid, Map<String,dynamic> map) {
    cloudUsers.doc(uid).update(map);
  }

  // stocker un fichier
  Future<String> stockage(String dossier, String uidUser, String nameFile, Uint8List dataFile) async {
    TaskSnapshot snapshot = await storage.ref("/$dossier/$uidUser/$nameFile").putData(dataFile);
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }
    Future sendMsg(String message, String sid, String rid) async {
    Map<String,dynamic> data = {
      "message":message,
      "sid":sid,
      "rid": rid,
      "date":DateTime.now()
    };
    cloudMessages.add(data);
  }

}