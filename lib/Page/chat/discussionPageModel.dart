import 'package:agribenin/Page/app_colors.dart';
import 'package:agribenin/Page/chat/infoMessagePage.dart';
import 'package:agribenin/Page/screen/app_sizes.dart';
import 'package:agribenin/Page/screen/text_sizes.dart';
import 'package:agribenin/Page/styles/messageModel.dart';
import 'package:agribenin/constants/cons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';



class DiscussionPageModel extends StatefulWidget {
  String? userName;
  DiscussionPageModel({
    super.key,
  this.userName = 'Dimas',
  });

  @override
  State<DiscussionPageModel> createState() => _DiscussionPageModelState();
}

class _DiscussionPageModelState extends State<DiscussionPageModel> {
  final TextEditingController _messageController = TextEditingController();

  final List<Widget> _emojiList = const <Widget>[
    Padding(
      padding: EdgeInsets.all(4.0),
      child: Text(
        '🙏',
        style: TextStyle(fontSize: 27),
      ),
    ),
    Padding(
      padding: EdgeInsets.all(4.0),
      child: Text(
        '😀',
        style: TextStyle(fontSize: 27),
      ),
    ),
    Padding(
      padding: EdgeInsets.all(4.0),
      child: Text(
        '😥',
        style: TextStyle(fontSize: 27),
      ),
    ),
    Padding(
      padding: EdgeInsets.all(4.0),
      child: Text(
        '🤔',
        style: TextStyle(fontSize: 27),
      ),
    ),
    Padding(
      padding: EdgeInsets.all(4.0),
      child: Text(
        '❤️',
        style: TextStyle(fontSize: 27),
      ),
    ),
    Padding(
      padding: EdgeInsets.all(4.0),
      child: Text(
        '👍',
        style: TextStyle(fontSize: 27),
      ),
    ),
    Padding(
      padding: EdgeInsets.all(4.0),
      child: Text(
        '🥰',
        style: TextStyle(fontSize: 27),
      ),
    ),
    Padding(
      padding: EdgeInsets.all(4.0),
      child: Text(
        '😳',
        style: TextStyle(fontSize: 27),
      ),
    ),
    Padding(
      padding: EdgeInsets.all(4.0),
      child: Text(
        '👏',
        style: TextStyle(fontSize: 27),
      ),
    ),
  ];




  String image = 'images/chaussure.png';
  bool isRead = false;
  String message = '';
  bool sendByAdmin = false;
  String sender = 'Vous';
  DateTime timestamp = DateTime.now();
  String type = 'text';
  String video = 'null';
  bool longPressed = false;
  bool sendByMe = true;
  bool sendByOther = false;
  bool emojiButtonPressed = false;
  bool record = false;
  String messageState = '';
  FlutterSoundRecorder? _audioRecorder;
  FlutterSoundPlayer? _audioPlayer;
  String _pathEnregistrement = '';
  var tempDir = '';
  var path = '';
  bool _enregistrementEnCours = false;
  bool jouerEnregistrement = false;
  String audioId = '';


  Future<void> _demanderAutorisationMicrophone() async {
    // Vérifiez si l'autorisation est déjà accordée
    PermissionStatus status = await Permission.microphone.status;
    if (!status.isGranted) {
      // Si l'autorisation n'est pas accordée, demandez-la
      status = await Permission.microphone.request();
      if (!status.isGranted) {
        // Si l'utilisateur refuse l'autorisation, affichez un message d'erreur
        print('Autorisation refusée pour utiliser le microphone');
        return;
      }
    }
  }

///


  /// _commencerEnregistrement
  void _commencerEnregistrement() async {
    // Demander l'autorisation d'utiliser le microphone
    await _demanderAutorisationMicrophone();

    await _audioRecorder!.openAudioSession();
    setState(() {
      _enregistrementEnCours = true;
    });

    var tempDir = await getTemporaryDirectory();
    var path = '${tempDir.path}/flutter_sound.aac';

    setState(() {
      _pathEnregistrement = path;
    });

    // Commencer l'enregistrement
    await _audioRecorder!.startRecorder(
      toFile: _pathEnregistrement,
      //codec: Codec.aacADTS,
    ).catchError((error) {
      // Gérer les erreurs d'enregistrement
      print('Erreur lors de l\'enregistrement : $error');
    });
  }

