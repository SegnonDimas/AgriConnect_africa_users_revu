import 'package:agribenin/Page/app_colors.dart';
import 'package:agribenin/Page/chat/imageViewerPage.dart';
import 'package:agribenin/Page/chat/infoMessagePage.dart';
import 'package:agribenin/Page/screen/app_sizes.dart';
import 'package:agribenin/Page/screen/text_sizes.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class MessageModel extends StatefulWidget {
  final bool? sendByAdmin; //variable pour vérifier si le message est envoyé par un administrateur ou pas
  final bool? isMessageText; // pour vérifier si le message envoyé est un texte
  final String? message; // le texte du message (si le message est un message texte)
  final String type; // le type de message (texte/audio/image/vidéo)
  final String? image; // l'url de l'image (si le message est un message image)
  final String? video; // l'url de la vidéo (si le message est un message vidéo)
  final String sendDate; // la date d'envoie du message
  final String? sender; // l'émetteur du message
  final String? receiver; //le récepteur du message
  final bool isRead; // pour vérifier si le message est lu ou pas
  bool? sendByMe; // pour vérifier si c'est moi qui ai envoyé le massage ou une autre personne
  final bool sendByOther; // pour vérifier si c'est une autre personne qui a envoyé le massage ou pas
  bool? isPlaying; // pour vérifier si l'audio ou la vidéo est en train d'être joué
  bool longPressed; // pour voir s'il y a un appui long sur un message ou pas (si oui, les réactions s'activent pour le message en question)
  bool? info; // pour voir si on veut avoir d'info sur le message (lorsqu'on appui sur les 3 points d'en haut)

  MessageModel({
    super.key,
    this.sendByMe = true,
    this.isMessageText = true,
    this.message = ' Votre message ici',
    this.type = 'text',
    this.isRead = true,
    this.image = 'images/imageTest.png',
    this.video,
    this.isPlaying = false,
    this.longPressed = false,
    this.info = false,
    required this.sendDate,
    this.sendByAdmin = false,
    this.sendByOther = false,
    this.sender,
    this.receiver,
  });

  @override
  State<MessageModel> createState() => _MessageModelState();
}

