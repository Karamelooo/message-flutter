import 'package:cloud_firestore/cloud_firestore.dart';


class Message {
  late String id; 
  late DateTime timestamp; 
  late String content;
  late String senderId; 
  late String receiverId; 

  Message({
    required this.id,
    required this.timestamp,
    required this.content,
    required this.senderId,
    required this.receiverId,
  });


  Future<void> sendMessageToDatabase() async {
    try {
      await FirebaseFirestore.instance.collection('messages').doc(id).set({
        'id': id,
        'timestamp': timestamp,
        'content': content,
        'senderId': senderId,
        'receiverId': receiverId,
      });
      print('Message envoyé!');
    } catch (error) {
      print('Err : $error');
    }
  }

}