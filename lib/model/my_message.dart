import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstbd233/constante/constant.dart';

class MyMessage {
  late String id; 
  late Timestamp timestamp; 
  late String content;
  late String senderId; 
  late String receiverId; 

  MyMessage({
    required this.id,
    required this.timestamp,
    required this.content,
    required this.senderId,
    required this.receiverId,
  });

  MyMessage.bdd(DocumentSnapshot snapshot){
    id = snapshot.id;
    Map<String,dynamic> map =  snapshot.data() as Map<String,dynamic>;
    content = map["message"];
    senderId = map["sid"];
    receiverId = map["rid"];
    timestamp = map["date"];
  }

}