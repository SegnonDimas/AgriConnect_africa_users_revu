import 'package:agribenin/Page/acceuil.dart';
import 'package:agribenin/authentification/inscription.dart';
import 'package:agribenin/authentification/motsDePasseOublie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/cons.dart';
import '../widget/champTemplate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pays {
  String nomPays;
  String imgpath;
  String indicateur;

  Pays({
    required this.nomPays,
    required this.imgpath,
    required this.indicateur,
  });
}

class Connexion extends StatefulWidget {
  final Function? visible;
  const Connexion({
    super.key,
    this.visible});

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _transform;
  bool inlogin = false;
  bool search = false;

  late TextEditingController _numeroController;
  late ComponentTextFormField _passwordController;

  List<Pays> pays = [
    Pays(nomPays: "Bénin", imgpath: 'images/benin.png', indicateur: '+229'),
    Pays(
        nomPays: "Burkina Faso",
        imgpath: 'images/burkina.png',
        indicateur: '+226'),
    Pays(
        nomPays: "Côte d'Ivoire",
        imgpath: 'images/cotedivore.png',
        indicateur: '+225'),
    Pays(nomPays: "Mali", imgpath: 'images/mali.png', indicateur: '+223'),
    Pays(nomPays: "Niger", imgpath: 'images/niger.png', indicateur: '+227'),
    Pays(nomPays: "Togo", imgpath: 'images/togo.png', indicateur: '+228'),
  ];

  String paysValue = 'Bénin';
  String indicateurPays = '+229';
  String imgPays = 'images/benin.png';

  //User _user;
  var _user;
  //late Map<String, dynamic> _userData;

  Map<String, dynamic> _userData = {
  'prenom': 'PrenomDeTest',
  'nom': 'NomDeTest',
  'commune': 'communeDeTest',
  'numero': '91330039',
  'secteur': ['cacao', 'riz'],
  'langue': 'francais',
  'passe': 'passWorld',
  'pays': 'paysValue' /* Ajoutez d'autres champs si nécessaire */
  };

  //String? get userId => null;

  Future<void> _loadUserData() async {
    _user = FirebaseAuth.instance.currentUser;

    if (_user != null) {
      String userId = _user.uid;

      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance
          .collection('utilisateurs')
          .doc(userId)
          .get();

      // Récupérez les données spécifiques de l'utilisateur
      _userData = userSnapshot.data() ?? {};

      // Mettez à jour l'état pour déclencher un réaffichage
      if (mounted) {
        setState(() {});
      }
    }
    }
  void _initializeUserData() {
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


  @override
  void initState() {
    super.initState();
    _loadUserData();
    _initializeUserData();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),


    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    )..addListener(() {
        setState(() {});
      });

    _transform = Tween<double>(begin: 2, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    );

    _controller.forward();
    super.initState();

    _numeroController = TextEditingController();
    _passwordController = ComponentTextFormField(
      icon: Icons.password_outlined,
      placehoder: '*********',
      isPassword: true,
      isEmail: false,
    );

    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _controller.dispose();
    _numeroController.dispose();
    super.dispose();
  }

  // Charger les informations de connexion stockées

  _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (savedEmail != null && savedPassword != null) {
      // Si des informations de connexion sont stockées, les utiliser pour se connecter automatiquement
      _numeroController.text = savedEmail;
      _passwordController.valu.text = savedPassword;
      login();
    }
  }

