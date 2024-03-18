import 'dart:async';
import 'dart:io';
//import 'dart:js';
import 'package:agribenin/Page/chat/chatWaiting.dart';
import 'package:agribenin/Page/chat/discussionPage.dart';
import 'package:agribenin/Page/screen/app_sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:agribenin/Page/commentaire.dart';
import 'package:agribenin/authentification/inscriptionConnexion.dart';
import 'package:agribenin/constants/cons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'compte.dart';
import 'messagerie.dart';
import 'prevision.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'dart:math';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Post {
  String? extractVideoId(String url) {
    RegExp regExp = RegExp(
        r"(?:(?:https?:\/\/)?(?:www\.)?youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})");
    Match? match = regExp.firstMatch(url);
    return (match != null && match.groupCount >= 1)
        ? match.group(1)
        : ''; //null
  }

  String id;
  String text;
  String? auth;
  String? imageUrl;
  String? videoUrl;
  int views;
  bool liked;
  String? debut;
  String? fin;
  String? phone;
  List<dynamic> pays;
  List<String> likedBy;
  YoutubePlayerController? youtubeController;

  Post({
    required this.id,
    required this.text,
    this.auth,
    this.imageUrl,
    this.videoUrl,
    required this.views,
    required this.liked,
    required this.debut,
    required this.fin,
    required this.phone,
    required this.pays,
    this.likedBy = const [],
  }) {
    if (videoUrl != null && videoUrl != "null") {
      String? videoId = extractVideoId(videoUrl!);
      youtubeController = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
  }

  factory Post.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data() ?? {};
    List<String> likedBy = List<String>.from(data['likedBy'] ?? []);
    return Post(
      id: doc.id,
      text: data['text'] ?? '',
      auth: data['auth'] ?? '',
      imageUrl: data['imageUrl'],
      videoUrl: data['videoUrl'],
      views: data['views'] ?? 0,
      liked: data['liked'] ?? false,
      debut: data['debut'] ?? '',
      phone: data['phone'] ?? '',
      likedBy: likedBy,
      fin: data['fin'],
      pays: data['country']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'auth' : auth,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'views': views,
      'liked': liked,
      'debut': debut,
      'fin' : fin,
      'pays' : pays,
      'phone': phone
    };
  }
}


class Pages extends StatefulWidget {
  const Pages({super.key});

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  int currentIndex = 0;
  var composants = [const Alert(), const Innov()];
  bool loading = true;



  User? _user;
  Map<String, dynamic>? _userData;
  //var _userData = [];

  String? get userId => null;

  Future<void> _loadUserData() async {
    setState(() {
      loading =true;
    });
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _userData != null
          ? Scaffold(

        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: PRIMARY_COLOR,
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 30,
              backgroundImage:  AssetImage('images/logo.jpg'),
            ),
          ),
          title: Text(
            '${_userData!['nom'] ?? ''} ${_userData!['prenom'] ?? ''}',
            style: GoogleFonts.kadwa(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),

          ),

          actions: [GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const Compte()) );
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.menu, color: Colors.white,),
              ))],

        ),


        body: composants[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey[200],
          elevation: 0,
          selectedLabelStyle: const TextStyle(color: Colors.white),
          unselectedItemColor: Colors.grey,
          selectedItemColor: PRIMARY_COLOR,
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          unselectedLabelStyle: GoogleFonts.kadwa(),
          selectedIconTheme: const IconThemeData(
            color: Colors.white,
          ),

          items: [
            BottomNavigationBarItem(
              activeIcon: CircleAvatar(
                radius: appHeightSize(context)*0.03,
                backgroundColor: PRIMARY_COLOR,
                child: const Icon(
                  //Icons.table_rows_rounded,
                  Icons.notifications_active,
                  color: Colors.white,
                ),
              ),
              icon: const Icon(
                Icons.notifications_active_outlined,
                color: Colors.grey,
              ),
              label: "Alerte",
              //label: _userData?['pays']
            ),
            BottomNavigationBarItem(
              activeIcon: CircleAvatar(
                backgroundColor: PRIMARY_COLOR,
                radius: appHeightSize(context)*0.03,
                child: const Icon(
                  Icons.science,
                  color: Colors.white,
                ),
              ),
              icon: const Icon(
                Icons.science_outlined,
                color: Colors.grey,
              ),
              label: "Innov",
            ),

          ],
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: PRIMARY_COLOR,
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context) => const DiscussionPage()));
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatWaiting()));
          },
          child: const Icon(Icons.wechat, color: Colors.white, size: 35,),
        ),

      ) : Scaffold(
          appBar: AppBar(),
          body: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('animations/lotties/loading.json', width: appWidthSize(context)*0.35, height: appHeightSize(context)*0.3),
          const Text('Veuillez patienter ...', style: TextStyle(color: PRIMARY_COLOR, fontSize: 12))
        ],
      ),)),
    );
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('String', String));
  }
}

