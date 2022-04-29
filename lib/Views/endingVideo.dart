// ignore_for_file: file_names, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:teton_river_explorers/Constants/constants.dart';
import 'package:teton_river_explorers/Constants/tetonLoadingIndicator.dart';
import 'package:teton_river_explorers/Constants/videoPlayerList.dart';
import 'package:teton_river_explorers/Views/CompletionPage.dart';

class EndVideo extends StatefulWidget {
  const EndVideo({Key? key}) : super(key: key);

  @override
  State<EndVideo> createState() => _EndVideoState();
}

class _EndVideoState extends State<EndVideo> {
  bool isLoading = true;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) =>
                  Container(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Center(
                              child: Lottie.asset("assets/congrats.json"),
                            )),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  isLoading
                                      ? Column(
                                          children: [
                                            const Text(
                                              'Loading...',
                                              style: PRIMARY_TEXT_STYLE,
                                            ),
                                            TetonLoadingIndicator(),
                                          ],
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              color: SECONDARY_COLOR,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CustomPlayer(
                                                    videoUrl: ENDING_VIDEO_URL),
                                              )),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              side: const BorderSide(
                                                  color: SECONDARY_COLOR,
                                                  width: 2)),
                                          primary: Colors.white,
                                          backgroundColor: PRIMARY_COLOR,
                                          minimumSize:
                                              const Size.fromHeight(80)),
                                      child: const Text('CONTINUE',
                                          style: PRIMARY_TEXT_STYLE_B),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const CompletionPage()));
                                      },
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
