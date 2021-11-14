import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DisplayImage extends StatefulWidget {
  final String imageString;
  final double imageBorderRadius;
  const DisplayImage({Key? key, required this.imageString, required this.imageBorderRadius}) : super(key: key);

  @override
  _DisplayImageState createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
  late File fileImg;
  bool isLoading = true;

  void writeFile() async {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final String randomString = List.generate(100, (index) => _chars[Random().nextInt(_chars.length)]).join();

    final decodedBytes = base64Decode(widget.imageString);
    final directory = await getApplicationDocumentsDirectory();
    fileImg = File('${directory.path}/' + randomString + '.png');

    fileImg.writeAsBytesSync(List.from(decodedBytes));

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      writeFile();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container()
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.imageBorderRadius),
              image: DecorationImage(image: Image.file(fileImg).image, fit: BoxFit.fill),
            ),
          );
  }
}