  /// _arrêterEnregistrement
  Future<void> _arreterEnregistrement() async {
    await _audioRecorder!.stopRecorder();
    setState(() {
      _enregistrementEnCours = false;
    });
    final storage = FirebaseStorage.instance;
    final reference = storage.ref('messageAudio');

    // Créer un fichier à partir du chemin d'enregistrement
    final file = File(_pathEnregistrement);

// Définir le nom du fichier à télécharger
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.aac';

// Télécharger le fichier vers Firebase Storage
    final uploadTask = reference.child(fileName).putFile(file);

// Suivre la progression du téléchargement
    uploadTask.snapshotEvents.listen((snapshot) {
      final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      print('Téléchargement : $progress%');
    });

// Attendre la fin du téléchargement
    await uploadTask.whenComplete(() => print('Téléchargement terminé'));

// Obtenir l'URL du fichier téléchargé
    final url = await uploadTask.snapshot.ref.getDownloadURL();
    print('URL du fichier : $url');

  }

  /// _jouerEnregistrement
  Future<void> _jouerEnregistrement(String _pathEnregistrement) async {
    if (_pathEnregistrement.isNotEmpty) {
      // Ouvrir une session audio
      await _audioPlayer!.openAudioSession();
      // Démarrer la lecture du fichier audio
      await _audioPlayer!.startPlayer(
        fromURI: _pathEnregistrement,
      );
      setState(() {
        jouerEnregistrement = !jouerEnregistrement;
      });
    } else {
      // Afficher un message si aucun enregistrement n'a été effectué
      print('Aucun enregistrement à jouer');
    }
  }


