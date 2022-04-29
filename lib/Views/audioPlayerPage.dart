// ignore_for_file: file_names, avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print, unused_field, prefer_final_fields, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, unused_local_variable, unnecessary_null_comparison, duplicate_ignore, prefer_const_constructors, unrelated_type_equality_checks, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, must_call_super, unnecessary_string_interpolations, deprecated_member_use

// import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity/connectivity.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teton_river_explorers/Constants/PodcastWidget.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:teton_river_explorers/Constants/constants.dart';
import 'package:teton_river_explorers/Constants/tetonLoadingIndicator.dart';
import 'package:teton_river_explorers/Controllers/PodcastController.dart';
import 'package:teton_river_explorers/Views/endingVideo.dart';
import 'package:teton_river_explorers/Views/initializeQRCode.dart';

class AudioPlayerPage extends StatefulWidget {
  final String title;
  AudioPlayerPage(
    this.title,
  );

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage>
    with TickerProviderStateMixin {
  final PodcastController _controllerPodcast = PodcastController();
  AudioPlayer audioPlayer = AudioPlayer(
    mode: PlayerMode.MEDIA_PLAYER,
  );
  Duration duration = Duration();
  Duration position = Duration();
  bool playing = false;
  PodcastController _controller = PodcastController();

  String album = 'Album';
  String title = 'Title';
  List<String>? podImages;
  String audio_url =
      'https://drive.google.com/uc?id=131jaRyt3dO4AspjUDloYgGymLZPOIhGT&export=download';
  String pic_url = "Friends_of_the_Teton_River.jpg";
  String descript = "Hello";
  Color clr = SECONDARY_COLOR;
  String youTubeURL = "https://youtu.be/sL9sWOshDzU";
  late AnimationController animation;
  late AnimationController animation2;
  late Animation<double> _fadeIn;
  late Animation<double> _fadeInFadeOut;
  String docScript = 'Animal_Podcast.txt';
  String script = 'EmptyString';
  bool isLoading = true;
  late StreamSubscription<ConnectivityResult> subscription;
  bool isConnected = false;

  Widget lottie = Container(
    width: double.infinity,
    height: double.infinity,
  );

  Icon icon = Icon(
    FontAwesomeIcons.play,
    size: 110,
    color: Colors.grey,
  );

  Icon stop_icon = Icon(
    FontAwesomeIcons.stop,
    size: 110,
    color: Colors.transparent,
  );

  void playLocal(String path) async {
    audioPlayer = await AudioCache().play('Effects/$path');
  }

  void renderPodcast() {
    var result = _controller.readJsonData().then(
        (value) => value.firstWhere((element) => element.name == widget.title));
    var result_2 = result.then((value) {
      setState(() {
        album = value.album.toString();
        title = value.name.toString();
        pic_url = value.imageUrl.toString();
        audio_url = value.podUrl.toString();
        descript = value.description.toString();
        clr = Color(int.parse(value.imgColor.toString()));
        podImages = value.images;
        youTubeURL = value.youTubeURL.toString();
        docScript = value.script.toString();
      });
      print(docScript);
    });
  }

  void fetchfileData() async {
    String responseText;
    responseText = await rootBundle.loadString('assets/Podcasts/$docScript');
    setState(() {
      script = responseText;
    });
  }

  @override
  void initState() {
    animation = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    animation2 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8),
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
    audioPlayer.onDurationChanged.listen((dur) {
      setState(() {
        duration = dur;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((dr) {
      setState(() {
        position = dr;
      });
    });

    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        position = Duration(seconds: 0);
        icon = Icon(
          FontAwesomeIcons.play,
          size: 130,
          color: Colors.grey,
        );
      });
    });

    audioPlayer.onPlayerStateChanged.listen((PlayerState event) {
      print('Current player state: $event');
      if (event.name == "PLAYING") {
        setState(() {
          icon = stop_icon;
          lottie = Lottie.asset(
            "assets/music_wave.json",
            fit: BoxFit.cover,
            animate: true,
          );
        });
        print("Playing Audio");
        _controller.podCastStatus("Playing Audio");
      } else if (event.name == "STOPPED") {
        setState(() {
          icon = Icon(
            FontAwesomeIcons.play,
            size: 130,
            color: Colors.grey,
          );
        });
        lottie = Container(
          width: double.infinity,
          height: double.infinity,
        );

        print("Stopped Audio");
        _controller.podCastStatus("Stopped Audio");
      } else if (event.name == "PAUSED") {
        setState(() {
          icon = Icon(
            FontAwesomeIcons.pause,
            size: 130,
            color: Colors.grey,
          );
          lottie = Container(
            width: double.infinity,
            height: double.infinity,
          );
        });
        print("Paused Audio");
        _controller.podCastStatus("Paused Audio");
      } else if (event.name == "COMPLETED") {
        showDialog(context: context, builder: (_) => dialog());
        setState(() {
          icon = Icon(
            FontAwesomeIcons.play,
            size: 130,
            color: Colors.grey,
          );
          lottie = Container(
            width: double.infinity,
            height: double.infinity,
          );
        });
        print("Completed Audio");
        _controller.podCastStatus("Audio Completed");
      }
    });
    setState(() {
      subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) {
        // Got a new connectivity status!
        isConnected = (result != ConnectivityResult.none);
      });
    });

    renderPodcast();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
      fetchfileData();
    });
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    audioPlayer.dispose();
    animation.dispose();
    animation2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PodcastController podcastNotifier = Provider.of<PodcastController>(context);
    Random rand = Random(6);
    var randomValue = rand.nextInt(5 - 1);
    Random rand2 = Random();
    var randomValue2 = rand.nextInt(5 - 1);
    return Consumer<PodcastController>(
        builder: (_, notifier, __) => SafeArea(
              child: Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    isLoading
                        ? Expanded(
                            child: Stack(
                              children: [
                                FadeTransition(
                                  opacity: _fadeInFadeOut,
                                  child: SvgPicture.asset(
                                      'assets/drawing$randomValue2.svg',
                                      color: clr,
                                      alignment: Alignment.center,
                                      fit: BoxFit.fill,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width),
                                ),
                                Container(
                                  color: clr.withOpacity(0.6),
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Loading...",
                                            style: PRIMARY_TEXT_STYLE),
                                        TetonLoadingIndicator()
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : PodCastView(
                            context, randomValue, podcastNotifier, notifier),
                  ],
                ),
              ),
            ));
  }

  Expanded PodCastView(BuildContext context, int randomValue,
      PodcastController podcastNotifier, PodcastController notifier) {
    return Expanded(
        child: OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) => Container(
          color: clr.withOpacity(0.4),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: FadeTransition(
            opacity: _fadeIn,
            child: Stack(
              children: [
                FadeTransition(
                  opacity: _fadeInFadeOut,
                  child: orientation == Orientation.landscape
                      ? Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            'assets/drawing_4.jpg',
                            fit: BoxFit.cover,
                          ),
                        )
                      : SvgPicture.asset('assets/drawing$randomValue.svg',
                          color: clr,
                          alignment: Alignment.center,
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width),
                ),
                lottie,
                SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 40,
                              ),
                              Stack(alignment: Alignment.center, children: [
                                BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 1.5, sigmaY: 1.5),
                                  child: Container(
                                    width: 160.0,
                                    height: 160.0,
                                  ),
                                ),

                                ClipOval(
                                  child: Container(
                                    height: 160,
                                    width: 160,
                                    child: pic_url == null
                                        ? ClipOval(
                                            child: Image.asset(
                                                "assets/Animals_of_the_Teton_River.jpg"))
                                        : ClipOval(
                                            child:
                                                Image.asset("assets/$pic_url")),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 10,
                                          color: Colors.black.withOpacity(0.7)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: clr,
                                            blurRadius: 15,
                                            spreadRadius: 23)
                                      ],
                                    ),
                                  ),
                                ),
                                // lottie,
                                GestureDetector(
                                  onTap: () async {
                                    getAudio();
                                    fetchfileData();
                                    podcastNotifier.addPodcast(PodcastItem(
                                      title: title,
                                      description: descript,
                                      pic: pic_url,
                                      color: clr,
                                      images: podImages,
                                      audioUrl: audio_url,
                                      youtubeURl: youTubeURL,
                                    ));
                                  },
                                  // ignore: prefer_const_constructors
                                  child: icon,
                                )
                              ]),
                              // const SizedBox(height: 10),
                              FadeTransition(
                                opacity: _fadeIn,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: PRIMARY_COLOR, width: 2),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.6),
                                              spreadRadius: 5,
                                              blurRadius: 10,
                                              offset: Offset(5, 10))
                                        ],
                                        color: clr.withOpacity(0.4),
                                        borderRadius:
                                            BorderRadius.circular(80)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          slider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                position
                                                    .toString()
                                                    .split(".")[0],
                                                style: PRIMARY_TEXT_STYLE_3_C,
                                              ),
                                              Text(
                                                duration
                                                    .toString()
                                                    .split(".")[0],
                                                style: PRIMARY_TEXT_STYLE_3_C,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.80,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(title,
                                                  style: PRIMARY_TEXT_STYLE_F,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ),
                                          Text(album,
                                              style: PRIMARY_TEXT_STYLE),
                                          const SizedBox(height: 10),
                                          FloatingActionButton(
                                            elevation: 10,
                                            onPressed: () {
                                              fetchfileData();
                                              showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      displayScript(script));
                                            },
                                            child: Icon(
                                                FontAwesomeIcons.bookOpenReader,
                                                size: 40,
                                                color: clr),
                                          ),
                                          SizedBox(height: 5),
                                          Align(
                                            alignment: Alignment.center,
                                            child:
                                                notifier.podCastList.length > 1
                                                    ? Text(
                                                        "${notifier.podCastList.length} Podcasts unlocked.",
                                                        style:
                                                            PRIMARY_TEXT_STYLE_SUB2,
                                                      )
                                                    : Text(
                                                        "${notifier.podCastList.length} Podcast unlocked.",
                                                        style:
                                                            PRIMARY_TEXT_STYLE_SUB2,
                                                      ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Container(
                            // color: Colors.grey.withOpacity(0.4),
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                      color: PRIMARY_COLOR.withOpacity(0.5),
                                      width: 3,
                                    ),
                                    bottom: BorderSide(
                                      color: PRIMARY_COLOR.withOpacity(0.5),
                                      width: 3,
                                    ))),

                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              color: clr.withOpacity(0.6),
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: notifier.podCastList),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    ));
  }

  getAudio() async {
    // ignore: unused_local_variable
    var url = audio_url;
    if (playing) {
      var res = await audioPlayer.pause();
      setState(() {
        playing = false;
      });
    } else {
      var res = await audioPlayer.play(
        url,
        // stayAwake: true,
      );
      setState(() {
        playing = true;
      });
    }
  }

  Widget dialog() {
    return Consumer<PodcastController>(
        builder: (_, notifier, __) => Container(
                child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: AlertDialog(
                content: Text(
                    "You just listened to the $title podcast. Are you ready to move to the next podcast now?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Roboto Slab',
                        color: clr,
                        fontSize: 15,
                        wordSpacing: 2.0,
                        fontWeight: FontWeight.bold)),
                backgroundColor: Colors.white,
                title: Icon(
                  FontAwesomeIcons.question,
                  color: clr,
                  size: 100,
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      if (notifier.podCastList.length == 9) {
                        int pocastLength = notifier.podCastList.length;
                        Navigator.of(context).pop();
                        showDialog(
                            context: context, builder: (_) => congratsDialog());
                        playLocal('kids_cheering.mp3');
                        SharedPreferences _pref =
                            await SharedPreferences.getInstance();
                        _pref.setInt('listLength', pocastLength);
                      } else {
                        setState(() {
                          album = album;
                          title = title;
                          pic_url = pic_url;
                          audio_url = audio_url;
                          descript = descript;
                          clr = clr;
                          podImages = podImages;
                          youTubeURL = youTubeURL;
                        });

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QRInitialize()));
                      }

                      // audioPlayer.stop();
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(clr)),
                    child: Text("Yes", style: PRIMARY_TEXT_STYLE_C),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(clr)),
                    child: Text("No", style: PRIMARY_TEXT_STYLE_C),
                  ),
                ],
              ),
            )));
  }

  Widget slider() {
    return Slider(
        thumbColor: PRIMARY_COLOR,
        value: position.inSeconds.toDouble(),
        activeColor: clr,
        inactiveColor: PRIMARY_COLOR,
        min: 0.0,
        max: duration.inSeconds.toDouble() + 2.0,
        onChanged: (double value) {
          setState(() {
            audioPlayer.seek(Duration(seconds: value.toInt()));
            audioPlayer.resume();
          });
        });
  }

  Widget congratsDialog() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: AlertDialog(
        content: Text(
            "Congratulations! You have successfully completed the Scavenger Hunt",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Roboto Slab',
                color: PRIMARY_COLOR,
                fontSize: 15,
                wordSpacing: 2.0,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Container(
                child: Lottie.asset('assets/winner.json'),
                width: 100,
                height: 100),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const EndVideo()));
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(PRIMARY_COLOR)),
            child: Text("CONTINUE", style: PRIMARY_TEXT_STYLE_C),
          ),
        ],
      ),
    );
  }

  Widget displayScript(String docScript) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: AlertDialog(
        content: Container(
            child: SingleChildScrollView(
          child: Text(
            script,
            style: PRIMARY_TEXT_STYLE,
          ),
        )),
        title: Container(
          width: 80,
          height: 80,
          child: Lottie.network(
              "https://assets3.lottiefiles.com/packages/lf20_nmrwmvic.json"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(PRIMARY_COLOR)),
            child: Text("CLOSE", style: PRIMARY_TEXT_STYLE_C),
          ),
        ],
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
        title: Icon(FontAwesomeIcons.wifiStrong, color: Colors.white, size: 50),
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
            child: Icon(FontAwesomeIcons.arrowRotateLeft),
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
