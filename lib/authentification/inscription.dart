import 'package:agribenin/Page/acceuil.dart';
import 'package:agribenin/Page/screen/app_sizes.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../Page/politiqueEtConfidentiatite.dart';
import '../constants/cons.dart';
import '../widget/champTemplate.dart';
import 'connexion.dart';

//Classe pour le modèle des secteurs d'activités
class SecteurActivite {
  String name;
  bool isClick = false;
  String imgPath;
  SecteurActivite({required this.name, required this.imgPath});
}

///Page d'inscription
class Inscription extends StatefulWidget {
  //final Function? visible;

  const Inscription({super.key,
    /*this.visible*/});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription>

  with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _opacity;
  Animation<double>? _transform;

  //langue de l'utilisateur
  String langue = '';

  bool isClickSecteur = true;

  // Bénin
  bool yoruba = false;
  bool fon = false;
  bool adja = true;
  bool bariba = false;
  bool ottamari = false;

  // Cote d'ivoire
  bool dioula = false;
  bool bete = false;
  bool baoule = false;
  bool senoufo = false;

  // Mali
  //bool dioula = false;
  bool bambara = false;
  bool peul = false;

  // Togo
  bool milan = false;
  bool ewe = false;

  // Niger
  bool zerma = false;
  bool haoussa = false;
//?
  // Burkina
  bool moore = false;

  //Liste des différents secteurs
  List<SecteurActivite> secteurVal = [
    SecteurActivite(name: 'Elevage', imgPath: "images/elevage.jpg"),
    SecteurActivite(name: 'Pisciculture', imgPath: "images/pisicuture.jpg"),
    SecteurActivite(name: 'Production Végétale', imgPath: "images/vegetal.jpg"),
    SecteurActivite(name: 'Transformation', imgPath: "images/tranformation.jpg"),
  ];
  final List<String> _secteurController = [];
  // Politique de confidentialité
  bool isClick = false;
  // Image picker
  late File photopath;
  String photoname = "assets/icon.png";
  String photodata = "assets/icon.png";
  ImagePicker imagePicker = ImagePicker();

  //pour la récupération d'une image dans dans le téléphone de l'utilisateur
  Future<void> getImage() async {
    var getimage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (getimage != null) {
      setState(() {
        photopath = File(getimage.path);
        photoname = getimage.path.split('/').last;
        photodata = base64Encode(photopath!.readAsBytesSync());
      });
    }
  }

  // Fonction qui montre que l'utilisateurs a faire un choix de son secteur
  bool isSelect() {
    for (var i = 0; i < secteurVal.length; i++) {
      if (secteurVal[i].isClick) {
        return true;
      }
    }
    return false;
  }

  // Password
  bool isVisible = true;
  bool isVisibleConfirm = true;

  // Ajouter dans le secteurs
  void addSecteur(String value) {
    bool isContain = false;
    for (var i = 0; i < _secteurController.length; i++) {
      if (_secteurController[i] == value) {
        isContain = true;
      }
    }
    if (!isContain) {
      _secteurController.add(value);
    }
  }

  // Enlever du secteur
  void removeSecteur(String value) {
    _secteurController.remove(value);
  }