  ///

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _audioRecorder = FlutterSoundRecorder();
    _audioPlayer = FlutterSoundPlayer();
  }

  @override
  Widget build(BuildContext context) {
    message = _messageController.text;
    //sendByMe = !sendByAdmin;
    timestamp = DateTime.now();
    String audioId = this.audioId;


    return Scaffold(
      backgroundColor: darkColor.withOpacity(0.9),
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SizedBox(

            height: appHeightSize(context) * 9,
            child: Stack(alignment: Alignment.bottomCenter, children: [
              Positioned(
                //bottom: appHeightSize(context) * 0.07,
                child: SizedBox(
                  height: appHeightSize(context) * 0.9,
                  //width: appWidthSize(context) * 0.9,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("messages")
                          .orderBy(
                            'timestamp', /*descending: true*/
                          )
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        /*if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }*/
                        List<dynamic> listMessages = [];
                        snapshot.data?.docs.forEach((element) {
                          listMessages.add(element);
                        });
                        return !snapshot.hasData || listMessages == []
                            ? Center(
                                // ignore: unnecessary_const
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // ignore: unnecessary_const
                                      Icon(
                                        Iconsax.messages_24,
                                        size: 100,
                                        color: Colors.grey[700],
                                      ),
                                      Text(
                                        'Aucun message disponible',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.only(top: .0, bottom: 13),
                                child: Container(
                                  height: appHeightSize(context),
                                  width: appWidthSize(context),
                                  margin: EdgeInsets.only(bottom: appHeightSize(context) * 0.07,),
                                  child: ListView.builder(
                                      itemCount: listMessages.length,
                                      controller: ScrollController(
                                        initialScrollOffset:
                                            listMessages.length.toDouble() *
                                                appHeightSize(context),
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final message = listMessages[index];
                                        final image = message['image'];
                                        final text = message['message'];
                                        final sendByAdmin =
                                            message['sendByAdmin'];
                                        final type = message['type'];
                                        final video = message['video'];
                                        final isRead = message['isRead'];
                                        longPressed = message['longPressed'];
                                        final date = DateFormat.yMd()
                                            .add_jm()
                                            .format(
                                                message['timestamp'].toDate());

                                          if(sendByAdmin==true){
                                            sendByMe = true;
                                          }else {
                                            sendByMe = false;
                                          }


                                        return sendByAdmin
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,),
                                                child: SizedBox(
                                                  child: Stack(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    children: [

                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 30.0),
                                                        child: MessageModel(
                                                          message: text,
                                                          sendByAdmin: sendByAdmin,
                                                          sendDate: date,
                                                          isRead: isRead,
                                                          type: type,
                                                          image: image,
                                                          longPressed: longPressed,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            bottom: 10
                                                          //right: appWidthSize(context)*0.88,
                                                          //right: appWidthSize(context)*0.88,
                                                        ),
                                                        child : Icon(
                                                          Icons.account_circle,
                                                          size: 35,
                                                          color: Colors.grey[700],
                                                        ),

                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              )
                                            : SizedBox(
                                                width:
                                                    appWidthSize(context) * 0.8,
                                                child: Stack(
                                                  alignment: Alignment.topRight,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 10.0),
                                                      child: Container(
                                                        margin: EdgeInsets.only(right: 10),
                                                        child: Text(
                                                          /// DiscussionPageModel().userName!,
                                                          'Vous',
                                                          style: TextStyle(
                                                              color:
                                                              Colors.grey[700],
                                                              fontSize:
                                                              smallText() /
                                                                  1.1),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 30.0),
                                                      child: MessageModel(
                                                        message: text,
                                                        sendByAdmin:
                                                            sendByAdmin,
                                                        sendDate: date,
                                                        isRead: isRead,
                                                        type: type,
                                                        //image: image,
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              );
                                      }),
                                ),
                              );
                      }),
                ),
              ),
              Positioned(
                bottom: appHeightSize(context) * 0.0055,
                left: 5,
                right: 0,
                child: Container(
                  //height: appHeightSize(context) * 0.075,
                  //width: appWidthSize(context) * 0.8,
                  //color: Colors.grey[700][900],
                  margin: const EdgeInsets.only(top: 20),
                  color: darkColor.withOpacity(0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Container(
                        width: MediaQuery.of(context).size.width * 0.83,
                        decoration: BoxDecoration(
                            color: Colors.black12.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30)),
                        //height: appHeightSize(context) * 0.065,
                        child: TextField(
                          controller: _messageController,
                          onTap: () {
                            setState(() {
                              emojiButtonPressed = false;
                            });
                          },
                          onChanged: (String string) {
                            setState(() {
                              messageState = string;
                              if (_messageController.text.isEmpty ||
                                  _messageController.text == '') {
                                widget.userName = 'Admin';
                              } else {
                                widget.userName = 'écrit...';
                              }
                              type = 'text';
                              emojiButtonPressed = false;
                              print('Message text');
                            });
                          },
                          style: const TextStyle(color: Colors.white),
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: SizedBox(
                                width: appWidthSize(context) * 0.2,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          emojiButtonPressed = false;
                                          type = 'image';
                                          print('Message image');
                                        });
                                        sendMessage(
                                          context,
                                          image,
                                          isRead,
                                          message,
                                          sendByAdmin,
                                          sender,
                                          timestamp,
                                          type,
                                          video,
                                          longPressed,
                                          sendByMe,
                                          sendByOther,record,
                                          messageState,
                                          widget.userName!,
                                          _pathEnregistrement,
                                            audioId,
                                        );
                                      },
                                      child: Icon(
                                        //Icons.more_vert,
                                        Icons.file_copy_outlined,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          type = 'emoji';
                                          emojiButtonPressed =
                                              !emojiButtonPressed;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.emoji_emotions,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ), 

                                  ],
                                ),
                              ),
                            ),
                        
                            hintText: "Message....",
                            hintStyle: TextStyle(
                              //color: Colors.white,
                              color: Colors.grey[600]
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  type = 'image';
                                  emojiButtonPressed = false;
                                  print('Message image');
                                });
                                _jouerEnregistrement(_pathEnregistrement);
                               /* sendMessage(
                                  context,
                                  image = 'images/chaussure.png',
                                  isRead,
                                  message,
                                  sendByAdmin,
                                  sender,
                                  timestamp,
                                  type,
                                  video,
                                  longPressed,
                                  sendByMe,
                                  sendByOther,record,
                                  messageState,
                                  widget.userName!,
                                  _pathEnregistrement,
                                    audioId
                                );*/
                              },
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[700],
                              ),
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CircleAvatar(
                            radius: appWidthSize(context) / 16,
                            backgroundColor: !record
                                ? primaryColor.withOpacity(0.9)
                                : redColor,
                            child: messageState.isEmpty || messageState == ''
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        record = !record;
                                        emojiButtonPressed = false;
                                        if (record == true) {
                                          widget.userName =
                                              'enregistrement d\'un audio...';
                                        }
                                      });
                                    },
                                    child: record == true
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                type = 'audio';
                                                record = false;
                                                _arreterEnregistrement();
                                                emojiButtonPressed = false;
                                                widget.userName = 'Admin';
                                                _pathEnregistrement = '${DateTime.now()}$_pathEnregistrement';
                                                audioId = _pathEnregistrement;
                                                print('Message audio');
                                              });

                                              sendMessage(
                                                context,
                                                image,
                                                isRead,
                                                message,
                                                sendByAdmin,
                                                sender,
                                                timestamp,
                                                type,
                                                video,
                                                longPressed,
                                                sendByMe,
                                                sendByOther,

                                                record,
                                                messageState,
                                                  widget.userName!,
                                                  _pathEnregistrement,
                                                  audioId,
                                              );
                                            },
                                            child: Lottie.asset('animations/lotties/audioRecording.json')

                                      /*const Icon(
                                              Icons.pause_circle_outline,
                                              color: Colors.white,
                                              size: 40,
                                            ),*/
                                          )
                                        : GestureDetector(
                                      onTap: (){
                                        _commencerEnregistrement(); record = true;
                                      },
                                          child: const Icon(
                                              Icons.mic,
                                              color: Colors.white,
                                            ),
                                        ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      sendMessage(
                                        context,
                                        image,
                                        isRead,
                                        message,
                                        sendByAdmin,
                                        sender,
                                        timestamp,
                                        type,
                                        video,
                                        longPressed,
                                        sendByMe,
                                        sendByOther,
                                        record,
                                        messageState,
                                          widget.userName!,
                                          _pathEnregistrement,
                                          audioId
                                      );
                                      setState(() {
                                        messageState = '';
                                        messageState.isEmpty;
                                        _messageController.text = '';
                                        record = false;
                                        emojiButtonPressed = false;
                                        widget.userName = 'Admin';
                                      });
                                    },
                                    child: const Icon(
                                      Icons.send,
                                      //Icons.telegram_sharp,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  )),
                      )
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
      floatingActionButton: emojiButtonPressed == true
          ? Container(
              height: appHeightSize(context) * 0.25,
              width: appWidthSize(context) * 0.55,
              margin: EdgeInsets.only(
                  left: appWidthSize(context) * 0.15,
                  bottom: appHeightSize(context) * 0.04),
              decoration: BoxDecoration(
                  color: darkColor.withOpacity(0.95),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  border: Border.all(color: Colors.grey.withOpacity(0.5))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: appWidthSize(context) * 0.5,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          Get.back();
                          emojiButtonPressed = false;
                        });
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 35,
                          ),
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 30,
                          ),
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 25,
                          ),
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 15,
                          ),
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 10,
                          ),
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 5,
                          ),
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 2,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: appWidthSize(context) * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                emojiButtonPressed = false;
                                sendMessage(
                                    context,
                                    image,
                                    isRead,
                                    '🙏',
                                    sendByAdmin,
                                    sender,
                                    timestamp,
                                    type = 'emoji',
                                    video,
                                    longPressed,
                                  sendByMe,
                                  sendByOther,
                                  record,
                                  messageState,
                                    widget.userName!,
                                    _pathEnregistrement,
                                    audioId
                                );











                              });
                            },
                            child: _emojiList[0]),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                emojiButtonPressed = false;
                                sendMessage(
                                    context,
                                    image,
                                    isRead,
                                    '😀',
                                    sendByAdmin,
                                    sender,
                                    timestamp,
                                    type = 'emoji',
                                    video,
                                    longPressed,
                                  sendByMe,
                                  sendByOther,
                                  record,
                                  messageState,
                                    widget.userName!,
                                    _pathEnregistrement,
                                    audioId
                                );
                              });
                            },
                            child: _emojiList[1]),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                emojiButtonPressed = false;
                                sendMessage(
                                    context,
                                    image,
                                    isRead,
                                    '😥',
                                    sendByAdmin,
                                    sender,
                                    timestamp,
                                    type = 'emoji',
                                    video,
                                    longPressed,
                                  sendByMe,
                                  sendByOther,
                                  record,
                                  messageState,
                                    widget.userName!,
                                    _pathEnregistrement,
                                    audioId
                                );
                              });
                            },
                            child: _emojiList[2])
                      ],
                    ),
                  ),
                  SizedBox(
                    width: appWidthSize(context) * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                emojiButtonPressed = false;
                                sendMessage(
                                    context,
                                    image,
                                    isRead,
                                    '🤔',
                                    sendByAdmin,
                                    sender,
                                    timestamp,
                                    type = 'emoji',
                                    video,
                                    longPressed,
                                  sendByMe,
                                  sendByOther,
                                  record,
                                  messageState,
                                    widget.userName!,
                                    _pathEnregistrement,
                                    audioId
                                );
                              });
                            },
                            child: _emojiList[3]),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                emojiButtonPressed = false;
                                sendMessage(
                                    context,
                                    image,
                                    isRead,
                                    '❤️',
                                    sendByAdmin,
                                    sender,
                                    timestamp,
                                    type = 'emoji',
                                    video,
                                    longPressed,
                                  sendByMe,
                                  sendByOther,
                                  record,
                                  messageState,
                                    widget.userName!,
                                    _pathEnregistrement,
                                    audioId
                                );
                              });
                            },
                            child: _emojiList[4]),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                emojiButtonPressed = false;
                                sendMessage(
                                    context,
                                    image,
                                    isRead,
                                    '👍',
                                    sendByAdmin,
                                    sender,
                                    timestamp,
                                    type = 'emoji',
                                    video,
                                    longPressed,
                                  sendByMe,
                                  sendByOther,
                                  record,
                                  messageState,
                                    widget.userName!,
                                    _pathEnregistrement,
                                    audioId
                                );
                              });
                            },
                            child: _emojiList[5])
                      ],
                    ),
                  ),
                  SizedBox(
                    width: appWidthSize(context) * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                emojiButtonPressed = false;
                                sendMessage(
                                    context,
                                    image,
                                    isRead,
                                    '️🥰',
                                    sendByAdmin,
                                    sender,
                                    timestamp,
                                    type = 'emoji',
                                    video,
                                    longPressed,
                                  sendByMe,
                                  sendByOther,
                                  record,
                                  messageState,
                                    widget.userName!,
                                    _pathEnregistrement,
                                    audioId
                                );
                              });
                            },
                            child: _emojiList[6]),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                emojiButtonPressed = false;
                                sendMessage(
                                    context,
                                    image,
                                    isRead,
                                    '😳',
                                    sendByAdmin,
                                    sender,
                                    timestamp,
                                    type = 'emoji',
                                    video,
                                    longPressed,
                                  sendByMe,
                                  sendByOther,
                                  record,
                                  messageState,
                                  widget.userName!,
                                  _pathEnregistrement,
                                    audioId
                                );
                              });
                            },
                            child: _emojiList[7]),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                emojiButtonPressed = false;
                                sendMessage(
                                    context,
                                    image,
                                    isRead,
                                    message = '👏',
                                    sendByAdmin,
                                    sender,
                                    timestamp,
                                    type = 'emoji',
                                    video,
                                    longPressed,
                                  sendByMe,
                                  sendByOther,
                                    record,
                                    messageState,
                                    widget.userName!,
                                    _pathEnregistrement,
                                    audioId
                                );
                              });
                            },
                            child: _emojiList[8])
                      ],
                    ),
                  ),
                ],
              ),
            )
          : GestureDetector(
              onTap: () {
                setState(() {
                  emojiButtonPressed = true;
                });
              },
              child: const SizedBox(
                height: 1,
                width: 1,
              )),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

