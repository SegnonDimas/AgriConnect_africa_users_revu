import 'package:agribenin/constants/cons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';

class Commentaire extends StatefulWidget {
  String title;
  String image;
  String imagePost;
  String duree;
  String description;

  Commentaire(
      {required this.title,
      required this.imagePost,
      required this.image,
      required this.duree,
      required this.description});

  @override
  State<Commentaire> createState() => _CommentaireState();
}

class _CommentaireState extends State<Commentaire> {
  // Pour les audios
  late var audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecord = false;
  bool isPlayRecord = false;
  String audioPath = '';
  @override
  void initState() {
    // TODO: implement initState
    audioPlayer = AudioPlayer();
    audioRecord = AudioRecorder();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    audioPlayer.dispose();
    audioRecord.dispose();
    super.dispose();
  }

  Future<void> commencerRecord() async {
    try {
      //
      if (await audioRecord?.hasPermission()) {
        await audioRecord.start();
        setState(() {
          isRecord = true;
        });
      }
    } catch (e) {
      print('Error lors d\'enregistrement : $e');
    }
  }

  Future<void> arreteRecord() async {
    try {
      //
      if (await audioRecord.hasPermission()) {
        String? path = await audioRecord.stop();
        setState(() {
          isRecord = false;
          audioPath = path!;
        });
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: Container(
              child: ListTile(
                onTap: () {
                  isPlayRecord ? pauseRecord() : playRecord();
                  setState(() {});
                },
                leading: CircleAvatar(
                  backgroundColor: PRIMARY_COLOR,
                  child: isPlayRecord
                      ? Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        )
                      : Icon(
                          Icons.pause,
                          color: Colors.white,
                        ),
                ),
                title: Text(
                  isPlayRecord ? 'lecture...' : 'pause',
                  style: GoogleFonts.kadwa(
                    fontSize: 15,
                  ),
                ),
                dense: true,
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 35,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Annuler".toUpperCase(),
                            style: GoogleFonts.kadwa(
                                fontSize: 10, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 35,
                      width: 80,
                      decoration: BoxDecoration(
                        color: PRIMARY_COLOR,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Envoyer".toUpperCase(),
                            style: GoogleFonts.kadwa(
                                fontSize: 10, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ).then((returnVal) {});
      }
    } catch (e) {
      print('Error lors d\'arret : $e');
    }
  }

  Future<void> playRecord() async {
    isPlayRecord = true;
    try {
      Source urlSource = UrlSource(audioPath);
      await audioPlayer.play(urlSource);
    } catch (e) {
      print('Erreu de lecture : $e');
    }
  }

  Future<void> pauseRecord() async {
    isPlayRecord = false;
    try {
      await audioPlayer.pause();
    } catch (e) {
      print('Erreu de lecture : $e');
    }
  }

  List<String> commentaire = [
    "J'adore vraiment cette nourriture",
    "C'est ma nourriture preferée",
    "L'agriculture africaine est la meilleurs des agricultures au monde",
    "Mois je valide tous vos activitée",
    "Valorison nos végétations",
    "Chez nous c'est la meilleure",
    "J'adore cette agriculteur",
  ];
  void addCommentaire(String value) {
    commentaire.add(value);
  }

  final commentaireController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height - 70,
              child: ListView(
                children: [
                  Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(widget.image),
                        ),
                        title: Text(
                          widget.title,
                          style: GoogleFonts.kadwa(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        dense: true,
                      ),
                      Container(
                        width: size.width,
                        padding: EdgeInsets.only(left: 18, right: 18),
                        child: Text(
                          widget.description,
                          style: GoogleFonts.kadwa(fontSize: 13),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 250,
                        width: size.width,
                        decoration: BoxDecoration(),
                        child:
                            Image.asset(widget.imagePost, fit: BoxFit.contain),
                      ),
                      Container(
                        height: 60,
                        width: size.width,
                        padding: EdgeInsets.only(left: 8, right: 18),
                        decoration: BoxDecoration(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.visibility,
                                      color: Colors.black,
                                    )),
                                Text(
                                  '325',
                                  style: GoogleFonts.kadwa(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.comment_outlined,
                                ),
                                Text(
                                  '525',
                                  style: GoogleFonts.kadwa(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.download,
                                  ),
                                ),
                                Text(
                                  '32',
                                  style: GoogleFonts.kadwa(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 18),
                            child: Text(
                              'Il y a ${widget.duree}',
                              style: GoogleFonts.kadwa(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: commentaire
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(left: 18, top: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: PRIMARY_COLOR,
                                    image: DecorationImage(
                                        image: AssetImage('images/logo.jpg')),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 30,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "ALAGBE Faïd",
                                            style: GoogleFonts.kadwa(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                          maxWidth: size.width - 80),
                                      decoration: BoxDecoration(
                                        color: PRIMARY_COLOR,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(7),
                                        child: Text(
                                          e,
                                          style: GoogleFonts.kadwa(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width - 70,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 219, 219, 219),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 18),
                    child: TextFormField(
                      controller: commentaireController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Commentaire',
                          hintStyle: GoogleFonts.kadwa(
                            fontSize: 13,
                          ),
                          labelStyle: GoogleFonts.kadwa(
                            fontSize: 13,
                          ),
                          suffixIcon: InkWell(
                            onTap: () {
                              if (commentaireController.text.isEmpty) {
                                print("Nooooo");
                              } else {
                                setState(() {
                                  addCommentaire(commentaireController.text);
                                  commentaireController.clear();
                                });
                              }
                            },
                            child: Icon(
                              Icons.send,
                              color: PRIMARY_COLOR,
                              size: 25,
                            ),
                          )),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      isRecord ? arreteRecord() : commencerRecord();
                      print('tap');
                    },
                    child: isRecord
                        ? CircleAvatar(
                            backgroundColor: PRIMARY_COLOR,
                            child: Icon(
                              Icons.mic,
                              color: Colors.white,
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.mic,
                              color: PRIMARY_COLOR,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
