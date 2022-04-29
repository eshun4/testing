// ignore_for_file: file_names, avoid_unnecessary_containers, avoid_print, avoid_function_literals_in_foreach_calls, non_constant_identifier_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, sized_box_for_whitespace, unused_field

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:teton_river_explorers/Constants/constants.dart';
import 'package:teton_river_explorers/Constants/tetonLoadingIndicator.dart';
import 'package:teton_river_explorers/Constants/videoPlayerList.dart';
// import 'package:teton_river_explorers/Constants/constants.dart';
// import 'package:teton_river_explorers/Constants/videoPlayerList.dart';
import 'package:teton_river_explorers/Controllers/PodcastController.dart';
import 'package:teton_river_explorers/Models/Podcasts.dart';

class FinalPlaylist extends StatefulWidget {
  const FinalPlaylist({Key? key}) : super(key: key);

  @override
  State<FinalPlaylist> createState() => _FinalPlaylistState();
}

class _FinalPlaylistState extends State<FinalPlaylist>
    with TickerProviderStateMixin {
  final PodcastController _controller = PodcastController();
  late AnimationController animation;
  late AnimationController animation2;
  late Animation<double> _fadeIn;
  late Animation<double> _fadeInFadeOut;

  Future<List<Podcast>> renderPodcast() {
    var playlist = _controller.readJsonData().then((value) => value);
    return playlist;
  }

  bool isLoading = true;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    renderPodcast();
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });

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
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          backgroundColor: PRIMARY_COLOR,
          expandedHeight: 200,
          toolbarHeight: 75,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
              title: Text("My Inventory", style: PRIMARY_TEXT_STYLE_6_B),
              background: Image.network(
                PLAYLIST_IMAGE,
                fit: BoxFit.cover,
              )),
        ),
        podcasts()
      ]),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    animation.dispose();
    animation2.dispose();
  }

  Widget buildVideoDialog(Podcast pod) {
    var color = int.parse(pod.imgColor.toString());
    return FadeTransition(
      opacity: _fadeIn,
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            color: Color(color),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomPlayer(videoUrl: pod.youTubeURL.toString()),
                )),
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(pod.name.toString(),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: PRIMARY_TEXT_STYLE_SUB3),
                          ),
                        ),
                        Text(pod.album.toString(),
                            textAlign: TextAlign.left,
                            softWrap: true,
                            style: PRIMARY_TEXT_STYLE_SUB1),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            pod.description.toString(),
                            textAlign: TextAlign.center,
                            style: PRIMARY_TEXT_STYLE_SUB2,
                            softWrap: true,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myCard(int color, Podcast pod) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(color),
          border: Border(
            top: BorderSide(width: 2.0, color: PRIMARY_COLOR),
            bottom: BorderSide(width: 2.0, color: PRIMARY_COLOR),
            right: BorderSide(width: 2.0, color: PRIMARY_COLOR),
            left: BorderSide(width: 2.0, color: PRIMARY_COLOR),
          )),
      child: ListTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: AssetImage('assets/${pod.imageUrl}'),
        ),
        title: Text(pod.name.toString(),
            textAlign: TextAlign.left,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: PRIMARY_TEXT_STYLE_SUB1),
        subtitle: Text(
          pod.description.toString(),
          textAlign: TextAlign.left,
          style: PRIMARY_TEXT_STYLE_SUB2,
          softWrap: true,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget podcasts() => SliverToBoxAdapter(
        child: FutureBuilder<List<Podcast>>(
          future: renderPodcast(),
          builder: (context, snapshot) {
            final podcast = snapshot.data;
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              default:
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      Center(
                        child: Lottie.network(
                            "https://assets5.lottiefiles.com/packages/lf20_kmabq1m3.json"),
                      ),
                      ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final pod = podcast![index];
                            final color = int.parse(pod.imgColor.toString());
                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    isLoading
                                        ? TetonLoadingIndicator()
                                        : showDialog(
                                            context: context,
                                            builder: (_) =>
                                                buildVideoDialog(pod));
                                  },
                                  child: isLoading
                                      ? TetonLoadingIndicator()
                                      : myCard(color, pod),
                                ));
                          },
                          itemCount: podcast!.length),
                    ],
                  ),
                );
            }
          },
        ),
      );
}
