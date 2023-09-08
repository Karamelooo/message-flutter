import 'dart:io';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firstbd233/constante/constant.dart';
import 'package:firstbd233/controller/firebase_helper.dart';
import 'package:firstbd233/controller/my_animation.dart';
import 'package:firstbd233/controller/permission_photo.dart';
import 'package:firstbd233/firebase_options.dart';
import 'package:firstbd233/view/my_background.dart';
import 'package:firstbd233/view/my_dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  PermissionPhoto().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //variable
  PageController page = PageController();
  int position = 0;
  bool eyeOpen = true;
  TextEditingController nom = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();


  //méthode

  popUpError(){
    showDialog(
      context: context,
      builder: (context) {
        if(Platform.isIOS){
          return CupertinoAlertDialog(
            title: Text("Erreur"),
            content: Text("Il y a une erreur de saisie"),
            actions: [
              TextButton
              (onPressed: () {
                Navigator.pop(context);
              },
               child: Text('Valider')
               )
            ]
          );
        }
        else {
          return AlertDialog(
            title: Text("Erreur"),
            content: Text("Il y a une erreur de saisie"),
            actions: [
              TextButton
              (onPressed: () {
                Navigator.pop(context);
              },
               child: Text('Valider')
               )
            ]
          );
        }
      }
    );
  }

  SnackBar barAction(){
    return SnackBar(
      backgroundColor: Colors.purple,
      duration: const Duration(minutes: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))

        ),


        content: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              SizedBox(height: 10,),
              TextField(
                controller: prenom,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.person),

                    hintText: "Entrer votre prénom",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),

              ),
              SizedBox(height: 10,),
              TextField(
                controller: nom,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.person),
                    hintText: "Entrer votre nom",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),

              ),
              SizedBox(height: 10,),
              TextField(
                controller: email,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.mail),

                    hintText: "Entrer votre adresse mail",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),

              ),
              SizedBox(height: 10,),
              TextField(
                controller: password,
                obscureText: eyeOpen,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          eyeOpen = !eyeOpen;
                        });

                      },
                      icon: Icon(Icons.remove_red_eye),
                    ),
                    hintText: "Entrer votre mot de passe",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),

              ),
              SizedBox(height: 10,),
              ElevatedButton(
                  onPressed: (){
                    ScaffoldMessenger.of(context).clearSnackBars();
                    //enregistrer dans la base de donnée
                    FirebaseHelper().inscription(nom.text, prenom.text, email.text, password.text)
                    .then((value) {
                      setState(() {
                        moi = value;
                      });
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return MyDashBoard();
                        }
                      ));
                    })
                    .catchError((onError) {
                      popUpError();
                    });
                  },
                  child: Text("Enregistrement")
              ),

            ],
          ),
        )
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
      ),
      extendBodyBehindAppBar: true,
      body: Stack(

          children: <Widget>[
            MyBackGroundPage(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height *0.55,
                    child: PageView(
                      onPageChanged: (number){
                        setState(() {
                          position = number;
                        });

                      },
                      controller: page,
                      children: [
                        bodyPage(),
                      ],
                    ),
                  ),
                  (position == 3)?Container():DotsIndicator(

                    position: position,
                      dotsCount: 4
                  )
                ],
              ),
            ),
           

           ]
    )

    );
  }


  Widget bodyPage(){
    return Column(
      children: [
        SizedBox(height: 10,),
        MyAnimationWidget(
          duree: 1,
          child: TextField(
            controller:email,
            decoration: InputDecoration(
              hintText: "Entrer votre mail",
              prefixIcon: Icon(Icons.mail),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15)
              )
            ),
          ),
        ),
        SizedBox(height: 10,),
        MyAnimationWidget(
          duree: 2,
          child: TextField(
            obscureText: eyeOpen,
            controller:password,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      eyeOpen = !eyeOpen;
                    });

                },
                  icon: Icon(Icons.remove_red_eye),
                ),
                hintText: "Entrer votre mot de passe",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                )
            ),

          ),
        ),
        SizedBox(height: 10,),
        MyAnimationWidget(
          duree: 3,
          child: ElevatedButton(
              onPressed: (){
                FirebaseHelper().connexion(email.text, password.text)
                .then((value) {
                  setState(() {
                    moi = value;
                  });
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return MyDashBoard();
                    }
                  ));
                })
                .catchError((onError){
                  popUpError();
                });
              },
              child: Text("Connexion")
          ),
        ),
        SizedBox(height: 10,),
        MyAnimationWidget(
          duree: 4,
          child: TextButton(
              onPressed: (){
                ScaffoldMessenger.of(context).showSnackBar(barAction());
              },
              child: Text("Inscription")
          ),
        )
      ],
    );
  }


}
