import 'package:agribenin/Page/app_colors.dart';
import 'package:agribenin/Page/chat/discussionPageModel.dart';
import 'package:agribenin/Page/chat/userProfil.dart';
import 'package:agribenin/Page/screen/text_sizes.dart';
import 'package:agribenin/Page/styles/messageModel.dart';
import 'package:flutter/material.dart';

class DiscussionPage extends StatefulWidget {
  const DiscussionPage({super.key});

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkColor,
        foregroundColor: secondaryColor,
        centerTitle: true,

        leading: const Icon(
          Icons.account_circle,
          //color: primaryColor,
          size: 35,
        ),
        title: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserProfilPage()));
          },
          child: Text(
            DiscussionPageModel().userName!,
            style: TextStyle(
              fontSize: mediumText() * 0.9,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserProfilPage()));
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_forward_ios,
                //color: Colors.white,
              ),
            ),
          )
        ],
        //centerTitle: true,
      ),
      body: DiscussionPageModel(),
    );


  }
}
