import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class MyMachineLearning extends StatefulWidget {
  const MyMachineLearning({super.key});

  @override
  State<MyMachineLearning> createState() => _MyMachineLearningState();
}

class _MyMachineLearningState extends State<MyMachineLearning> {
  //variable
  TextEditingController message = TextEditingController();
  String langageidentifier = "";
  LanguageIdentifier lang = LanguageIdentifier(confidenceThreshold: 0.6);

  //méthode
  identificationLangage() async {
    langageidentifier = "";
    if(message != null){
      String mess = await lang.identifyLanguage(message.text);
      setState(() {
        langageidentifier = "la langue identifié est $mess";
      });

    }


  }
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        TextField(
          controller: message,
        ),
        ElevatedButton(
            onPressed: identificationLangage,
            child: Text("selection")
        ),
        Text(langageidentifier)
      ],
    );
  }
}