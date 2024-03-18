import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:video_player/video_player.dart';
import '../constants/cons.dart';
import '../widget/smsWidget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:record/record.dart';

class FirestoreService {
  final CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection('messages');
  final FirebaseStorage _storage =
      FirebaseStorage.instanceFor(bucket: 'agriconnect-efa2b.appspot.com');

  Future<void> sendMessage(
    String message,
    String sender, {
    File? image,
  }) async {
    String? imageUrl;

    if (image != null) {
      // Envoyer l'image à Firebase Storage
      final ref = _storage.ref().child('images/${DateTime.now()}.png');
      final UploadTask uploadTask = ref.putFile(image);

      await uploadTask.whenComplete(() async {
        imageUrl = await ref.getDownloadURL();
      }).catchError((error) {
        print("Erreur lors de l'upload de l'image : $error");
      });
    }

    // Enregistrez le message dans la base de données Firestore
    await messagesCollection.add({
      'message': message,
      'sender': sender,
      'image': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getMessages() {
    return messagesCollection.orderBy('timestamp').snapshots();
  }
}

class Messagerie extends StatefulWidget {
  const Messagerie({Key? key}) : super(key: key);

  @override
  State<Messagerie> createState() => _MessagerieState();
}

class _MessagerieState extends State<Messagerie> {
  File? imageFile;
  ImagePicker imagePicker = ImagePicker();
  late AudioRecorder audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = '';

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecord = AudioRecorder();
    super.initState();
  }

  @override
  void dispose() {
    audioRecord.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        String downloadDirectory =
            (await getExternalStorageDirectory())?.path ?? '';
        String path = '$downloadDirectory/enregistrement_audio.m4a';

        await audioRecord.start(RecordConfig(), path: path);

        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      print("Error starting recording: $e");
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stop();
      setState(() {
        isRecording = false;
        audioPath = path!;
      });
    } catch (e) {
      print("Error stopping recording : $e");
    }
  }

  Future<void> playRecording() async {
    try {
      await audioPlayer.play(UrlSource(audioPath));
    } catch (e) {
      print("Error playing recording : $e");
    }
  }

  final FirestoreService _firestoreService = FirestoreService();
  TextEditingController sms = TextEditingController();

  void ajouterSms(String value) async {
    await _firestoreService.sendMessage(value, 'ALAGBE', image: imageFile);
    setState(() {
      imageFile = null;
      sms.clear();
    });
  }

  Future<void> getImagePapier() async {
    var getImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (getImage != null) {
      setState(() {
        imageFile = File(getImage.path);
        // Ajouter l'envoi de l'image ici
        ajouterSms('');
      });
    }
  }

  Future<void> getCameraPapier() async {
    var getImage = await imagePicker.pickImage(source: ImageSource.camera);
    if (getImage != null) {
      setState(() {
        imageFile = File(getImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messagerie'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestoreService.getMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];
                for (var message in messages) {
                  final messageText = message['message'];
                  final messageSender = message['sender'];
                  final imageBase64 = message['image'];

                  Widget? imageWidget;
                  if (imageBase64 != null) {
                    try {
                      final bytes = base64Decode(imageBase64!);
                      imageWidget = Image.memory(bytes);
                    } catch (e) {
                      print("Erreur de décodage base64 : $e");
                      // Gérer l'erreur, par exemple, afficher une image par défaut ou un message d'erreur.
                    }
                  }

                  var messageWidget = MessageWidget(
                    sender: messageSender,
                    text: messageText,
                    image: imageWidget,
                  );

                  messageWidgets.add(messageWidget);
                }

                return ListView.builder(
                  itemCount: messageWidgets.length,
                  itemBuilder: (context, index) {
                    return messageWidgets[index];
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: getImagePapier,
                  icon: Icon(Icons.photo),
                ),
                Expanded(
                  child: TextField(
                    controller: sms,
                    decoration: InputDecoration(
                      hintText: 'Ecrire un message',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: isRecording ? stopRecording : startRecording,
                  icon: Icon(isRecording ? Icons.stop : Icons.mic),
                ),
                IconButton(
                  onPressed: playRecording,
                  icon: Icon(Icons.play_arrow),
                ),
                IconButton(
                  onPressed: () {
                    if (sms.text.isNotEmpty) {
                      ajouterSms(sms.text);
                    }
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String sender;
  final String text;
  final Widget? image;

  MessageWidget({
    required this.sender,
    required this.text,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          Material(
            borderRadius: BorderRadius.circular(10),
            color: Colors.green[600],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  if (image != null) ...[
                    SizedBox(height: 8),
                    image!,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/*import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:video_player/video_player.dart';
import '../constants/cons.dart';
import '../widget/smsWidget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:record/record.dart';

class FirestoreService {
  final CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection('messages');

  Future<void> sendMessage(String message, String sender) async {
    await messagesCollection.add({
      'message': message,
      'sender': sender,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getMessages() {
    return messagesCollection.orderBy('timestamp').snapshots();
  }
}

class Messagerie extends StatefulWidget {
  const Messagerie({super.key});

  @override
  State<Messagerie> createState() => _MessagerieState();
}

class _MessagerieState extends State<Messagerie> {
  File? photopapierpath;
  String? photopapiername;
  String? photopapierdata;
  ImagePicker imagePicker = ImagePicker();

  final FirestoreService _firestoreService = FirestoreService();
  List<String> messages = [];
  void ajouterSms(String value) async {
    await _firestoreService.sendMessage(value, 'ALAGBE');
    setState(() {
      sms.clear();
    });
  }

  // Pour choisi une image
  Future<void> getImagePapier() async {
    var getimage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (getimage != null) {
      setState(() {
        photopapierpath = File(getimage.path);
        photopapiername = getimage.path.split('/').last;
        photopapierdata = base64Encode(photopapierpath!.readAsBytesSync());

        //

        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width * .6,
              height: 200,
              child: Image.file(
                photopapierpath!,
                fit: BoxFit.contain,
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
      });
    }
  }

  // Pour faire la camera
  Future<void> getCameraPapier() async {
    var getimage = await imagePicker.pickImage(source: ImageSource.camera);
    if (getimage != null) {
      setState(() {
        photopapierpath = File(getimage.path);
        photopapiername = getimage.path.split('/').last;
        photopapierdata = base64Encode(photopapierpath!.readAsBytesSync());
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width * .6,
              height: 200,
              child: Image.file(
                photopapierpath!,
                fit: BoxFit.contain,
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
      });
    }
  }

  // Pour choisi la video
  VideoPlayerController? videoController;
  String? videoPath;
  File? pathVideo;
  Future<void> videoPicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'mkv', 'avi'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        videoPath = result.files.first.path;
        pathVideo = File(result.files.first.path!);
        videoController = VideoPlayerController.file(pathVideo!)
          ..initialize().then((_) {
            setState(() {});
            videoController!.play();
            videoController!.setVolume(1);
          });
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content:
                Container(height: 200, child: VideoPlayer(videoController!)),
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
        print(videoPath);
      });
      print(
          "video: $videoPath"); // Vous devez utiliser la variable $pdfassurancePath pour voir le chemin du fichier.
    }
  }

  // Pour les audios
  late var audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecord = false;
  bool isPlayRecord = false;
  String audioPath = '';
  bool isOneRecord = false;
  bool isRecording = false;
  late String recordingPath;
  @override
  void initState() {
    // TODO: implement initState
    audioPlayer = AudioPlayer();
    audioRecord = AudioRecorder();
    //audioRecord = AudioRecorder();
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
      PermissionStatus status = await Permission.microphone.request();
      if (status == PermissionStatus.granted) {
        String path = await audioRecord.start();
        setState(() {
          isRecord = true;
          isRecording = true;
          recordingPath = path;
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
      var urlSource = UrlSource(audioPath);
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

  TextEditingController sms = TextEditingController();
  List<String> messageListe = [
    'Bonjour Boss',
    'Je me porte à merveille',
    'La journée à été tres sublime',
    'La vie est comme ça',
    'Nickel',
  ];

  List<String> allMessages = [];

  bool isSend = false;
  bool search = true;

  int idConnecter = 1;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Message',
          style: GoogleFonts.kadwa(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment:
            MainAxisAlignment.end, // Aligner vers le bas de la colonne
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestoreService.getMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];
                for (var message in messages) {
                  final messageText = message['message'];
                  final messageSender = message['sender'];

                  var messageWidget = MessageWidget(messageSender, messageText);
                  messageWidgets.insert(0, messageWidget);
                }

                return ListView(
                  reverse: true,
                  children: messageWidgets,
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: size.width,
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          content: Container(
                            width: size.width * .6,
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        getCameraPapier();
                                        setState(() {});
                                      },
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.pink[600],
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'Camera',
                                            style: GoogleFonts.kadwa(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        getImagePapier();
                                        setState(() {});
                                      },
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.green,
                                            child: Icon(
                                              Icons.image,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'Image',
                                            style: GoogleFonts.kadwa(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        videoPicker();
                                        setState(() {});
                                      },
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.green[600],
                                            child: Icon(
                                              Icons.video_camera_back,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'Video',
                                            style: GoogleFonts.kadwa(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).then((returnVal) {});
                    },
                    child: Icon(
                      Icons.link,
                      color: PRIMARY_COLOR,
                    ),
                  ),
                  Container(
                    width: size.width - 160,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(right: size.width / 30, left: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: sms,
                      style: TextStyle(color: Colors.black.withOpacity(.8)),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintMaxLines: 1,
                        hintText: 'Ecrire un message',
                        hintStyle: GoogleFonts.kadwa(
                            fontSize: 14, color: Colors.black.withOpacity(.5)),
                      ),
                      maxLines: 4,
                      minLines: 1,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (sms.text.isEmpty || sms.text.startsWith(" ")) {
                        print('null');
                      } else {
                        ajouterSms(sms.text);
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: PRIMARY_COLOR,
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  InkWell(
                    onLongPress: () {
                      print('OK presse');
                    },
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
          )
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String sender;
  final String text;

  MessageWidget(this.sender, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          Material(
            borderRadius: BorderRadius.circular(10),
            color: Colors.green[600],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

*/