void sendMessage(
    BuildContext context,
    String image,
    bool isRead,
    String message,
    bool sendByAdmin,
    String sender,
    DateTime timestamp,
    String type,
    String video,
    bool longPressed,
    bool sendByMe,
    bool sendByOther,
bool record,
String messageState,
String userName,
String _pathEnregistrement,
String audioId,
    ) {
  if ((message.isEmpty || message == '') && type == 'text') {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Vous ne pouvez pas envoyer un message vide"),
      backgroundColor: redColor,
      duration: const Duration(seconds: 6),
    ));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //width: appWidthSize(context) / 3,
      //margin: EdgeInsets.only(right: 40, left: 40),
      content: Center(
          child: Container(
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: type == 'text'
                  ? const Text("Message envoyé")
                  : type == 'audio'
                      ? const Text("Audio envoyé")
                      : type == 'emoji'
                          ? const Text("Emoji envoyé")
                          : const Text("Image envoyé"))),
      backgroundColor: Colors.grey[700]/*.withOpacity(0.5)*/,
      //padding: const EdgeInsets.all(8.0),
      duration: const Duration(seconds: 1),
    ));

    FocusScope.of(context).requestFocus(FocusNode());

    //ajout à la base de données
    CollectionReference messageRef =
        FirebaseFirestore.instance.collection('messages');

    messageRef.add({
      'image': image,
      'isRead': isRead,
      'message': message,
      'sendByAdmin': sendByAdmin,
      'sender': sender,
      'timestamp': timestamp,
      'type': type,
      'video': video,
      'longPressed': longPressed,
      //'sendByMe' : sendByMe,
      'sendByOther' : sendByOther,
      'record':record,
      'messageState':messageState,
      'userName':userName,
      'pathEnregistrement' : _pathEnregistrement,
      'audioId' : audioId
    });
  }
}

void infoMessage(BuildContext context, bool info, MessageModel Message) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const InfoMessagePage(/*Message: Message*/)));
}
