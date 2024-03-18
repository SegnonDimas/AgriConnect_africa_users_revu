import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/cons.dart';

class WidgetSMS extends StatefulWidget {
  bool sender;
  String sms;
  String? name;
  String? prename;
  bool? onAdmin = false;

  WidgetSMS(
      {required this.sender,
      required this.sms,
      this.name = "NA",
      this.onAdmin = false,
      this.prename = "Pr"});

  @override
  State<WidgetSMS> createState() => _WidgetSMSState();
}

class _WidgetSMSState extends State<WidgetSMS> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    bool isSender = widget.sender;
    Color containerColor = isSender ? PRIMARY_COLOR : Colors.white;
    Color textColor = isSender ? Colors.white : Colors.black;
    CrossAxisAlignment crossAxisAlignment =
        isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    BorderRadius borderRadius = isSender
        ? BorderRadius.only(
            bottomLeft: Radius.circular(10),
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          )
        : BorderRadius.only(
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          );

    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isSender
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  constraints: BoxConstraints(maxWidth: size.width * 0.7),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: borderRadius,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      widget.sms,
                      style: GoogleFonts.kadwa(
                        color: textColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              )
            : widget.onAdmin!
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(
                            "${widget.name![0]}${widget.prename![0]}",
                            style: GoogleFonts.kadwa(color: PRIMARY_COLOR),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              constraints:
                                  BoxConstraints(maxWidth: size.width * 0.65),
                              decoration: BoxDecoration(
                                color: containerColor,
                                borderRadius: borderRadius,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.sms,
                                  style: GoogleFonts.kadwa(
                                    color: textColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage("images/agri.png"),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AgriConnect Africa',
                              style: GoogleFonts.kadwa(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              constraints:
                                  BoxConstraints(maxWidth: size.width * 0.65),
                              decoration: BoxDecoration(
                                color: containerColor,
                                borderRadius: borderRadius,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.sms,
                                  style: GoogleFonts.kadwa(
                                    color: textColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
      ],
    );
  }
}
