import 'package:agribenin/Page/screen/app_sizes.dart';
import 'package:agribenin/authentification/inscriptionConnexion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'acceuil.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {




  checkIfConnected()async{

    await Future.delayed(const Duration(seconds: 5));
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool value = prefs.getBool("ISCONNECTED")?? false;

    print(value);


    if(value){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Pages()));
    }else{
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ConnctInscription()));
    }

  }



  @override
  void initState() {
    super.initState();
    checkIfConnected();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo de l'entreprise
              Container(
                alignment: Alignment.topCenter,
                height: appHeightSize(context)*0.5,
                width: appWidthSize(context)*0.85,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage("images/agri.png"), fit: BoxFit.cover),
        //                borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
        
              // Symbole de chargement
              //const CircularProgressIndicator(),
              Container(
                  alignment: Alignment.topCenter,
                  height: appHeightSize(context)*0.4,
                  width: appWidthSize(context)*0.85,
                  child: Lottie.asset('animations/lotties/chargement.json')
              )
            ],
          ),
        ),
      )
    );
  }
}
