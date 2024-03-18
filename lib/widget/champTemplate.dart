import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ComponentTextFormField {
  IconData icon;
  String placehoder;
  bool isPassword;
  bool isEmail;
  ComponentTextFormField(
      {required this.icon,
      required this.placehoder,
      required this.isPassword,
      required this.isEmail});
  final TextEditingController valu = TextEditingController();
  Widget textformfield(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 50,
      width: this.isPassword ? size.width / 1.5 : size.width / 1.22,
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: size.width / 30),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        style: GoogleFonts.kadwa(
            fontSize: 14, color: Colors.black.withOpacity(.8)),
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        controller: valu,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.black.withOpacity(.7),
          ),
          border: InputBorder.none,
          hintMaxLines: 1,
          hintText: placehoder,
          hintStyle: GoogleFonts.kadwa(
              fontSize: 14, color: Colors.black.withOpacity(.5)),
        ),
      ),
    );
  }

  String get val {
    return valu.text;
  }

  void cleaner() {
    valu.clear();
  }
}
