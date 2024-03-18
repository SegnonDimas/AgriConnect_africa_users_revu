
import 'package:agribenin/Page/WelcomePage.dart';
import 'package:agribenin/Page/app_colors.dart';
import 'package:agribenin/authentification/connexion.dart';
import 'package:agribenin/authentification/inscriptionConnexion.dart';
import 'package:agribenin/authentification/modification.dart';
import 'package:agribenin/constants/cons.dart';
import 'package:agribenin/widget/connexion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Compte extends StatefulWidget {
  const Compte({Key? key}) : super(key: key);

  @override
  State<Compte> createState() => _CompteState();
}

class _CompteState extends State<Compte> {
  late User? _user;
  late Map<String, dynamic> _userData;

  //fonction de normalisation qui convertie les caractères accentué en leur équivalents
  String _normalizeString(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[àáâãäå]'), 'a')
        .replaceAll(RegExp(r'[èéêë]'), 'e')
        .replaceAll(RegExp(r'[ìíîï]'), 'i')
        .replaceAll(RegExp(r'[òóôõö]'), 'o')
        .replaceAll(RegExp(r'[ùúûü]'), 'u')
        .replaceAll(RegExp(r'[ýÿ]'), 'y');
  }

  @override
  void initState() {
    super.initState();
    _initializeUserData();
    _loadUserData();
  }

  void _initializeUserData() {
    // Remplacez la ligne suivante par votre logique pour récupérer les données de l'utilisateur
    _userData = {
      'prenom': 'PrenomDeTest',
      'nom': 'NomDeTest',
      'commune': 'communeDeTest',
      'numero': '91330039',
      'secteur': ['cacao', 'riz'],
      'langue': 'francais',
      'passe': 'passWorld',
      'pays': 'paysValue' /* Ajoutez d'autres champs si nécessaire */
    };
  }

  Future<void> _loadUserData() async {
    _user = FirebaseAuth.instance.currentUser;

    if (_user != null) {
      String userId = _user!.uid;

      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('utilisateurs')
              .doc(userId)
              .get();

      // Récupérez les données spécifiques de l'utilisateur
      _userData = userSnapshot.data() ?? {};

      // Print the user data
      print("User Data: $_userData");

      // Mettez à jour l'état pour déclencher un réaffichage
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: PRIMARY_COLOR,
        title: Text(
          'Compte',
          style: GoogleFonts.kadwa(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            width: size.width,
            //height: size.height*0.3,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  //color: Colors.red,
                  alignment: Alignment.center,
                  width: size.width,
                  height: size.height*0.3,
                  child: Image.asset(
                    'images/agri.png',
                    fit: BoxFit.cover,
                    width: size.width,
                  ),
                ),
                Positioned(
                  //bottom: 0,
                  //left: 10,
                  right: size.width*0.35,
                  left: size.width*0.35,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(60),
                          ),
                          boxShadow: const [
                            BoxShadow(color: PRIMARY_COLOR, spreadRadius: 1.5)
                          ],
                          image: const DecorationImage(
                            image: AssetImage("images/logo.jpg"),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              //constraints: BoxConstraints(maxWidth: size.width - 200),
              padding: const EdgeInsets.only(bottom: 15, left: 10),
              child: Text(
                "${_userData['nom']} ${_userData['prenom']}",
                style: GoogleFonts.kadwa(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: PRIMARY_COLOR
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          //Divider(),
      ListTile(
            leading: const CircleAvatar(
              backgroundColor: PRIMARY_COLOR,
              child: Icon(
                Icons.villa_outlined,
                color: Colors.white,
              ),
            ),
            title: Text(
              'Pays',
              style: GoogleFonts.kadwa(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              _userData['pays'] ?? '',
              style: GoogleFonts.kadwa(
                fontSize: 13,
              ),
            ),
            dense: true,
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: PRIMARY_COLOR,
              child: Icon(
                Icons.location_city,
                color: Colors.white,
              ),
            ),
            title: Text(
              'Commune',
              style: GoogleFonts.kadwa(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              _userData['commune'] ?? '',
              style: GoogleFonts.kadwa(
                fontSize: 13,
              ),
            ),
            dense: true,
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: PRIMARY_COLOR,
              child: Icon(
                Icons.call,
                color: Colors.white,
              ),
            ),
            title: Text(
              'Numero',
              style: GoogleFonts.kadwa(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              _userData['numero'] ?? '',
              style: GoogleFonts.kadwa(
                fontSize: 13,
              ),
            ),
            dense: true,
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: PRIMARY_COLOR,
              child: Icon(
                Icons.language,
                color: Colors.white,
              ),
            ),
            title: Text(
              'Langue',
              style: GoogleFonts.kadwa(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              _userData['langue'] ?? '',
              style: GoogleFonts.kadwa(
                fontSize: 13,
              ),
            ),
            dense: true,
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: PRIMARY_COLOR,
              child: Icon(
                Icons.swap_vert_circle_outlined,
                color: Colors.white,
              ),
            ),
            title: Text(
              'Sous secteur(s)',
              style: GoogleFonts.kadwa(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              _userData['secteur'] != null
                  ? (_userData['secteur'] as List).join(', ')
                  : '',
              style: GoogleFonts.kadwa(
                fontSize: 13,
              ),
            ),
            dense: true,
          ),
          const Divider(),
          ListTile(
            onTap: () async {
              //FirebaseAuth.instance.currentUser!.uid;
              await FirebaseAuth.instance.signOut().then((value) async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool(ISCONNECTED, false);
                if(await prefs.setBool(ISCONNECTED, false)){
                  prefs.clear();
                }else{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool(ISCONNECTED, true);
                }
              });
              // Redirigez l'utilisateur vers l'écran de connexion ou d'accueil, selon votre logique
              // Par exemple :
              Navigator.pushAndRemoveUntil(
                context,
                //MaterialPageRoute(builder: (context) => const ConnctInscription()),
                MaterialPageRoute(builder: (context) => const WelcomePage()),
                (route) => false,
              );
            },
            leading: CircleAvatar(
              backgroundColor: redColor,
              child: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
            title: Text(
              'Se déconnecter',
              style: GoogleFonts.kadwa(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            dense: true,
          ),
        ],
      ),
    );
  }
}

