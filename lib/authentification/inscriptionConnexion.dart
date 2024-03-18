import 'package:agribenin/constants/cons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'connexion.dart';
import 'inscription.dart';

///nouveau
class ConnctInscription extends StatefulWidget {
  const ConnctInscription({super.key});

  @override
  State<ConnctInscription> createState() => _ConnctInscriptionState();
}

class _ConnctInscriptionState extends State<ConnctInscription> {

  User? _user;
  Map<String, dynamic>? _userData;

  String? get userId => null;

  bool _isDataLoaded = false; // Variable pour suivre si les données ont été chargées

  Future<void> _loadUserData() async {
    _user = FirebaseAuth.instance.currentUser;

    if (_user != null) {
      String userId = _user!.uid;
      try{
      // Définir la persistance de session après la première connexion réussie et conserve les informations d'inscription et de connexion de l'utilisateur
      await FirebaseAuth.instance.setPersistence(Persistence.SESSION);

      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance
          .collection('utilisateurs')
          .doc(userId)
          .get();

      // Récupération des données spécifiques de l'utilisateur
      _userData = userSnapshot.data() ?? {};

      // Mise à jour de la variable _isDataLoaded pour indiquer que les données ont été chargées
      _isDataLoaded = true;

      // Mise à jour l'état pour déclencher un réaffichage
      if (mounted) {
        setState(() {});
      }
      }catch(e){
        // Imprimer l'erreur en cas d'échec
        //if (kDebugMode) {
          print("Erreur lors du chargement des données utilisateur: $e");
        //}
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  bool visible = true;
  toogle() {
    setState(() {
      visible = !visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Connexion());
  }
}