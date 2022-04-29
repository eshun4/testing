// ignore_for_file: file_names, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unused_field, avoid_unnecessary_containers, prefer_const_constructors, unused_local_variable, avoid_print, prefer_final_fields, non_constant_identifier_names

import 'dart:math';
import 'dart:typed_data';

import 'package:confetti/confetti.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:teton_river_explorers/Constants/ClipPath.dart';
import 'package:teton_river_explorers/Constants/constants.dart';
import 'package:teton_river_explorers/Constants/tetonLoadingIndicator.dart';
import 'package:teton_river_explorers/Controllers/PodcastController.dart';
import 'package:teton_river_explorers/Views/podcastPlaylist.dart';

class CompletionPage extends StatefulWidget {
  const CompletionPage({Key? key}) : super(key: key);

  @override
  State<CompletionPage> createState() => _CompletionPageState();
}

class _CompletionPageState extends State<CompletionPage>
    with TickerProviderStateMixin {
  bool _isSelected = false;
  late ConfettiController _confettiController;
  PodcastController _controller = PodcastController();
  bool isLoading = true;

  String certificateURL =
      "https://drive.google.com/uc?id=1aN2YJlxHgXrn9adnIeEj8i_E2GvYs9xl&export=download";

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }
  // ignore: must_call_super

  @override
  Widget build(BuildContext context) {
    Random rand = Random();
    var valRand = rand.nextInt(5 - 1);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    SvgPicture.asset('assets/drawing$valRand.svg',
                        color: SECONDARY_COLOR,
                        alignment: Alignment.center,
                        fit: BoxFit.fitHeight,
                        allowDrawingOutsideViewBox: true,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: PRIMARY_COLOR.withOpacity(0.3),
                      child: Container(
                        width: 100,
                        height: 100,
                        child: Lottie.network(
                            'https://assets1.lottiefiles.com/packages/lf20_2pr9x3si.json',
                            fit: BoxFit.cover),
                      ),
                    ),
                    isLoading
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Loading", style: PRIMARY_TEXT_STYLE),
                              TetonLoadingIndicator()
                            ],
                          )
                        : SingleChildScrollView(
                            child: DownloadCertificateWidget(context))
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Align DownloadCertificateWidget(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      border: Border.all(width: 3, color: SECONDARY_COLOR),
                      color: PRIMARY_COLOR),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Lottie.asset("assets/cert_trophy.json"),
                          width: 120,
                          height: 120,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Click on the button below to download your certificate.',
                            style: PRIMARY_TEXT_STYLE_E,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _save();
                            final snackBar = SnackBar(
                                backgroundColor: PRIMARY_COLOR,
                                content: Text(
                                  'File downloaded to photos.',
                                  textAlign: TextAlign.center,
                                  style: PRIMARY_TEXT_STYLE_3,
                                ));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            _controller
                                .podCastStatus("File downloaded to photos.");
                          },
                          child: const Text(
                            "DOWNLOAD",
                            style: PRIMARY_TEXT_STYLE_3,
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(SECONDARY_COLOR)),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          side: const BorderSide(
                                              color: SECONDARY_COLOR,
                                              width: 2)),
                                      primary: Colors.white,
                                      backgroundColor:
                                          PRIMARY_COLOR.withOpacity(0.4),
                                      minimumSize: const Size.fromHeight(80)),
                                  child: const Text('CONTINUE',
                                      style: PRIMARY_TEXT_STYLE_B),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FinalPlaylist()));
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _save() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      var response = await Dio().get(certificateURL,
          options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 60,
          name: "Teton River Explorers Certificate");
      print(result);
    }
  }
}
