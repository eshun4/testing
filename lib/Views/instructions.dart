// ignore_for_file: unused_import, prefer_const_constructors, unused_field

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:teton_river_explorers/Constants/PageWidgetBuiler.dart';
import 'package:teton_river_explorers/Constants/constants.dart';
import 'package:teton_river_explorers/Views/audioPlayerPage.dart';
import 'package:teton_river_explorers/Views/initializeQRCode.dart';
import 'package:teton_river_explorers/Views/qrcodescanner.dart';

class Instructions extends StatefulWidget {
  const Instructions({Key? key}) : super(key: key);

  @override
  State<Instructions> createState() => _InstructionsState();
}

class _InstructionsState extends State<Instructions>
    with TickerProviderStateMixin {
  final _controller = PageController();
  bool isLastPage = false;
  late AnimationController animation;
  late AnimationController animation2;
  late Animation<double> _fadeIn;
  late Animation<double> _fadeInFadeOut;
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
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
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
    animation.dispose();
    animation2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Ink(
        child: Container(
          padding: const EdgeInsets.only(bottom: 80),
          child: PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => isLastPage = index == 2);
            },
            children: [
              FadeTransition(
                opacity: _fadeIn,
                child: PageBuilder(
                    color: Colors.white,
                    imageDirectory: 'assets/TRE_inst_1.png',
                    title: "SCAN QR CODE",
                    subtitle:
                        "Grant Camera access and scan QR Code to unlock podcast.",
                    headerStyle: PRIMARY_TEXT_STYLE_4,
                    subtext: PRIMARY_TEXT_STYLE),
              ),
              FadeTransition(
                opacity: _fadeIn,
                child: PageBuilder(
                    color: Colors.white,
                    imageDirectory: 'assets/TRE_inst_2.png',
                    title: "PLAY PODCAST",
                    subtitle: "Press the play button to listen to podcast.",
                    headerStyle: PRIMARY_TEXT_STYLE_4,
                    subtext: PRIMARY_TEXT_STYLE),
              ),
              FadeTransition(
                opacity: _fadeIn,
                child: PageBuilder(
                    color: Colors.white,
                    imageDirectory: 'assets/TRE_inst_3.png',
                    title: "CERTIFICATE",
                    subtitle:
                        "Press the download button to download certificate.",
                    headerStyle: PRIMARY_TEXT_STYLE_4,
                    subtext: PRIMARY_TEXT_STYLE),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: SECONDARY_COLOR, width: 2)),
                  primary: Colors.white,
                  backgroundColor: PRIMARY_COLOR,
                  minimumSize: const Size.fromHeight(80)),
              child: const Text('CONTINUE', style: PRIMARY_TEXT_STYLE_B),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => QRInitialize()));
              },
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () => _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut),
                      child: const Text("NEXT", style: PRIMARY_TEXT_STYLE_5)),
                  Center(
                    child: SmoothPageIndicator(
                        controller: _controller,
                        count: 3,
                        effect: const WormEffect(
                          spacing: 16,
                          dotColor: Colors.grey,
                          activeDotColor: PRIMARY_COLOR,
                        ),
                        onDotClicked: (index) => _controller.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut)),
                  ),
                  TextButton(
                      onPressed: () => _controller.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut),
                      child: const Text("BACK", style: PRIMARY_TEXT_STYLE_5))
                ],
              )),
    );
  }
}
