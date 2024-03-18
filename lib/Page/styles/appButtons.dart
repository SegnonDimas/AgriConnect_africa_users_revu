import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  String? text;
  final double size;
  double borderRadius;
  bool isIconButton;
  IconData icon;

  AppButton({
    super.key,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
    this.text,
    required this.size,
    required this.borderRadius,
    required this.isIconButton,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
        height: size * 3,
        width: size * 3,
        decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 1.5),
            borderRadius: BorderRadius.circular(borderRadius)),
        child: isIconButton
            ? Icon(
                icon,
                color: textColor,
                size: size,
              )
            : Center(
              child: Text(
                  text!,
                  style: TextStyle(
                    color: textColor,
                    fontSize: size,
                  ),
                ),
            ));
  }
}
