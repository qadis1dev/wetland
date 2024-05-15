import 'dart:io';

import 'package:app/screens/blog.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  bool loading = true;
  String message = "none";
  bool loaded = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  Future getPermission() async {
    PermissionStatus status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      return setState(() {
        message = "Change camera permissions from the settings";
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  checkQrCode(Barcode code) {
    final String? codeCheck = code.code;
    if (codeCheck!.startsWith("embed.wetlands.com/") && loaded == false) {
      setState(() {
        loaded = true;
      });
      var id = codeCheck.replaceAll("embed.wetlands.com/", "");
      return Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Blog(id: id),
        )
      ).then((value) => setState(() {
        loaded = false;
      }));
    } else {
      return;
    }
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      checkQrCode(scanData);
    });
  }

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: loading
      ? Center(
        child: Text("Loading..."),
      )
      : message != "none"
      ? Center(child: Text(message),)
      : QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
      ),
    );
  }
}