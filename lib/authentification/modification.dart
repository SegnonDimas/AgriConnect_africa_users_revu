import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../constants/cons.dart';
import '../widget/champTemplate.dart';

class Modification extends StatefulWidget {
  const Modification({super.key});

  @override
  State<Modification> createState() => _ModificationState();
}

class _ModificationState extends State<Modification> {
  File? photopath;
  String? photoname;
  String? photodata;
  ImagePicker imagePicker = ImagePicker();

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Modifier mon profil',
          style: GoogleFonts.kadwa(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 200,
                  height: 100,
                  child: Image.asset(
                    "images/agri.png",
                    fit: BoxFit.fitWidth,
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 155,
                child: Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(75),
                        ),
                        image: photopath == null
                            ? DecorationImage(
                                image: AssetImage(
                                  "images/logo.jpg",
                                ),
                              )
                            : DecorationImage(
                                image: FileImage(photopath!),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          getImage();
                        },
                        child: CircleAvatar(
                          backgroundColor: PRIMARY_COLOR,
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              component2(
                'Valider',
                2.6,
                () async {
                  print('Modifier');
                },
              ),
            ],
          ),
          SizedBox(
            height: 35,
          ),
        ],
      ),
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
          width: size.width - 36,
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
}
