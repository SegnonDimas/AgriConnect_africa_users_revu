import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cons.dart';

//AppBar
class APPBARME {
  static String nom = 'User';

  static Widget Entete(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0, left: 10, right: 10),
      child: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(Icons.chevron_left_rounded),
                  Text(
                    "Retour",
                    style: GoogleFonts.kadwa(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Text(
              "Y",
              style: GoogleFonts.windSong(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: PRIMARY_COLOR),
            ),
            Text(
              "Bonjour ${nom} !",
              style: GoogleFonts.kadwa(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
    //FinAppBar
  }

  static Widget Enbas(BuildContext context, double prix, double x, bool click,
      VoidCallback? voidCallback) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 100,
      decoration: BoxDecoration(
          //color: SECONDARY_COLOR,
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      )),
      padding: EdgeInsets.only(left: 13, right: 13),
      child: Column(children: [
        Icon(
          Icons.horizontal_rule,
          color: Colors.grey,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "TOTAL H.T : ${prix}\$ CAD",
                  style: GoogleFonts.kadwa(
                      fontWeight: FontWeight.bold, fontSize: 10),
                ),
                '${prix * x}'.split('.').last.length > 2
                    ? Text(
                        "TPS/TPQ : " +
                            "${prix * x}".split(".").first +
                            "." +
                            "${prix * x}".split(".").last.substring(0, 2) +
                            " \$ CAD",
                        style: GoogleFonts.kadwa(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      )
                    : Text(
                        "TPS/TSQ : " + "${prix * x}\$ CAD",
                        style: GoogleFonts.kadwa(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                '${prix + prix * x}'.split('.').last.length > 2
                    ? Text(
                        "TOTAL TTC : " +
                            "${prix + prix * x}".split(".").first +
                            "." +
                            "${prix + prix * x}"
                                .split(".")
                                .last
                                .substring(0, 2) +
                            " \$ CAD",
                        style: GoogleFonts.kadwa(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      )
                    : Text(
                        "TOTAL TTC : " + "${prix + prix * x}\$ CAD",
                        style: GoogleFonts.kadwa(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      ),
              ],
            ),
            click
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR),
                    onPressed: voidCallback,
                    child: Text(
                      'Suivant',
                      style: GoogleFonts.kadwa(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ))
                : ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Suivant',
                      style: GoogleFonts.kadwa(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ))
          ],
        )
      ]),
    );
  }
}
