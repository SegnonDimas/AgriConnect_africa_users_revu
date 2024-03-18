import 'package:agribenin/Page/app_colors.dart';
import 'package:agribenin/Page/screen/app_sizes.dart';
import 'package:agribenin/Page/screen/text_sizes.dart';
import 'package:flutter/material.dart';

class UserProfilPage extends StatefulWidget {
  const UserProfilPage({super.key});

  @override
  State<UserProfilPage> createState() => _UserProfilPageState();
}

class _UserProfilPageState extends State<UserProfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: darkColor,
        title: const Text('Profil'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(
                height: appHeightSize(context) * 0.25,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Icon(
                        Icons.account_circle,
                        color: primaryColor,
                        size: 100,
                      ),
                    ),
                    Text(
                      'UserName',
                      style: TextStyle(
                          color: secondaryColor, fontSize: largeText()),
                    ),
                  ],
                ),
              ),
              const Divider(),
              SizedBox(
                width: appWidthSize(context) * 0.95,
                height: appHeightSize(context) * 0.11,
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: secondaryColor,
                  ),
                  title: Text('Username',
                      style: TextStyle(
                          color: Colors.white, fontSize: mediumText())),
                  subtitle: Text(
                    'Adresse : Commune/Pays',
                    style: TextStyle(color: Colors.grey, fontSize: smallText()),
                  ),
                ),
              ),
              SizedBox(
                width: appWidthSize(context) * 0.95,
                height: appHeightSize(context) * 0.11,
                child: ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: secondaryColor,
                  ),
                  title: Text('Téléphone',
                      style: TextStyle(
                          color: Colors.white, fontSize: mediumText())),
                  subtitle: Text('Tel : +229 99255879',
                      style:
                          TextStyle(color: Colors.grey, fontSize: smallText())),
                  trailing: CircleAvatar(
                      backgroundColor: primaryColor,
                      radius: 15,
                      child: const Icon(
                        Icons.call,
                        color: Colors.white,
                        size: 18,
                      )),
                ),
              ),
              SizedBox(
                width: appWidthSize(context) * 0.95,
                height: appHeightSize(context) * 0.11,
                child: ListTile(
                  leading: Icon(
                    Icons.record_voice_over_sharp,
                    color: secondaryColor,
                  ),
                  title: Text('Langue',
                      style: TextStyle(
                          color: Colors.white, fontSize: mediumText())),
                  subtitle: Text('Langue : Fon',
                      style:
                          TextStyle(color: Colors.grey, fontSize: smallText())),
                ),
              ),
              SizedBox(
                width: appWidthSize(context) * 0.95,
                height: appHeightSize(context) * 0.11,
                child: ListTile(
                  leading: Icon(
                    Icons.volunteer_activism,
                    color: secondaryColor,
                  ),
                  title: Text('Sous-secteurs',
                      style: TextStyle(
                          color: Colors.white, fontSize: mediumText())),
                  subtitle: Text('Secteurs :  : Élevage, Transformation',
                      style:
                          TextStyle(color: Colors.grey, fontSize: smallText())),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