  ///initState
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.ease,
      ),
    )..addListener(() {
        setState(() {});
      });

    _transform = Tween<double>(begin: 2, end: 1).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    );

    _controller!.forward();
    super.initState();
  } /// fin de initState

  ///dispose
  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
  ///fin dispose

  //nom
  final ComponentTextFormField _nomController = ComponentTextFormField(
      icon: Icons.account_circle_outlined,
      placehoder: 'Nom....',
      isPassword: false,
      isEmail: false);
  //prenom
  final ComponentTextFormField _prenomController = ComponentTextFormField(
      icon: Icons.account_circle_outlined,
      placehoder: 'Prenom...',
      isPassword: false,
      isEmail: false);
  //commune
  final ComponentTextFormField _communeController = ComponentTextFormField(
      icon: Icons.location_city,
      placehoder: 'Abomey Calavi',
      isPassword: false,
      isEmail: false);
  //mot de passe
  final _passwordController = TextEditingController();
  //confirmation de mot de passe
  final _passwordConfirmController = TextEditingController();
  final ComponentTextFormField _passwordConfirmeController = ComponentTextFormField(
      icon: Icons.lock,
      placehoder: 'confirme mot de passe',
      isPassword: true,
      isEmail: false);
  //numéro de téléphone
  final TextEditingController _numeroController = TextEditingController();

  //Claener : efface les champs de saisie
  void cleanerMe() {
    _nomController.cleaner();
    _prenomController.cleaner();
    _passwordConfirmeController.cleaner();
  }

  //initialiser la langue
  void initLangue() {
    yoruba = false;
    fon = false;
    adja = false;
    ottamari = false;
    bariba = false;
    //
    baoule = false;
    bete = false;
    dioula = false;
    senoufo = false;
    //
    bambara = false;
    peul = false;
    //
    milan = false;
    ewe = false;
    //
    dioula = false;
    moore = false;
    haoussa = false;
    zerma = false;
  }

  void choixDefaut(String val) {
    if (val == "Bénin") {
      initLangue();
      adja = true;
      langue = 'ADJA';
    } else if (val == "Burkina faso") {
      initLangue();
      dioula = true;
      langue = 'DIOULA';
    } else if (val == "Côte d'ivoire") {
      initLangue();
      baoule = true;
      langue = 'BAOULE';
    } else if (val == "Mali") {
      initLangue();
      bambara = true;
      langue = 'BAMBARA';
    } else if (val == "Niger") {
      initLangue();
      dioula = true;
      langue = 'DIOULA';
    } else if (val == "Togo") {
      initLangue();
      ewe = true;
      langue = 'EWE';
    }
  }

  // liste des pays
  List<Pays> pays = [
    Pays(
        nomPays: "Bénin",
        imgpath: 'images/benin.png',
        indicateur: '+229'),
    Pays(
        nomPays: "Burkina faso",
        imgpath: 'images/burkina.png',
        indicateur: '+226'),
    Pays(
        nomPays: "Côte d'ivoire",
        imgpath: 'images/cotedivore.png',
        indicateur: '+225'),
    Pays(
        nomPays: "Mali",
        imgpath: 'images/mali.png',
        indicateur: '+223'),
    Pays(
        nomPays: "Niger",
        imgpath: 'images/niger.png',
        indicateur: '+227'),
    Pays(
        nomPays: "Togo",
        imgpath: 'images/togo.png',
        indicateur: '+228'),
  ];

  String paysValue = 'Bénin';
  String indicateurPays = '+229';
  String imgPays = 'images/benin.png';
  String? imageProfil = 'images/logo.jpg';

  AudioPlayer audioPlayer = AudioPlayer();


  ///widget build
  @override
  Widget build(BuildContext context) {
    ///les variables
    Size size = MediaQuery.of(context).size;

    ///la page
    return Scaffold(
      extendBodyBehindAppBar: true,

      ///l'appBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      ///le corps de la page
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
                      stops: const [
                    0.1,
                    0.5,
                    0.9
                  ],
                      colors: [
                    const Color.fromARGB(255, 0, 206, 92),
                    const Color.fromARGB(255, 197, 255, 104).withOpacity(.5),
                    Colors.white
                  ])),
              child: /*Opacity(
                opacity: _opacity!.value,
                child: Transform.scale(
                  scale: _transform!.value,
                  child: */Container(
                    width: size.width * .9,
                    height: size.height * .8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color.fromRGBO(0, 0, 0, 1).withOpacity(.1),
                          blurRadius: 90,
                        ),
                      ],
                    ),
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: 200,
                                height: 100,
                                child: Image.asset(
                                  "images/agri.png",
                                  fit: BoxFit.fitWidth,
                                )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 18.0, top: 8, bottom: 8, right: 18),
                          child: Container(
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
                                        content: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *0.6,
                                          height: 400,
                                          child: ListView.builder(
                                            itemCount: pays.length,
                                            itemBuilder: (context, index) =>
                                                ListTile(
                                              onTap: () {
                                                setState(() {
                                                  paysValue =
                                                      pays[index].nomPays;
                                                  indicateurPays =
                                                      pays[index].indicateur;
                                                  imgPays = pays[index].imgpath;
                                                  choixDefaut(
                                                      pays[index].nomPays);
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
                                                image: AssetImage(imgPays)),
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
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                hintMaxLines: 1,
                                hintText: '',
                                hintStyle: GoogleFonts.kadwa(
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(.5)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: Text(
                            "Langues",
                            style: GoogleFonts.kadwa(
                                fontSize: 14,
                                color: Colors.black.withOpacity(.5)),
                          ),
                        ),

                        // Bénin
                        paysValue == 'Bénin'
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18, top: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // ADJA
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          initLangue();
                                          adja = true;
                                          langue = 'ADJA';
                                        });
                                      },
                                      child: Container(
                                        width: size.width * .17,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                            color: adja
                                                ? PRIMARY_COLOR
                                                : Colors.grey.withOpacity(.1)),
                                        padding:
                                            const EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'ADJA',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.kadwa(
                                                  color: adja
                                                      ? Colors.white
                                                      : null,
                                                  fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    //Bariba
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          initLangue();
                                          bariba = true;
                                          langue = 'BARIBA';
                                        });
                                      },
                                      child: Container(
                                        width: size.width * .17,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                            color: bariba
                                                ? PRIMARY_COLOR
                                                : Colors.grey.withOpacity(.1)),
                                        padding:
                                            const EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'BARIBA',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.kadwa(
                                                  color: bariba
                                                      ? Colors.white
                                                      : null,
                                                  fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    //Fon
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          initLangue();
                                          fon = true;
                                          langue = 'FON';
                                        });
                                      },
                                      child: Container(
                                        width: size.width * .17,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                            color: fon
                                                ? PRIMARY_COLOR
                                                : Colors.grey.withOpacity(.1)),
                                        padding:
                                            const EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'FON',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.kadwa(
                                                  color:
                                                      fon ? Colors.white : null,
                                                  fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    //Ottamari
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          initLangue();
                                          ottamari = true;
                                          langue = 'OTAMMARI';
                                        });
                                      },
                                      child: Container(
                                        width: size.width * .17,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                            color: ottamari
                                                ? PRIMARY_COLOR
                                                : Colors.grey.withOpacity(.1)),
                                        padding:
                                            const EdgeInsets.only(left: 6, right: 6),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'OTAMMARI',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.kadwa(
                                                  color: ottamari
                                                      ? Colors.white
                                                      : null,
                                                  fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        paysValue == 'Bénin'
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18, top: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Yoruba
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          initLangue();
                                          yoruba = true;
                                          langue = 'YORUBA';
                                        });
                                      },
                                      child: Container(
                                        width: size.width * .17,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                            color: yoruba
                                                ? PRIMARY_COLOR
                                                : Colors.grey.withOpacity(.1)),
                                        padding:
                                            const EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'YORUBA',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.kadwa(
                                                  color: yoruba
                                                      ? Colors.white
                                                      : null,
                                                  fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * .17,
                                      height: 25,
                                    ),
                                    SizedBox(
                                      width: size.width * .17,
                                      height: 25,
                                    ),
                                    SizedBox(
                                      width: size.width * .17,
                                      height: 25,
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),

                        // Côte d'ivoire
                        paysValue == 'Côte d\'ivoire'
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18, top: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // BAOULE
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          initLangue();
                                          baoule = true;
                                          langue = 'BAOULE';
                                        });
                                      },
                                      child: Container(
                                        width: size.width * .17,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                            color: baoule
                                                ? PRIMARY_COLOR
                                                : Colors.grey.withOpacity(.1)),
                                        padding:
                                            const EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'BAOULE',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.kadwa(
                                                  color: baoule
                                                      ? Colors.white
                                                      : null,
                                                  fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    //BETE
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          initLangue();
                                          bete = true;
                                          langue = 'BETE';
                                        });
                                      },
                                      child: Container(
                                        width: size.width * .17,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                            color: bete
                                                ? PRIMARY_COLOR
                                                : Colors.grey.withOpacity(.1)),
                                        padding:
                                            const EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'BETE',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.kadwa(
                                                  color: bete
                                                      ? Colors.white
                                                      : null,
                                                  fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    //DIOULA
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          initLangue();
                                          dioula = true;
                                          langue = 'DIOULA';
                                        });
                                      },
                                      child: Container(
                                        width: size.width * .17,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                            color: dioula
                                                ? PRIMARY_COLOR
                                                : Colors.grey.withOpacity(.1)),
                                        padding:
                                            const EdgeInsets.only(left: 8, right: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'DIOULA',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.kadwa(
                                                  color: dioula
                                                      ? Colors.white
                                                      : null,
                                                  fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // SENOUFO
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          initLangue();
                                          senoufo = true;
                                          langue = 'SENOUFO';
                                        });
                                      },
                                      child: Container(
                                        width: size.width * .17,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                            color: senoufo
                                                ? PRIMARY_COLOR
                                                : Colors.grey.withOpacity(.1)),
                                        padding:
                                            const EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'SENOUFO',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.kadwa(
                                                  color: senoufo
                                                      ? Colors.white
                                                      : null,
                                                  fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),

                        // Togo
                        paysValue == 'Togo'
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18, top: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Ewe
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          initLangue();
                                          ewe = true;
                                          langue = 'EWE';
                                        });
                                      },
                                      child: Container(
                                        width: size.width * .17,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                            color: ewe
                                                ? PRIMARY_COLOR
                                                : Colors.grey.withOpacity(.1)),
                                        padding:
                                            const EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'EWE',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.kadwa(
                                                  color:
                                                      ewe ? Colors.white : null,
                                                  fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    //Milan
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          initLangue();
                                          milan = true;
                                          langue = 'MILAN';
                                        });
                                      },
                                      child: Container(
                                        width: size.width * .17,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                            color: milan
                                                ? PRIMARY_COLOR
                                                : Colors.grey.withOpacity(.1)),
                                        padding:
                                            const EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'MILAN',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.kadwa(
                                                  color: milan
                                                      ? Colors.white
                                                      : null,
                                                  fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * .17,
                                      height: 25,
                                    ),
                                    SizedBox(
                                      width: size.width * .17,
                                      height: 25,
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),

                        // Mali
                        paysValue == 'Mali'
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18, top: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Bambara
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          initLangue();
                                          bambara = true;
                                          langue = 'BAMBARA';
                                        });
                                      },
                                      child: Container(
                                        width: size.width * .17,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                            color: bambara
                                                ? PRIMARY_COLOR
                                                : Colors.grey.withOpacity(.1)),
                                        padding:
                                            const EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'BAMBARA',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.kadwa(
                                                  color: bambara
                                                      ? Colors.white
                                                      : null,
                                                  fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // BAOULE
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          initLangue();
                                          baoule = true;
                                          langue = 'BAOULE';
                                        });
                                      },
                                      child: Container(
                                        width: size.width * .17,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                            color: baoule
                                                ? PRIMARY_COLOR
                                                : Colors.grey.withOpacity(.1)),
                                        padding:
                                            const EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'BAOULE',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.kadwa(
                                                  color: baoule
                                                      ? Colors.white
                                                      : null,
                                                  fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    //peul
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          initLangue();
                                          peul = true;
                                          langue = 'PEUL';
                                        });
                                      },
                                      child: Container(
                                        width: size.width * .17,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                            color: peul
                                                ? PRIMARY_COLOR
                                                : Colors.grey.withOpacity(.1)),
                                        padding:
                                            const EdgeInsets.only(left: 8, right: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'PEUL',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.kadwa(
                                                  color: peul
                                                      ? Colors.white
                                                      : null,
                                                  fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * .17,
                                      height: 25,
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),

                        // Niger
                        paysValue == 'Niger'
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18, top: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //DIOULA
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          initLangue();
                                          dioula = true;
                                          langue = 'DIOULA';
                                        });
                                      },
                                      child: Container(
                                        width: size.width * .17,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                            color: dioula
                                                ? PRIMARY_COLOR
                                                : Colors.grey.withOpacity(.1)),
                                        padding:
                                            const EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'DIOULA',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.kadwa(
                                                  color: dioula
                                                      ? Colors.white
                                                      : null,
                                                  fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    //ZERMA
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          initLangue();
                                          zerma = true;
                                          langue = 'ZERMA';
                                        });
                                      },
                                      child: Container(
                                        width: size.width * .17,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                            color: zerma
                                                ? PRIMARY_COLOR
                                                : Colors.grey.withOpacity(.1)),
                                        padding:
                                        const EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'ZERMA',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.kadwa(
                                                  color: zerma
                                                      ? Colors.white
                                                      : null,
                                                  fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    //HAOUSSA
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          initLangue();
                                          haoussa = true;
                                          langue = 'HAOUSSA';
                                        });
                                      },
                                      child: Container(
                                        width: size.width * .17,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                            color: haoussa
                                                ? PRIMARY_COLOR
                                                : Colors.grey.withOpacity(.1)),
                                        padding:
                                        const EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'HAOUSSA',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.kadwa(
                                                  color: haoussa
                                                      ? Colors.white
                                                      : null,
                                                  fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    //PEUL
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          initLangue();
                                          peul = true;
                                          langue = 'PEUL';
                                        });
                                      },
                                      child: Container(
                                        width: size.width * .17,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                            color: peul
                                                ? PRIMARY_COLOR
                                                : Colors.grey.withOpacity(.1)),
                                        padding:
                                        const EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'PEUL',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.kadwa(
                                                  color: peul
                                                      ? Colors.white
                                                      : null,
                                                  fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              )
                            : const SizedBox(),

                        // Burkina
                        paysValue == 'Burkina faso'
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18, top: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //DIOULA
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          initLangue();
                                          dioula = true;
                                          langue = 'DIOULA';
                                        });
                                      },
                                      child: Container(
                                        width: size.width * .17,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                            color: dioula
                                                ? PRIMARY_COLOR
                                                : Colors.grey.withOpacity(.1)),
                                        padding:
                                            const EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'DIOULA',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.kadwa(
                                                  color: dioula
                                                      ? Colors.white
                                                      : null,
                                                  fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    //PEUL
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          initLangue();
                                          peul = true;
                                          langue = 'PEUL';
                                        });
                                      },
                                      child: Container(
                                        width: size.width * .17,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                            color: peul
                                                ? PRIMARY_COLOR
                                                : Colors.grey.withOpacity(.1)),
                                        padding:
                                        const EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'PEUL',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.kadwa(
                                                  color: peul
                                                      ? Colors.white
                                                      : null,
                                                  fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    //MOORE
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          initLangue();
                                          moore = true;
                                          langue = 'MOORE';
                                        });
                                      },
                                      child: Container(
                                        width: size.width * .17,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                            color: moore
                                                ? PRIMARY_COLOR
                                                : Colors.grey.withOpacity(.1)),
                                        padding:
                                        const EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'MOORE',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.kadwa(
                                                  color: moore
                                                      ? Colors.white
                                                      : null,
                                                  fontSize: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              )
                            : const SizedBox(),
                        //champ nom
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 18.0, top: 8, bottom: 8, right: 18),
                          child: _nomController.textformfield(context),
                        ),
                        //champ prénom
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 18.0, top: 8, bottom: 8, right: 18),
                          child: _prenomController.textformfield(context),
                        ),
                        //champ commune
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 18.0, top: 8, bottom: 8, right: 18),
                          child: _communeController.textformfield(context),
                        ),

                        /// liste Secteur
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 18.0, top: 8, bottom: 8, right: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Sous secteurs',
                                    style: GoogleFonts.kadwa(
                                        fontSize: 14,
                                        color: Colors.black.withOpacity(.5)),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isClickSecteur = !isClickSecteur;
                                        });
                                      },
                                      icon: isClickSecteur
                                          ? const Icon(
                                              Icons.arrow_drop_down_sharp,
                                              color: PRIMARY_COLOR,
                                            )
                                          : const Icon(
                                              Icons.arrow_drop_up_sharp,
                                              color: PRIMARY_COLOR,
                                            ))
                                ],
                              ),
                              isClickSecteur
                                  ? const SizedBox(
                                      height: 7,
                                    )
                                  : const SizedBox(),
                              isClickSecteur
                                  ? Column(
                                      children: secteurVal
                                          .map((e) => Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Checkbox(
                                                          value: e.isClick,
                                                          onChanged: (value) {
                                                            if (value != null) {
                                                              setState(() {
                                                                e.isClick =
                                                                    value;
                                                                if (e.isClick) {
                                                                  addSecteur(
                                                                      e.name);
                                                                } else {
                                                                  removeSecteur(
                                                                      e.name);
                                                                }
                                                              });
                                                            }
                                                          },
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          e.name,
                                                          style:
                                                              GoogleFonts.kadwa(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      ],
                                                    ),
                                                    CircleAvatar(
                                                      backgroundImage:
                                                          e.imgPath == null
                                                              ? null
                                                              : AssetImage(
                                                                  e.imgPath!),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                          .toList(),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                        /// Mot de passe
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 18.0, top: 8, bottom: 8, right: 18),
                          child: Container(
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
                              obscureText: isVisible,
                              keyboardType: TextInputType.text,
                              controller: _passwordController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.key,
                                  color: Colors.black.withOpacity(.7),
                                ),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isVisible = !isVisible;
                                      });
                                    },
                                    icon: isVisible
                                        ? const Icon(Icons.visibility_off)
                                        : const Icon(Icons.visibility)),
                                border: InputBorder.none,
                                hintMaxLines: 1,
                                hintText: "*********",
                                hintStyle: GoogleFonts.kadwa(
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(.5)),
                              ),
                            ),
                          ),
                        ),
                        /// Confirmer le mot de passe
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 18.0, top: 8, bottom: 8, right: 18),
                          child: Container(
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
                              obscureText: isVisibleConfirm,
                              keyboardType: TextInputType.text,
                              controller: _passwordConfirmController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.key,
                                  color: Colors.black.withOpacity(.7),
                                ),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isVisibleConfirm = !isVisibleConfirm;
                                      });
                                    },
                                    icon: isVisibleConfirm
                                        ? const Icon(Icons.visibility_off)
                                        : const Icon(Icons.visibility)),
                                border: InputBorder.none,
                                hintMaxLines: 1,
                                hintText: "Confirmer mot de passe",
                                hintStyle: GoogleFonts.kadwa(
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(.5)),
                              ),
                            ),
                          ),
                        ),

                        ///photo de profil
                       /* Padding(
                          padding: const EdgeInsets.only(
                              left: 18.0, top: 8, bottom: 8, right: 18),
                          child: InkWell(
                            onTap: () {
                              getImage();
                            },
                            child: Container(
                              height: 50,
                              width: size.width / 1.22,
                              padding: EdgeInsets.only(
                                  right: size.width / 30, left: 18),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.05),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.image,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        width: appWidthSize(context)*0.6,
                                        child: Text(
                                          photopath == null
                                              ? 'Sélectionner une photo'
                                              : photoname!,
                                          style: TextStyle(
                                            color: Colors.black.withOpacity(.5),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),*/

                        ///politique de confidentialité
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 18.0, top: 8, bottom: 8, right: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isClick = true;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PolitiqueEtConfidantialite(isRead: isClick,),
                                      ));
                                },
                                child: Text(
                                  'Politique de confidentialité',
                                  style: GoogleFonts.kadwa(
                                    color: PRIMARY_COLOR,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              Checkbox(
                                value: isClick,
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      isClick = !isClick;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            component2(
                              'S\'inscrire',
                              2.6,
                              () async {
                                if (!isClick) {
                                  _showSnackBar(
                                      "Cochez la politique de confidentialité");
                                } else if (_passwordController.text !=
                                    _passwordConfirmController.text) {
                                  _showSnackBar(
                                      "Le mot de passe n'est pas identique");
                                } else if (_numeroController.text == '' || _numeroController.text.isEmpty) {
                                  _showSnackBar("Veillez entrer votre numéro");
                                } else {
                                  inscription();

                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Se connecter à mon compte',
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
                                      MaterialPageRoute(builder: (context) => const Connexion()),
                                          (route) => false,
                                    );
                                  },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                      ],
                    ),
                  ),
                //),
              //),
            ),
          ),
        ),
      //),
    );
  }

  Widget component2(String string, double width, VoidCallback voidCallback) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: voidCallback,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 18.0, top: 8, bottom: 8, right: 18),
        child: Container(
          height: 50,
          width: size.width * .8,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: const [0.1, 0.5],
                  colors: [PRIMARY_COLOR, PRIMARY_COLOR.withOpacity(.5)])),
          child: Text(
            string,
            style: GoogleFonts.kadwa(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: PRIMARY_COLOR,
        content: Text(message),
      ),
    );
  }

  void inscription() async {
    //widget.visible();
    if(_numeroController.text.isEmpty || _passwordConfirmController.text.isEmpty || _passwordController.text.isEmpty || _numeroController.text.isEmpty || _nomController.valu.text.isEmpty || _prenomController.valu.text.isEmpty || _communeController.valu.text.isEmpty || _secteurController.isEmpty){
      _showSnackBar("Veuillez renseigner toutes les informations");

    }else{
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email:
              paysValue == 'Bénin'?
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
        password: _passwordConfirmController.text,
        //numerous: _numeroController.value,
      );
      _showSnackBar("Inscription effectuée avec succès");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Pages()),
            (route) => false,
      );

      await FirebaseFirestore.instance
          .collection('utilisateurs')
          .doc(userCredential.user!.uid)
          .set({
        'nom': _nomController.valu.text,
        'prenom': _prenomController.valu.text,
        'commune': _communeController.valu.text,
        'numero': _numeroController.text,
        'secteur': _secteurController,
        'langue': langue,
        'passe': _passwordController.text,
        'pays': paysValue,
        'imageProfil' : imageProfil,
      });
      //widget.visible!();
    } catch (e) {
      if("$e" == "[firebase_auth/weak-password] Password should be at least 6 characters") {
        _showSnackBar("Veuillez entrer un mot de passe d'au moins 6 caractères");
      } else if('$e' == '[firebase_auth/email-already-in-use] The email address is already in use by another account.'){
        _showSnackBar('Ce numéro est déjà relié à un compte');
      } else if("$e" == "[firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred."){
        _showSnackBar("Veuillez vérifier votre connexion internet");
      }
      else{
        print("Une erreur s'est produite lors de l'inscription::: $e"); // Gérer les erreurs d'inscription, par exemple afficher un message d'erreur à l'utilisateur
        _showSnackBar("Une erreur s'est produite lors de l'inscription, veuillez réessayer");
      }
      }

  }
}}


