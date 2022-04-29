// ignore_for_file: prefer_const_constructors, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, deprecated_member_use

import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:teton_river_explorers/Constants/constants.dart';
import 'package:teton_river_explorers/Views/qrcodescanner.dart';

class QRInitialize extends StatefulWidget {
  const QRInitialize({Key? key}) : super(key: key);

  @override
  State<QRInitialize> createState() => _QRInitializeState();
}

class _QRInitializeState extends State<QRInitialize> {
  late StreamSubscription<ConnectivityResult> subscription;
  bool isConnected = false;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    setState(() {
      subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) {
        // Got a new connectivity status!
        isConnected = (result != ConnectivityResult.none);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                color: PRIMARY_COLOR,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Center(
                          child: Text(
                        'Press Button to Start Scanner',
                        style: PRIMARY_TEXT_STYLE_3,
                      )),
                      isConnected
                          ? Expanded(
                              child: Lottie.network(
                                  "https://assets8.lottiefiles.com/packages/lf20_he0riwlq.json"),
                            )
                          : Expanded(child: Lottie.asset("assets/scan_qr.json"))
                    ],
                  ),
                ),
              ),
              Container(
                // height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: const BorderSide(
                                    color: SECONDARY_COLOR, width: 2)),
                            primary: Colors.white,
                            backgroundColor: PRIMARY_COLOR,
                            minimumSize: const Size.fromHeight(80)),
                        child: const Text('SCAN QR CODE',
                            style: PRIMARY_TEXT_STYLE_B),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QRCodeScanner()));
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  Widget internetError(String internetMessage) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: AlertDialog(
        content: Container(
            child: SingleChildScrollView(
          child: Text(
            internetMessage,
            style: PRIMARY_TEXT_STYLE,
            textAlign: TextAlign.center,
          ),
        )),
        title:
            Icon(FontAwesomeIcons.wifiStrong, color: PRIMARY_COLOR, size: 50),
        actions: [
          TextButton(
            onPressed: () {
              isConnected
                  ? Navigator.of(context).pop()
                  : showDialog(
                      context: context,
                      builder: (_) => internetError('No Internet Detected.'));
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(PRIMARY_COLOR)),
            child: Icon(FontAwesomeIcons.arrowRotateLeft, color: Colors.white),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(PRIMARY_COLOR)),
            child: Icon(FontAwesomeIcons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
