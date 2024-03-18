import 'package:agribenin/Page/acceuil.dart';
import 'package:agribenin/Page/WelcomePage.dart';
import 'package:agribenin/Page/chat/discussionPage.dart';
import 'package:agribenin/Page/messagerie.dart';
import 'package:agribenin/constants/cons.dart';
import 'package:agribenin/tests/flutterSoundLite.dart';
import 'package:agribenin/tests/test1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'authentification/inscriptionConnexion.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

const kWebRecaptchaSiteKey = '6Le_wXEpAAAAAPWJsNsdcvpGLJw_4SLe2eM2vWp';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterDownloader.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance
      // Your personal reCaptcha public key goes here: _
      .activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
    webProvider: ReCaptchaV3Provider(kWebRecaptchaSiteKey),
  );
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  /*await FlutterDownloader.initialize(
    debug: true, // Mettez à true pour activer les journaux de débogage
  );*/
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgriConnect Africa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: PRIMARY_COLOR/*Colors.indigoAccent*/),
        useMaterial3: true,
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontFamily: 'MontserratSemiBold'),
            displayMedium: TextStyle(fontFamily: 'MontserratSemiBold'),
            displaySmall: TextStyle(fontFamily: 'MontserratSemiBold'),
            headlineLarge: TextStyle(fontFamily: 'MontserratSemiBold'),
            headlineMedium: TextStyle(fontFamily: 'MontserratSemiBold'),
            headlineSmall: TextStyle(fontFamily: 'MontserratSemiBold'),
            titleLarge: TextStyle(fontFamily: 'MontserratSemiBold'),
            titleMedium: TextStyle(fontFamily: 'MontserratSemiBold'),
            titleSmall: TextStyle(fontFamily: 'MontserratSemiBold'),
            bodyLarge: TextStyle(fontFamily: 'MontserratSemiBold'),
            bodyMedium: TextStyle(fontFamily: 'MontserratSemiBold'),
            bodySmall: TextStyle(fontFamily: 'MontserratSemiBold'),
            labelLarge: TextStyle(fontFamily: 'MontserratSemiBold'),
            labelMedium: TextStyle(fontFamily: 'MontserratSemiBold'),
            labelSmall: TextStyle(fontFamily: 'MontserratSemiBold'),
          )
      ),
      //home: const DiscussionPage(),
      home: const WelcomePage(),
      //home: const StockView(),
    );
  }
}


/// RESTE À FAIRE
/*
    - Organisation des publications par pays (un autre pays ne peut pas voir les publications d'un autre
    - organisation des publications par langue et par secteurs (même principes que pour les pays)
    - récupération de l'image de profil
    - date de début, date de fin à implémenter
    - ~affichage des image (à régler)~
    - la connexion en une fois
*/

