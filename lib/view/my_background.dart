
import 'package:firstbd233/controller/my_custompath.dart';
import 'package:flutter/material.dart';

class MyBackGroundPage extends StatefulWidget {
  const MyBackGroundPage({super.key});

  @override
  State<MyBackGroundPage> createState() => _MyBackGroundPageState();
}

class _MyBackGroundPageState extends State<MyBackGroundPage> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyCustomPath(),
      child: Container(
        //color: Colors.purple,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("http://www.letribunaldunet.fr/wp-content/uploads/2020/02/voiture-de-luxe.jpg"),
            fit: BoxFit.fill

          ),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