class _MessageModelState extends State<MessageModel> {
  late Color playingColor;
  double sliderValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playingColor = Colors.white;
  }

  final List<Widget> _emojiList = const <Widget>[
    Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '🙏',
      ),
    ),
    Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '😀',
      ),
    ),
    Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '😥',
      ),
    ),
    Padding(
      padding: EdgeInsets.all(8.0),
      child: Text('🤔'),
    ),
    Padding(
      padding: EdgeInsets.all(8.0),
      child: Text('❤️'),
    ),
    Padding(
      padding: EdgeInsets.all(8.0),
      child: Text('👍'),
    ),
    Padding(
      padding: EdgeInsets.all(8.0),
      child: Text('🥰'),
    ),
    Padding(
      padding: EdgeInsets.all(8.0),
      child: Text('😳'),
    ),
  ];

  bool emojiIsSelected = false;
  int index = 0;

  int selectedEmoji(int _index) {
    emojiIsSelected = true;
    index = _index;
    return index;
  }

  bool seeMore = false;

  @override
  Widget build(BuildContext context) {
    double appHeight = appHeightSize(context);
    double appWidth = appWidthSize(context);
     widget.sendByMe = !widget.sendByAdmin!;



    return GestureDetector(
      onLongPress: () {
        setState(() {
          widget.longPressed = !widget.longPressed;
          seeMore = false;
        });
      },
      onTap: () {
        setState(() {
          widget.longPressed = false;
          seeMore = false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Stack(
          alignment: emojiIsSelected && widget.sendByMe!
              ? Alignment.bottomRight
              : Alignment.bottomLeft,
          children: [
            Container(
              //alignment: Alignment.topLeft,
              alignment: widget.sendByMe!
                  ? Alignment.topRight
                  : seeMore && !widget.sendByMe! && widget.type == 'emoji'
                      ? Alignment.topRight
                      : Alignment.topLeft,
              width: appWidth * 0.8,
              margin: widget.sendByMe! && widget.type != 'emoji'
                  ? EdgeInsets.only(
                      left: appWidth / 7,
                    )
                  : widget.sendByMe! && widget.type == 'emoji'
                      ? seeMore == true
                          ? EdgeInsets.only(left: appWidth / 7)
                          : EdgeInsets.only(
                              left: appWidth / 2.2,
                            )
                      : widget.sendByMe == false && widget.type == 'emoji'
                          ? seeMore == true
                              ? EdgeInsets.only(right: appWidth / 5)
                              : EdgeInsets.only(
                                  right: appWidth / 2.1,
                                )
                          : EdgeInsets.only(
                              right: appWidth / 8,
                            ),
              //height: 100,
              decoration: widget.sendByMe == true && widget.type != 'emoji'
                  ? BoxDecoration(
                      color: primaryColor.withOpacity(0.68),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(25),
                      ),
                      //border: Border.all(color: Colors.grey)
                    )
                  : widget.sendByMe == false && widget.type != 'emoji'
                      ? const BoxDecoration(
                          color: CupertinoColors.systemGrey,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(30),
                          ),
                          //border: Border.all(color: primaryColor)
                        )
                      : widget.sendByMe == true && widget.type == 'emoji'
                          ? BoxDecoration(
                              color: primaryColor.withOpacity(0.15),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(25),
                              ),
                              //border: Border.all(color: Colors.grey)
                            )
                          : BoxDecoration(
                              color: Colors.grey.withOpacity(0.15),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(30),
                              ),
                              //border: Border.all(color: primaryColor)
                            ),
              child: Padding(
                padding: widget.type == 'image'
                    ? const EdgeInsets.only(
                        top: 5.0, left: 7.0, right: 7.0, bottom: 20)
                    : widget.type != 'audio'
                        ? const EdgeInsets.only(
                            top: 1, right: 10, left: 15, bottom: 10)
                        : widget.type == 'emoji'
                            ? !widget.sendByMe!
                                ? const EdgeInsets.only(
                                    top: 1, right: 5, left: 5, bottom: 10)
                                : const EdgeInsets.only(
                                    top: 1, right: 5, left: 5, bottom: 10)
                            : const EdgeInsets.only(
                                top: 10, right: 15, left: 10, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.type == 'text' || widget.type == 'emoji'
                        ? Column(
                            children: [
                              Stack(
                                /*alignment: widget.sendByMe!
                                    ? AlignmentDirectional.topEnd
                                    : AlignmentDirectional.topStart,*/
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 25.0),
                                    child: !widget.sendByMe! &&
                                            widget.type == 'emoji'
                                        ? Row(
                                            mainAxisAlignment: seeMore
                                                ? MainAxisAlignment.spaceBetween
                                                : MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 0.15,
                                                height: 0.1,
                                              ),
                                              Text(
                                                //textAlign: widget.sendByMe! ? TextAlign.right: TextAlign.left,
                                                textAlign: seeMore &&
                                                        !widget.sendByMe!
                                                    ? TextAlign.right
                                                    : TextAlign.left,
                                                widget.message!,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      widget.type != 'emoji'
                                                          ? mediumText() * 0.9
                                                          : largeText() * 3,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            //textAlign: widget.sendByMe! ? TextAlign.right: TextAlign.left,
                                            /* textAlign: !widget.sendByMe!
                                                ? TextAlign.right
                                                : TextAlign.left,*/
                                            widget.message!,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: widget.type != 'emoji'
                                                  ? mediumText() * 0.9
                                                  : largeText() * 3,
                                            ),
                                          ),
                                  ),
                                  Row(
                                    mainAxisAlignment: widget.sendByMe!
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      //Container(),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            seeMore = true;
                                            widget.longPressed = false;
                                          });
                                        },
                                        child: !seeMore
                                            ? Icon(
                                                Icons.more_horiz_rounded,
                                                color: widget.sendByMe!
                                                    ? Colors.black54
                                                    : widget.type == 'emoji'
                                                        ? Colors.black54
                                                        : Colors.black54,
                                              )
                                            : Container(
                                                margin: widget.sendByMe!
                                                    ? EdgeInsets.only(
                                                        left: appWidth / 4)
                                                    : EdgeInsets.only(
                                                        right: appWidth / 5),
                                                width: appWidth * 0.4,
                                                height: appHeight * 0.16,
                                                decoration: BoxDecoration(
                                                    color: Colors.black54
                                                        /*.withOpacity(0.92)*/,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: ListView(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 12.0,
                                                              left: 12.0),
                                                      child: SizedBox(
                                                        width: appWidth * 0.10,
                                                        //height: appHeight*0.15,
                                                        child: const Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Icon(
                                                                Icons.copy,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10.0),
                                                                child: Text(
                                                                  'Copier',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                              ),
                                                            ]),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            widget.info = true;
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const InfoMessagePage()));
                                                          });
                                                        },
                                                        child: SizedBox(
                                                          width:
                                                              appWidth * 0.15,
                                                          //height: appHeight*0.15,
                                                          child: const Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .info_outline,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10.0),
                                                                  child: Text(
                                                                    'Infos',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 12.0,
                                                              left: 12.0),
                                                      child: SizedBox(
                                                        width: appWidth * 0.10,
                                                        //height: appHeight*0.15,
                                                        child: const Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .delete_outlined,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10.0),
                                                                child: Text(
                                                                  'Supprimer',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              ),
                                                            ]),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )
                        : widget.type == 'image'
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ImageViewerPage(
                                                imagePath: widget.image!,
                                              )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Container(
                                    height: appHeight * 0.3,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: widget.sendByMe!
                                          ? const BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                            )
                                          : const BorderRadius.only(
                                              topRight: Radius.circular(25),
                                            ),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        //scale: 0.01,
                                        image: AssetImage(widget.image!),
                                        //fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : widget.type == 'audio'
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 3.0, top: 2.0),
                                    child: SizedBox(
                                      height: appHeight * 0.06,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: appWidth * 0.5,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (widget.isPlaying ==
                                                          false) {
                                                        widget.isPlaying = true;
                                                        playingColor =
                                                            Colors.blue;
                                                      } else {
                                                        widget.isPlaying =
                                                            false;
                                                        //playingColor = Colors.blue;
                                                      }
                                                    });
                                                  },
                                                  child: widget.isPlaying!
                                                      ? Icon(
                                                          Icons.pause,
                                                          color: playingColor,
                                                          size: 35,
                                                        )
                                                      : Padding(
                                                        padding: const EdgeInsets.only(right: 8.0),
                                                        child: Icon(
                                                            Icons
                                                                .play_arrow_rounded,
                                                            color: playingColor,
                                                            size: 35,
                                                          ),
                                                      ),
                                                ),
                                                widget.isPlaying!? SizedBox(
                                                  width: appWidth * 0.35,
                                                  height: appHeight * 0.05,
                                                  child: Lottie.asset(
                                                    'animations/lotties/audioPlaying.json',
                                                    width: appWidth * 0.4,
                                                    height: appHeight * 0.06,
                                                    fit: BoxFit.fill, // Utilisez BoxFit.fill pour remplir la boîte de taille spécifiée
                                                  ),
                                                )

                                                    : Expanded(
                                                  child: SliderTheme(
                                                    data: const SliderThemeData(
                                                        thumbShape:
                                                            RoundSliderThumbShape(
                                                                enabledThumbRadius:
                                                                    6)),
                                                    child: Slider(
                                                      value: sliderValue,
                                                      max: 10,
                                                      min: 0,
                                                      onChanged:
                                                          (double valeur) {
                                                        setState(() {
                                                          sliderValue = valeur;
                                                        });
                                                      },
                                                      activeColor: playingColor,
                                                      inactiveColor:
                                                          Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              width: appWidth / 10,
                                              child: Icon(
                                                Icons.account_circle,
                                                size: 35,
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                              )
                                              //secondaryColor),
                                              ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                    Padding(
                      padding: widget.sendByMe!
                          ? const EdgeInsets.only(
                              top: 2,
                              left: 10,
                            )
                          : const EdgeInsets.only(
                              top: 2,
                              right: 10,
                            ),
                      child: widget.sendByMe! /*&& widget.type != 'emoji'*/
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.sendDate,
                                  style: widget.type != 'emoji'
                                      ? TextStyle(
                                          fontSize: smallText() * 1,
                                          color: Colors.black45)
                                      : TextStyle(
                                          fontSize: smallText() * 0.7,
                                          color: Colors.black54),
                                ),
                                widget.sendByMe!
                                    ? widget.isRead == false &&
                                            widget.type != 'emoji'
                                        ? SizedBox(
                                            width: appWidth / 7,
                                            child: const Row(
                                              children: [
                                                Icon(
                                                  Icons.done_all,
                                                  color: Colors.black45,
                                                  size: 15,
                                                ),
                                                Text(
                                                  'Envoyé',
                                                  style: TextStyle(
                                                      color: Colors.black26,
                                                      fontSize: 9),
                                                ),
                                              ],
                                            ),
                                          )
                                        : widget.type == 'emoji'
                                            ? SizedBox(
                                                width: appWidth / 12,
                                                child: const Icon(
                                                  Icons.done_all,
                                                  color: Colors.black54,
                                                  size: 18,
                                                ),
                                              )
                                            : SizedBox(
                                                width: appWidth / 13,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.done_all,
                                                      color:
                                                          Colors.lightBlue[200],
                                                      size: 15,
                                                    ),
                                                    const Text(
                                                      'Lu',
                                                      style: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 9),
                                                    ),
                                                  ],
                                                ),
                                              )
                                    : Container()
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(),
                                Text(
                                  widget.sendDate,
                                  style: widget.type == 'emoji'
                                      ? TextStyle(
                                          fontSize: smallText() * 0.7,
                                          color: Colors.black54)
                                      : TextStyle(
                                          fontSize: smallText() * 1,
                                          color: Colors.black45),
                                ),
                              ],
                            ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: widget.longPressed
                  ? Container(
                      alignment: Alignment.bottomCenter,
                      height: appHeight * 0.06,
                      width: appWidth * 0.78,
                      margin: widget.sendByMe!
                          ? const EdgeInsets.only(
                              left: 53,
                            )
                          : const EdgeInsets.only(
                              right: 53,
                            ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: darkColor.withOpacity(0.8),
                      ),
                      child: Center(
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            itemCount: _emojiList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedEmoji(index);
                                      widget.longPressed = false;
                                    });
                                  },
                                  child: _emojiList[index]);
                            }),
                      ),
                    )
                  : emojiIsSelected
                      ? Container(
                          //margin: EdgeInsets.only(top: 50),
                          decoration: BoxDecoration(
                            color: darkColor.withOpacity(0.8),
                            //color: Colors.teal,
                            borderRadius: BorderRadius.circular(100),
                            //border: Border.all(color: Colors.white)
                          ),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  emojiIsSelected = false;
                                });
                              },
                              child: _emojiList[selectedEmoji(index)]),
                        )
                      : Container(),
            )
          ],
        ),
      ),
    );
  }
}