/// Page Innov
class Innov extends StatefulWidget {
  const Innov({super.key});

  @override
  State<Innov> createState() => _InnovState();
}

class _InnovState extends State<Innov> {
  late User? _user;
  late Map<String, dynamic> _userData;

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

      // Mettez à jour l'état pour déclencher un réaffichage
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _updateLikeStatus(Post post) async {
    // Mettez à jour l'état local
    setState(() {
      post.liked = !post.liked;

    });

    // Mettez à jour la base de données Firebase
    await FirebaseFirestore.instance
        .collection('publications')
        .doc(post.id)
        .update({'liked': post.liked, 'likedBy': post.likedBy});
  }

  YoutubePlayerController? youtubeController;
  String? videoUrl;
  late List<Post> actualite;
  late Set<String> expandedPosts;

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
    actualite = [];
    expandedPosts = {};
    _loadDataFromFirestore();
    _loadUserData();
    _initializeUserData();

    // Assuming actualite is a list of posts
    if (actualite.isNotEmpty) {
      String? postVideoUrl = actualite[0].videoUrl;

      // Check if postVideoUrl is not "null" or null
      if (postVideoUrl != null && postVideoUrl != "null") {
        videoUrl = postVideoUrl;
        String? videoId = extractVideoId(videoUrl!);
        youtubeController = YoutubePlayerController(
          initialVideoId: videoId ?? '',
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );
      }
    }
  }

  String? extractVideoId(String url) {
    RegExp regExp = RegExp(
        r"(?:(?:https?:\/\/)?(?:www\.)?youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})");
    Match? match = regExp.firstMatch(url);
    return (match != null && match.groupCount >= 1) ? match.group(1) : null;
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

  Future<void> _loadDataFromFirestore() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('publications').get();

    setState(() {
      actualite = snapshot.docs
          .map((doc) => Post.fromFirestore(doc))
          .where((post) => post != null)
          .toList();
    });
  }

  Stream<List<Post>> _getPostStream() {
    DateTime currentDate = DateTime.now(); // Récupération de la date actuelle
    //String formattedDate = DateFormat.yMd().format(currentDate); // Formatage de la date actuelle
    //String formattedFin = DateFormat('d/M/yyyy').format(DateTime.parse(fin));
    return FirebaseFirestore.instance
        .collection('publications')
        .where('type', isEqualTo: 'innov')
        //.where('debut', isLessThanOrEqualTo: formattedDate) // Filtrer les publications dont la date de début est inférieure ou égale à la date actuelle
        .orderBy('debut', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .where((doc) =>
        (doc['country']).contains(_userData['pays']) &&
        (doc['languages']).contains(_userData['langue'])&&
            _userData['secteur'].any((sector) => (doc['subSectors'] as List).contains(sector)))
        .map((doc) => Post.fromFirestore(doc))
        .toList());

  }

  void _launchPhoneCall(String phoneNumber) async {
    if (await canLaunch('tel:$phoneNumber')) {
      await launch('tel:$phoneNumber');
    } else {
      throw 'Could not launch tel:$phoneNumber';
    }
  }

  bool isPlay = false;
  void isPlayStart() {
    isPlay = false;
    Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      setState(() {
        isPlay = true;
      });
    });
  }
  ///initState déjà


  void deletePub() {
    // Initialiser Firebase
    Firebase.initializeApp();

    // Créer un abonnement aux changements de la collection 'publications'
    FirebaseFirestore.instance.collection('publications').snapshots().listen((querySnapshot) {
      querySnapshot.docs.forEach((snapshot) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String fin = data['fin'];

        // Reformater la date de fin au format 'yMd'
        //String formattedFin = DateFormat.yMd().format(DateTime.parse(fin));
        String formattedFin = DateFormat('d/M/yyyy').format(DateTime.parse(fin));


        // Vérifier si la date de fin est passée
        DateTime finDate = DateTime.parse(formattedFin);
        if (finDate.isBefore(DateTime.now())) {
          // Supprimer la publicité expirée de la base de données Firebase
          FirebaseFirestore.instance.collection('publications').doc(snapshot.id).delete();
        }
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        //backgroundColor: CupertinoColors.systemGrey5,
      backgroundColor: Colors.white,
        body: StreamBuilder<List<Post>>(

        stream: _getPostStream(),
        builder: (context, snapshot) {

          //vérification de la validité des publications avant de les afficher
          deletePub();

          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          List<Post> actualite = snapshot.data ?? [];

          if (actualite.isEmpty) {
            return Center(child: Column(
              children: [
                SizedBox(
                  height: appHeightSize(context)*0.2,),
                SizedBox(
                    height: appHeightSize(context)*0.3,
                    child: Lottie.asset("animations/lotties/pubWaiting.json")),
                const Text("Aucune publication disponible pour l'instant"),
              ],
            ));
          }

          return ListView(
            children: actualite.map((post) {
              bool isExpanded = expandedPosts.contains(post.id);
              //verification de la validité des publications
              deletePub();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.grey, blurRadius: 3.0),
                      BoxShadow(color: PRIMARY_COLOR, blurRadius: 4.0),
                    ]

                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading:  const Icon(Icons.account_circle, size: 30, color: PRIMARY_COLOR,),
                        title: Text(
                          '${post.auth}',
                          style: GoogleFonts.kadwa(
                            fontSize: 14,
                            color: PRIMARY_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        dense: true,
                        trailing: InkWell(onTap: () {}, child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Column(
                            children: [
                              Text("Du ${post.debut!}", style: TextStyle(),),
                              Text("au ${post.fin!}", style: const TextStyle(color: Colors.red),),
                            ],
                          ),
                        )),
                      ),
                      Container(
                        width: size.width*0.95,
                        padding: const EdgeInsets.only(left: 18, right: 18),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (post.text.length > 100) {
                                // Toggle expanded state only for posts with text longer than 100 characters
                                if (isExpanded) {
                                  expandedPosts.remove(post.id);
                                } else {
                                  expandedPosts.add(post.id);
                                }
                              }
                            });
                          },
                          child: Text(
                            isExpanded
                                ? post.text
                                : (post.text.length <= 100
                                    ? post.text
                                    : '${post.text.substring(0, 100)}... Voir plus'),
                            style: GoogleFonts.kadwa(fontSize: 13),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 200,
                          width: size.width*0.9,
                          decoration: const BoxDecoration(),
                          child: post.youtubeController != null
                              ? YoutubePlayer(
                            width: size.width*0.9,
                                  controller: post.youtubeController!,
                                  showVideoProgressIndicator: true,
                                  progressIndicatorColor:
                                      const Color.fromRGBO(255, 193, 7, 1),
                                  progressColors: const ProgressBarColors(
                                    playedColor: Colors.amber,
                                    handleColor: Colors.amberAccent,
                                  ),
                                  onReady: () {
                                    // Video player is ready
                                  },
                                )
                              : post.imageUrl != null
                                  ? Image.network(
                                      post.imageUrl!,
                                      fit: BoxFit.fill,
                                      height: 200,
                                    )
                                  : Container(),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: size.width,
                        padding: const EdgeInsets.only(left: 8, right: 18),
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Container(
                              height : appHeightSize(context)*0.05,
                              width : appWidthSize(context)*0.2,
                              decoration: BoxDecoration(
                                color: PRIMARY_COLOR,
                                borderRadius: BorderRadius.circular(appHeightSize(context))
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.phone, color: Colors.white,),
                                onPressed: () {
                                  _launchPhoneCall(post.phone!);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*const Row(
                        children: [],
                      ),
                      const Divider(
                        thickness: 5,
                      ),*/
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),



    );
  }

  @override
  void dispose() {
    youtubeController?.dispose();
    super.dispose();
  }
}
///Fin Innov


/// Page Alert
class Alert extends StatefulWidget {
  const Alert({super.key});

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  late User? _user;
  late Map<String, dynamic> _userData;

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

      // Mettez à jour l'état pour déclencher un réaffichage
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _updateLikeStatus(Post post) async {
    // Mettez à jour l'état local
    setState(() {
      post.liked = !post.liked;

    });

    // Mettez à jour la base de données Firebase
    await FirebaseFirestore.instance
        .collection('publications')
        .doc(post.id)
        .update({'liked': post.liked, 'likedBy': post.likedBy});
  }

  YoutubePlayerController? youtubeController;
  String? videoUrl;
  late List<Post> actualite;
  late Set<String> expandedPosts;

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
    actualite = [];
    expandedPosts = {};
    _loadDataFromFirestore();
    _loadUserData();
    _initializeUserData();

    // Assuming actualite is a list of posts
    if (actualite.isNotEmpty) {
      String? postVideoUrl = actualite[0].videoUrl;

      // Check if postVideoUrl is not "null" or null
      if (postVideoUrl != null && postVideoUrl != "null") {
        videoUrl = postVideoUrl;
        String? videoId = extractVideoId(videoUrl!);
        youtubeController = YoutubePlayerController(
          initialVideoId: videoId ?? '',
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );
      }
    }
  }

  String? extractVideoId(String url) {
    RegExp regExp = RegExp(
        r"(?:(?:https?:\/\/)?(?:www\.)?youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})");
    Match? match = regExp.firstMatch(url);
    return (match != null && match.groupCount >= 1) ? match.group(1) : null;
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

  Future<void> _loadDataFromFirestore() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('publications').get();

    setState(() {
      actualite = snapshot.docs
          .map((doc) => Post.fromFirestore(doc))
          .where((post) => post != null)
          .toList();
    });
  }

  Stream<List<Post>> _getPostStream() {
    return FirebaseFirestore.instance
        .collection('publications')
        .where('type', isEqualTo: 'alerte')
    //.where('debut', isLessThanOrEqualTo: formattedDate) // Filtrer les publications dont la date de début est inférieure ou égale à la date actuelle
        .orderBy('debut', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .where((doc) =>
    (doc['country']).contains(_userData['pays']) &&
        (doc['languages']).contains(_userData['langue']) &&
        _userData['secteur'].any((sector) => (doc['subSectors'] as List).contains(sector)))
        .map((doc) => Post.fromFirestore(doc))
        .toList());

  }

  void _launchPhoneCall(String phoneNumber) async {
    if (await canLaunch('tel:$phoneNumber')) {
      await launch('tel:$phoneNumber');
    } else {
      throw 'Could not launch tel:$phoneNumber';
    }
  }

  bool isPlay = false;
  void isPlayStart() {
    isPlay = false;
    Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      setState(() {
        isPlay = true;
      });
    });
  }

  void deletePub() {
    // Initialiser Firebase
    Firebase.initializeApp();

    // Créer un abonnement aux changements de la collection 'publications'
    FirebaseFirestore.instance.collection('publications').snapshots().listen((querySnapshot) {
      querySnapshot.docs.forEach((snapshot) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String fin = data['fin'];

        // Reformater la date de fin au format 'yMd'
        //String formattedFin = DateFormat.yMd().format(DateTime.parse(fin));
        String formattedFin = DateFormat('d/M/yyyy').format(DateTime.parse(fin));

        // Vérifier si la date de fin est passée
        DateTime finDate = DateTime.parse(formattedFin);
        if (finDate.isBefore(DateTime.now())) {
          // Supprimer la publicité expirée de la base de données Firebase
          FirebaseFirestore.instance.collection('publications').doc(snapshot.id).delete();
        }
      });
    });
  }



  ///initState déjà
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //backgroundColor: CupertinoColors.systemGrey5,
      backgroundColor: Colors.white,
      body: StreamBuilder<List<Post>>(
        stream: _getPostStream(),
        builder: (context, snapshot) {
          //vérification de la validité des publications
          deletePub();
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          List<Post> actualite = snapshot.data ?? [];

          if (actualite.isEmpty) {
            return Center(child: Column(
              children: [
                SizedBox(
                  height: appHeightSize(context)*0.2,),
                SizedBox(
                    height: appHeightSize(context)*0.3,
                    child: Lottie.asset("animations/lotties/pubWaiting.json")),
                const Text("Aucune publication disponible pour l'instant"),
              ],
            ));
          }

          return ListView(
            children: actualite.map((post) {
              bool isExpanded = expandedPosts.contains(post.id);
              //vérification de la validité des publications
              deletePub();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  width: appWidthSize(context)*0.9,
                  decoration: BoxDecoration(
                    //color: Colors.grey[200],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.account_circle, size: 30, color: PRIMARY_COLOR,),
                        title: Text(
                          '${post.auth}',
                          style: GoogleFonts.kadwa(
                            fontSize: 14,
                            //color: Colors.black,
                            color : PRIMARY_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        dense: true,
                        trailing: InkWell(onTap: () {}, child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Column(
                            children: [
                              Text("Du ${post.debut!}"),
                              Text("au ${post.fin!}", style: const TextStyle(color: Colors.red),),
                            ],
                          ),
                        )),
                      ),
                      Container(
                        width: size.width*0.85,
                        padding: const EdgeInsets.only(left: 18, right: 18),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (post.text.length > 100) {
                                // Toggle expanded state only for posts with text longer than 100 characters
                                if (isExpanded) {
                                  expandedPosts.remove(post.id);
                                } else {
                                  expandedPosts.add(post.id);
                                }
                              }
                            });
                          },
                          child: Text(
                            isExpanded
                                ? post.text
                                : (post.text.length <= 100
                                ? post.text
                                : '${post.text.substring(0, 100)}... Voir plus'),
                            style: GoogleFonts.kadwa(fontSize: 13),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                      Container(
                        height: 200,
                        width: size.width*0.9,
                        decoration: const BoxDecoration(),
                        child: post.youtubeController != null
                            ? YoutubePlayer(
                          controller: post.youtubeController!,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor:
                          const Color.fromRGBO(255, 193, 7, 1),
                          progressColors: const ProgressBarColors(
                            playedColor: Colors.amber,
                            handleColor: Colors.amberAccent,
                          ),
                          onReady: () {
                            // Video player is ready
                          },
                        )
                            : post.imageUrl != null
                            ? Image.network(
                          post.imageUrl!,
                          fit: BoxFit.cover,
                          height: 200,
                        )
                            : Container(),
                      ),
                      Container(
                        height: 60,
                        width: size.width,
                        padding: const EdgeInsets.only(left: 8, right: 18),
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Container(
                              height : appHeightSize(context)*0.05,
                              width : appWidthSize(context)*0.2,
                              decoration: BoxDecoration(
                                color: PRIMARY_COLOR,
                                borderRadius: BorderRadius.circular(appHeightSize(context))
                              ),

                              child: IconButton(

                                icon: const Icon(Icons.phone, color: Colors.white,),
                                onPressed: () {
                                  _launchPhoneCall(post.phone!);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                     /* const Row(
                        children: [],
                      ),
                      const Divider(
                        thickness: 5,
                      ),*/
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    youtubeController?.dispose();
    super.dispose();
  }
}

///Fin Alert


void _showDownloadMenu(BuildContext context, Post publication) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.file_download),
            title: const Text('Télécharger l\'image/vidéo'),
            onTap: () {
              _downloadMedia(context, publication);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.cancel),
            title: const Text('Annuler'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

Future<void> _downloadMedia(BuildContext context, Post publication) async {
  String mediaUrl = publication.imageUrl ?? publication.videoUrl ?? '';
  print(mediaUrl);

  String mediaType =
      mediaUrl.toLowerCase().endsWith('.mp4') ? 'video' : 'image';

  try {
    if (mediaType == 'image') {
      await _saveImageToDisk(context, mediaUrl);
    } else if (mediaType == 'video') {
      // Ajoutez ici la logique pour télécharger et gérer les vidéos
      print("telechargement de video");
      //await _saveVideoToDisk(mediaUrl);
    }
  } catch (error) {
    print('Erreur de téléchargement: $error');
  }
}

Future<void> _saveImageToDisk(BuildContext context, String imageUrl) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  late String message;
  var random = Random();

  try {
    // Téléchargez l'image
    final http.Response response = await http.get(Uri.parse(imageUrl));

    // Obtenez le répertoire temporaire
    final dir = await getTemporaryDirectory();

    // Créez un nom d'image
    var filename = '${dir.path}/SaveImage${random.nextInt(100)}.png';

    // Sauvegardez sur le système de fichiers
    final file = File(filename);
    await file.writeAsBytes(response.bodyBytes);

    // Demandez à l'utilisateur de le sauvegarder
    final params = SaveFileDialogParams(sourceFilePath: file.path);
    final finalPath = await FlutterFileDialog.saveFile(params: params);

    if (finalPath != null) {
      message = 'Image saved to disk';
    }
  } catch (e) {
    message = e.toString();
    scaffoldMessenger.showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: const Color(0xFFe91e63),
    ));
  }

  if (message != null) {
    scaffoldMessenger.showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: const Color(0xFFe91e63),
    ));
  }
}
