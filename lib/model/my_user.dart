import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstbd233/constante/constant.dart';

class MyUser {
  late String uid;
  late String nom;
  late String prenom;
  late String email;
  String? avatar;
  DateTime? birthday;
  late List<dynamic> favoris;


  MyUser(){
    uid = "";
    nom = "";
    prenom = "";
    email = "";
    favoris = [];
  }

  MyUser.bdd(DocumentSnapshot snapshot){
    uid = snapshot.id;
    Map<String,dynamic> map =  snapshot.data() as Map<String,dynamic>;
    nom = map["NOM"];
    prenom = map["PRENOM"];
    email = map["EMAIL"];
    avatar = map["AVATAR"]??defaultImage;
    favoris = map["favoris"]??[];
    Timestamp? timestamp = map["BIRTHDAY"];
    if(timestamp == null) {
      birthday = DateTime.now();
    }
    else {
      birthday = timestamp.toDate();
    }
  }

    String get fullName {
    return "$prenom $nom";
  }

}