/// corps de l'app
  @override
  Widget build(BuildContext context) {
    // Vérifier si l'utilisateur est déjà connecté
    if (FirebaseAuth.instance.currentUser != null) {
      // Naviguer directement vers la page suivante
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => const Pages()), (route) => false);
      return Container(); // Ou tout autre widget que vous souhaitez afficher (ou rien)
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: /*ScrollConfiguration(
        behavior: MyBehavior(),
        child: */SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.centerRight,
                  stops: [0.1, 0.5, 0.9],
                  colors: [
                    Colors.greenAccent,
                    const Color.fromARGB(255, 104, 255, 109).withOpacity(.5),
                    Colors.white,
                  ],
                ),
              ),
              child: Container(
                    width: size.width * .9,
                    height: size.width * 1.25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          blurRadius: 90,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 100,
                          child: Image.asset(
                            "images/agri.png",
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Container(
                          height: 50,
                          width: size.width / 1.22,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(right: size.width / 30),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            style: GoogleFonts.kadwa(
                              fontSize: 14,
                              color: Colors.black.withOpacity(.8),
                            ),
                            keyboardType: TextInputType.phone,
                            controller: _numeroController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: InkWell(
                                onTap: () {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      content: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .6,
                                        height: 400,
                                        child: ListView.builder(
                                          itemCount: pays.length,
                                          itemBuilder: (context, index) =>
                                              ListTile(
                                            onTap: () {
                                              setState(() {
                                                paysValue = pays[index].nomPays;
                                                indicateurPays =
                                                    pays[index].indicateur;
                                                imgPays = pays[index].imgpath;
                                              });
                                              Navigator.pop(context);
                                            },
                                            leading: CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  pays[index].imgpath),
                                            ),
                                            title: Text(pays[index].nomPays),
                                            subtitle:
                                                Text(pays[index].indicateur),
                                            dense: true,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ).then((returnVal) {});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: SizedBox(
                                    width: 70,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(imgPays),
                                            ),
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          indicateurPays,
                                          style: GoogleFonts.kadwa(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              hintMaxLines: 1,
                              //hintText: ' XXXXXXXX',
                              hintStyle: GoogleFonts.kadwa(
                                fontSize: 14,
                                color: Colors.black.withOpacity(.5),
                              ),
                            ),
                          ),
                        ),
                        _passwordController.textformfield(context),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            component2(
                              'Connexion',
                              2.6,
                              () {
                                if (_numeroController.text.isEmpty) {
                                  _showSnackBar("Votre numéro s'il vous plaît");
                                } else if (_passwordController.valu.text.isEmpty) {
                                  _showSnackBar(
                                      "Veillez entrer votre mot de passe");
                                }
                                else {
                                  login();
                                }
                              },
                            ),
                            //SizedBox(width: size.width / 25),

                          ],
                        ),
                        const SizedBox(),
                        RichText(
                          text: TextSpan(
                            text: 'Créer un compte',
                            style: GoogleFonts.kadwa(
                              color: PRIMARY_COLOR,
                              fontSize: 15,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  //widget.visible!();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    //MaterialPageRoute(builder: (context) => const ConnctInscription()),
                                    MaterialPageRoute(builder: (context) => const Inscription()),
                                        (route) => false,
                                  );
                                });
                              },
                          ),
                        ),
                        const SizedBox(),
                      ],
                    ),
                  ),
                //),
              //),
            ),
          ),
        //),
      ),
    );
  }

  Widget component2(String string, double width, VoidCallback voidCallback) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: voidCallback,
      child: Container(
        height: size.width / 8,
        width: size.width / width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: const [0.1, 0.5],
            colors: [PRIMARY_COLOR, PRIMARY_COLOR.withOpacity(.5)],
          ),
        ),
        child: Text(
          string,
          style: GoogleFonts.kadwa(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<User?> login() async {

      try {
        UserCredential credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: paysValue == 'Bénin'?
          "${_numeroController.value.text}00229@gmail.com"
              : paysValue == 'Burkina faso'?
          "${_numeroController.value.text}00226@gmail.com"
              : paysValue == 'Côte d\'ivoire'?
          "${_numeroController.value.text}00225@gmail.com"
              : paysValue == 'Mali'?
          "${_numeroController.value.text}00223@gmail.com"
              : paysValue == 'Niger'?
          "${_numeroController.value.text}00227@gmail.com"
              : paysValue == 'Togo'?
          "${_numeroController.value.text}00228@gmail.com"
              :
          "inconnu${_numeroController.value.text}@gmail.com"
              ,
          password: _passwordController.valu.text,
        );

        _showSnackBar("Utilisateur connecté avec succès");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Pages()),
          (route) => false,
        );

        _saveCredentials();

        return credential.user;
      } on FirebaseAuthException catch (e) {
        print(e.code);

        if(e.code == "network-request-failed"){
          _showSnackBar("Veuillez verifier votre connexion!");
        }else if(e.code == 'wrong-password'){
          _showSnackBar("Mot de passe incorrect");

        }else if(e.code == "invalid-credential"){
          _showSnackBar("Numéro invalide ou mot de passe incorrect");
        }
      }

  }

  _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _numeroController.value.text);
    prefs.setString('password', _passwordController.valu.text);
    prefs.setBool("ISCONNECTED", true);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: PRIMARY_COLOR,
        content: Text(message),
      ),
    );
  }
}

/*class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}*/
