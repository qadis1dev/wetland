import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class GenerateQR extends StatefulWidget {
  const GenerateQR({super.key, required this.id});

  final String id;

  @override
  State<GenerateQR> createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {

  ScreenshotController screenshotController = ScreenshotController();

  share() async {
    await screenshotController.capture(delay: const Duration(microseconds: 10)).then((value) async {
      if (value != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(value);
        await Share.shareXFiles([XFile(imagePath.path)]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46923c),
        title: Text(
          "QR code",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Screenshot(
          controller: screenshotController,
          child: QrImageView(
            data: "embed.wetlands.com/${widget.id}",
            version: QrVersions.auto,
            size: 250,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          share();
        },
        backgroundColor: Color(0xFF46932c),
        child: Icon(
          Icons.mobile_screen_share_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}