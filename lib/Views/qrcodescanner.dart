// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_final_fields, unused_local_variable, unused_import, sized_box_for_whitespace
// import 'dart:developer';
import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity/connectivity.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import 'package:teton_river_explorers/Constants/constants.dart';
import 'package:teton_river_explorers/Constants/tetonLoadingIndicator.dart';
import 'package:teton_river_explorers/Controllers/PodcastController.dart';
import 'package:teton_river_explorers/Views/audioPlayerPage.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({Key? key}) : super(key: key);

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;
  PodcastController _controller = PodcastController();
  String name = 'SomeName';
  AudioPlayer audioPlayer = AudioPlayer();

  playLocal(String path) async {
    audioPlayer = await AudioCache().play('Effects/$path');
  }

  void renderPodcast() {
    var result = _controller.readJsonData().then((value) =>
        value.firstWhere((element) => element.name == barcode!.code));
    var result_2 = result.then((value) {
      setState(() {
        name = value.name.toString();
      });
      if (barcode?.code != name) {
        playLocal('uh_oh.mp3');
      } else if (barcode?.code == name) {
        playLocal('coin_collect.mp3');
      }
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(child: builQRView(context)),
            barcode == null
                ? const SizedBox()
                : barcode!.code != name
                    ? errorDialog()
                    : unlockDialog()
          ],
        ),
      ),
    );
  }

  Widget builQRView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderLength: 20,
          borderWidth: 10,
          borderRadius: 10,
          borderColor: PRIMARY_COLOR,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((barcode) {
      setState(() {
        this.barcode = barcode;
      });
      renderPodcast();
      playLocal('coin_collect.mp3');
    });
  }

  Widget unlockDialog() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: AlertDialog(
        content: const Text(
          "Congratulations! You have successfully unlocked an item.",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Roboto Slab',
              color: PRIMARY_COLOR,
              fontSize: 15,
              wordSpacing: 2.0,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        title: Container(
            child: Container(
                width: 100,
                height: 100,
                child: Lottie.asset('assets/treasure_chest.json',
                    fit: BoxFit.cover))),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AudioPlayerPage(
                            barcode!.code.toString(),
                          )));
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(PRIMARY_COLOR)),
            child: const Text("COLLECT", style: PRIMARY_TEXT_STYLE_C),
          ),
        ],
      ),
    );
  }

  Widget errorDialog() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: AlertDialog(
        content: const Text(
          "Wrong QR Code. Scan the right QR code",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Roboto Slab',
              color: PRIMARY_COLOR,
              fontSize: 15,
              wordSpacing: 2.0,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        title: Container(
            width: 100,
            height: 100,
            child: Lottie.network(
                'https://assets1.lottiefiles.com/packages/lf20_z5hx1rzj.json',
                fit: BoxFit.cover)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(PRIMARY_COLOR)),
            child: const Text("CLOSE", style: PRIMARY_TEXT_STYLE_C),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    controller?.dispose();
    super.dispose();
  }
}
