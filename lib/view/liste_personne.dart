import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstbd233/constante/constant.dart';
import 'package:firstbd233/controller/firebase_helper.dart';
import 'package:firstbd233/model/my_user.dart';
import 'package:flutter/material.dart';

class ListPersonne extends StatefulWidget {
  final String show;
  const ListPersonne({required this.show, super.key});

  @override
  State<ListPersonne> createState() => _ListPersonneState();
}

class _ListPersonneState extends State<ListPersonne> {
  @override
  Widget build(BuildContext context) {
    // fonctions
    infoUser(MyUser user) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:Text("Profil de ${user.fullName}"),
            content:Column(
              children: [
                Text("Prénom : ${user.prenom}"),
                Text("Nom : ${user.nom}"),
                Text("Adresse : ${user.email}"),
                Text("Date de naissance : ${user.birthday!.day.toString()}/${user.birthday!.month.toString()}/${user.birthday!.year.toString()}")

              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Retour")
              ),
            ],
          );
        }
      );
    }

    
    addFavorite(userToAdd) {
      List<dynamic> newFavorite = moi.favoris;
      showDialog(
        context: context,
        builder: (context) {
          if(moi.favoris.contains(userToAdd.uid)) {
            return AlertDialog(
            title:Text("Retirer un favori"),
            content:
                Text("Souhaitez-vous retirer ${userToAdd.fullName} de vos favoris ?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Non")
              ),
              TextButton(
                onPressed: () {
                  newFavorite.remove(userToAdd.uid);
                  FirebaseHelper().updateUser(moi.uid, {'favoris':newFavorite});
                  Navigator.pop(context);
                },
                child: Text("Oui")
              ),
            ],
          );
          }
          else {
          return AlertDialog(
            title:Text("Ajouter un favori"),
            content:
                Text("Souhaitez-vous ajouter ${userToAdd.fullName} à vos favoris ?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Non")
              ),
              TextButton(
                onPressed: () {
                  newFavorite.add(userToAdd.uid);
                  FirebaseHelper().updateUser(moi.uid, {'favoris':newFavorite});
                  Navigator.pop(context);
                },
                child: Text("Oui")
              ),
            ],
          );
          }
        }
      );
    }

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseHelper().cloud_users.snapshots(),
        builder: (context,snap){
          if(snap.data == null){
            return Center(child: Text("Aucun utilisateur"),);
          }else {
            List documents = snap.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
                itemBuilder: (context,index){
                  MyUser users = MyUser.bdd(documents[index]);
                  if(users.uid != moi.uid && (widget.show == "all" || (widget.show == 'fav' && moi.favoris.contains(users.uid)))) {
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
                        trailing:
                          IconButton(
                            icon: Icon(Icons.favorite, color: moi.favoris.contains(users.uid) ? Colors.amber : Colors.grey),
                            onPressed: () {
                              addFavorite(users);
                            },
                          ),
                        onTap: () {
                          infoUser(users);
                        }
                      ),
                    );
                  }
                  else {
                    return SizedBox.shrink();
                  }
                }
            );
          }
        }
    );
  }
}