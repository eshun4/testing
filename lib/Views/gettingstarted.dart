// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, deprecated_member_use

import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:teton_river_explorers/Constants/ClipPath.dart';
import 'package:teton_river_explorers/Constants/constants.dart';
import 'package:teton_river_explorers/Views/instructions.dart';

class GettingStarted extends StatefulWidget {
  const GettingStarted({Key? key}) : super(key: key);

  @override
  State<GettingStarted> createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted>
    with TickerProviderStateMixin {
  bool _isSelected = false;

  late AnimationController animation;
  late AnimationController animation2;
  late Animation<double> _fadeIn;
  late Animation<double> _fadeInFadeOut;
  late StreamSubscription<ConnectivityResult> subscription;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) {
        // Got a new connectivity status!
        isConnected = (result != ConnectivityResult.none);
      });
    });

    animation = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    animation2 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _fadeIn = Tween<double>(begin: 0.0, end: 2.0).animate(animation);
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 2.0).animate(animation2);
    animation.forward();
    animation2.forward();

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animation.forward();
      } else if (status == AnimationStatus.dismissed) {
        animation.reverse();
      }
    });

    animation2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animation2.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animation2.forward();
      }
    });
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  // ignore: must_call_super
  @override
  void dispose() {
    animation.dispose();
    animation2.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) => Center(
          child: InkWell(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    TopClipPath(400, Colors.black, Clipper1()),
                    FadeTransition(
                      opacity: _fadeInFadeOut,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: orientation == Orientation.landscape
                            ? Image.asset(
                                'assets/background_no_back_2.jpg',
                                fit: BoxFit.cover,
                              )
                            : SvgPicture.asset(
                                'assets/backgroundsvg.svg',
                                color: PRIMARY_COLOR,
                                alignment: Alignment.center,
                                fit: BoxFit.fitHeight,
                              ),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: SingleChildScrollView(
                            child: Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(height: 50),
                                  FadeTransition(
                                      opacity: _fadeIn,
                                      child: Text(
                                        "Welcome to",
                                        style: PRIMARY_TEXT_STYLE_4,
                                      )),
                                  SizedBox(height: 50),
                                  FadeTransition(
                                    opacity: _fadeIn,
                                    child: Container(
                                        child: Image.asset(
                                          "assets/Teton_River_logo.jpg",
                                          scale: 2,
                                        ),
                                        decoration: BoxDecoration(boxShadow: [
                                          BoxShadow(
                                              color: PRIMARY_COLOR
                                                  .withOpacity(0.8),
                                              blurRadius: 7,
                                              spreadRadius: 8,
                                              offset: Offset(0, 3))
                                        ])),
                                  ),
                                  SizedBox(height: 30),
                                  FadeTransition(
                                    opacity: _fadeIn,
                                    child: Container(
                                        decoration: BoxDecoration(boxShadow: [
                                          BoxShadow(
                                              color: PRIMARY_COLOR
                                                  .withOpacity(0.5),
                                              blurRadius: 7,
                                              spreadRadius: 3,
                                              offset: Offset(3, 4))
                                        ]),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    side: const BorderSide(
                                                        color: SECONDARY_COLOR,
                                                        width: 2)),
                                                primary: Colors.white,
                                                backgroundColor: PRIMARY_COLOR,
                                                minimumSize:
                                                    const Size.fromHeight(80)),
                                            child: const Text('GET STARTED',
                                                style: PRIMARY_TEXT_STYLE_B),
                                            onPressed: () {
                                              isConnected
                                                  ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const Instructions()))
                                                  : showDialog(
                                                      context: context,
                                                      builder: (_) => internetError(
                                                          'No Internet Detected.'));
                                            },
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
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
