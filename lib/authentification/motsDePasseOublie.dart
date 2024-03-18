import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MotDePasseOublie extends StatefulWidget {
  const MotDePasseOublie({super.key});

  @override
  State<MotDePasseOublie> createState() => _MotDePasseOublieState();
}

class _MotDePasseOublieState extends State<MotDePasseOublie> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Mot de passe oublié ?',
          style: GoogleFonts.kadwa(fontSize: 12),
        ),
      ),
    );
  }
}
