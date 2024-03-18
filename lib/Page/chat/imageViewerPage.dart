
import 'package:agribenin/Page/app_colors.dart';
import 'package:flutter/material.dart';

class ImageViewerPage extends StatefulWidget {
  final String imagePath;

  const ImageViewerPage({super.key, required this.imagePath});

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      appBar: AppBar(
        backgroundColor: darkColor,
        foregroundColor: Colors.white,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.download_sharp,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.share,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          /* height: appHeightSize(context) * 0.6,
          width: appWidthSize(context) * 0.95,*/
          decoration: BoxDecoration(
            image: DecorationImage(
              //fit: BoxFit.cover,
              scale: 0.01,
              image: AssetImage(widget.imagePath),
              //fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
