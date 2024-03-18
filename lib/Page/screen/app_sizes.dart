import 'package:flutter/material.dart';

double appHeightSize(BuildContext context) {
  double _height = MediaQuery.of(context).size.height;
  return _height;
}

double appWidthSize(BuildContext context) {
  double _width = MediaQuery.of(context).size.width;
  return _width;
}

