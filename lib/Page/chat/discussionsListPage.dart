
import 'package:agribenin/Page/app_colors.dart';
import 'package:agribenin/Page/screen/app_sizes.dart';
import 'package:agribenin/Page/screen/text_sizes.dart';
import 'package:agribenin/Page/styles/appTexts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiscussionsListPage extends StatefulWidget {
  const DiscussionsListPage({super.key});

  @override
  State<DiscussionsListPage> createState() => _DiscussionsListPageState();
}

class _DiscussionsListPageState extends State<DiscussionsListPage> {
  @override
  Widget build(BuildContext context) {
    double appWidth = appWidthSize(context);
    double appHeight = appHeightSize(context);
    int _currentIndex = 0;

    List<Widget> _userList = [
      Column(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("utilisateurs")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                List<dynamic> listDiscussions = [];
                snapshot.data?.docs.forEach((element) {
                  listDiscussions.add(element);
                });
                return !snapshot.hasData
                    ? const Center(
                        // ignore: unnecessary_const
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ignore: unnecessary_const
                            Icon(
                              Icons.type_specimen_outlined,
                              size: 100,
                              color: Colors.grey,
                            ),
                            Text(
                              'Pas encore d\'utilisateurs',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                            itemCount: listDiscussions.length,
                            itemBuilder: (BuildContext context, int index) {
                              final message = listDiscussions[index];
                              final image = message['image'];
                              final text = message['message'];
                              final sendByAdmin = message['sendByAdmin'];
                              final type = message['type'];
                              final video = message['video'];
                              final isRead = message['isRead'];
                              final date = DateFormat.yMd()
                                  .add_jm()
                                  .format(message['timestamp'].toDate());
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: appHeight * 0.11,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.withOpacity(0.4),
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        bottomRight: Radius.circular(25),
                                        bottomLeft: Radius.circular(25)),
                                    //border: Border.all(color: Colors.black)
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                          backgroundColor:
                                              primaryColor.withOpacity(0.3),
                                          radius: 30,
                                          child: Icon(
                                            Icons.account_circle,
                                            size: 60,
                                            color:
                                                Colors.white.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                                text: 'nom' + ' ' + 'prenom',
                                                color: primaryColor,
                                                size: largeText() / 1.2,
                                                bold: true,
                                                justify: false,
                                                center: false),
                                            AppText(
                                                text: 'Commune: + ',
                                                color: Colors.grey,
                                                size: mediumText() / 1.3,
                                                bold: true,
                                                justify: false,
                                                center: false),
                                            AppText(
                                                text: 'Langue: langue',
                                                color: Colors.grey,
                                                size: mediumText() / 1.3,
                                                bold: true,
                                                justify: false,
                                                center: false),
                                            SizedBox(
                                              width: appWidth * 0.65,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  AppText(
                                                      text: 'Tel: numero',
                                                      color: Colors.grey,
                                                      size: mediumText() / 1.3,
                                                      bold: true,
                                                      justify: false,
                                                      center: false),
                                                  const Icon(
                                                    Icons
                                                        .verified_user_outlined,
                                                    color: Colors.green,
                                                    size: 18,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
              }),
        ],
      ),
    ];
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: darkColor,
        body: SizedBox(
          width: appWidth,
          height: appHeight,
          child: Column(
            children: [
              Expanded(
                child: TabBarView(children: _userList),
              )
            ],
          ),
        ),
      ),
    );
  }
}
