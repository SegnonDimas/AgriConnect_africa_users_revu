import 'package:flutter/material.dart';

class AppText extends StatefulWidget {
  final String text;
  Color color;
  double size;
  bool bold;
  bool justify;
  bool center;
  bool? overflow;
  int? maxLines;

  AppText(
      {super.key,
      required this.text,
      required this.color,
      required this.size,
      required this.bold,
      required this.justify,
      required this.center,
      this.overflow = false,
      this.maxLines = 3
      });

  @override
  State<AppText> createState() => _AppTextState();
}

class _AppTextState extends State<AppText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      maxLines: widget.maxLines,
      style: TextStyle(
          color: widget.color,
          fontSize: widget.size,
          fontWeight:
              widget.bold == true ? FontWeight.bold : FontWeight.normal),
      textAlign: widget.justify
          ? TextAlign.justify
          : widget.center
              ? TextAlign.center
              : TextAlign.left,
      overflow: widget.overflow==true? TextOverflow.ellipsis:TextOverflow.visible,
    );
  }
}
