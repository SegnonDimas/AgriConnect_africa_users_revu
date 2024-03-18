/*
import 'package:agribenin/authentification/inscription.dart';
import 'package:agribenin/authentification/motsDePasseOublie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Page/acceuil.dart';
import '../constants/cons.dart';
import '../widget/champTemplate.dart';

class Pays {
  String nomPays;
  String imgpath;
  String indicateur;
  Pays(
      {required this.nomPays, required this.imgpath, required this.indicateur});
}

class Connexion extends StatefulWidget {
  final Function? visible;
  const Connexion({super.key, */
/*required*//*
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
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextEditingController _numeroController = TextEditingController();
  ComponentTextFormField _passwordController = ComponentTextFormField(
      icon: Icons.password_outlined,
      placehoder: '*********',
      isPassword: true,
      isEmail: false);

  List<Pays> pays = [
    Pays(nomPays: "Bénin", imgpath: 'images/benin.png', indicateur: '+229'),
    Pays(
        nomPays: "Burkina faso",
        imgpath: 'images/burkina.png',
        indicateur: '+226'),
    Pays(
        nomPays: "Côte d'ivoire",
        imgpath: 'images/cotedivore.png',
        indicateur: '+225'),
    Pays(nomPays: "Mali", imgpath: 'images/mali.png', indicateur: '+223'),
    Pays(nomPays: "Niger", imgpath: 'images/niger.png', indicateur: '+227'),
    Pays(nomPays: "Togo", imgpath: 'images/togo.png', indicateur: '+228'),
  ];

  String paysValue = 'Bénin';
  String indicateurPays = '+229';
  String imgPays = 'images/benin.png';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.centerRight,
                      stops: const [
                    0.1,
                    0.5,
                    0.9
                  ],
                      colors: [
                    Colors.greenAccent,
                    const Color.fromARGB(255, 104, 255, 109).withOpacity(.5),
                    Colors.white
                  ])),
              child: Opacity(
                opacity: _opacity.value,
                child: Transform.scale(
                  scale: _transform.value,
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
                        Container(
                            width: 200,
                            height: 100,
                            child: Image.asset(
                              "images/agri.png",
                              fit: BoxFit.fitWidth,
                            )),
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
                                color: Colors.black.withOpacity(.8)),
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
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .6,
                                        height: 200,
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
                                child: Container(
                                  width: 70,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(imgPays)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        indicateurPays,
                                        style: GoogleFonts.kadwa(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              hintMaxLines: 1,
                              hintText: ' XXXXXXXX',
                              hintStyle: GoogleFonts.kadwa(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(.5)),
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
                                  _showSnackBar("Votre numero s'il vous plait");
                                } else if (_passwordController.val.length < 8 ||
                                    _passwordController.val.isEmpty) {
                                  _showSnackBar(
                                      "Mots de passe doit depassé 8 caractère");
                                } else {
                                  login();
                                }
                              },
                            ),
                            SizedBox(width: size.width / 25),
                            Container(
                              width: size.width / 2.6,
                              alignment: Alignment.center,
                              child: RichText(
                                text: TextSpan(
                                  text: 'Mots de passe oublié',
                                  style: GoogleFonts.kadwa(
                                      color: PRIMARY_COLOR, fontSize: 15),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MotDePasseOublie(),
                                          ));
                                    },
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(),
                        RichText(
                          text: TextSpan(
                            text: 'Créer un compte',
                            style: GoogleFonts.kadwa(
                              color: PRIMARY_COLOR,
                              fontSize: 15,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                //widget.visible!();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  //MaterialPageRoute(builder: (context) => const ConnctInscription()),
                                  MaterialPageRoute(builder: (context) => const Inscription()),
                                      (route) => false,
                                );
                              },
                          ),
                        ),
                        SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
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
            borderRadius: BorderRadius.all(Radius.circular(25)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.1, 0.5],
                colors: [PRIMARY_COLOR, PRIMARY_COLOR.withOpacity(.5)])),
        child: Text(
          string,
          style: GoogleFonts.kadwa(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  */
/* signin() {
    setState(() {
      inlogin = true;
      AuthService().signInWithGoogle();
    });
  }



  Future<User?> login() async {
    try {
      UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "${_numeroController.value.text}@agriconnect.africa", // Adresse e-mail de l'utilisateur
        password:
            _passwordController.valu.text, // Mot de passe de l'utilisateur
      );

      _showSnackBar("Connexion réussie");
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Pages()), (route) => false);
      return credential.user;
    } catch (e) {
      print("Une erreur s'est produite : $e");
      //_showSnackBar("Une erreur s'est produite lors de la connection::: $e");
      _showSnackBar("Numéro de téléphone ou mot de passe incorrect");
      return null;
    }
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

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
*/
