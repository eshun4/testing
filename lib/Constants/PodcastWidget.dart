// ignore_for_file: avoid_unnecessary_containers, unnecessary_null_comparison, non_constant_identifier_names, must_be_immutable, sized_box_for_whitespace, file_names, prefer_if_null_operators, unnecessary_string_interpolations, prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:pod_player/pod_player.dart';
import 'package:teton_river_explorers/Constants/constants.dart';

class PodcastItem extends StatefulWidget {
  String title;
  String audioUrl;
  String description;
  String pic;
  Color color;
  List<String>? images;
  String youtubeURl;

  PodcastItem({
    Key? key,
    required this.title,
    required this.audioUrl,
    required this.description,
    required this.pic,
    required this.color,
    required this.images,
    required this.youtubeURl,
  }) : super(key: key);

  @override
  State<PodcastItem> createState() => _PodcastItemState();
}

class _PodcastItemState extends State<PodcastItem> {
  Icon icon = Icon(FontAwesomeIcons.pause, size: 150);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (_) => descriptionSheet(context),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              isScrollControlled: true,
              isDismissible: true);
        },
        child: Column(
          children: [
            ClipRect(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.black.withOpacity(0.6), width: 5)),
                  height: MediaQuery.of(context).size.height * 0.148,
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: widget.pic == null
                                    ? const AssetImage(
                                        "assets/Animals_of_the_Teton_River.jpg")
                                    : AssetImage("assets/${widget.pic}")),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                color: widget.color.withOpacity(0.1) != null
                                    ? widget.color.withOpacity(0.8)
                                    : PRIMARY_COLOR,
                                child: const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(3.0),
                                    child: Icon(FontAwesomeIcons.medal,
                                        size: 22, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget descriptionSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
                color: widget.color,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "${widget.title}",
                    style: PRIMARY_TEXT_STYLE_F,
                    textAlign: TextAlign.center,
                  ),
                )),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                        color: widget.color,
                        width: 3,
                      ),
                      bottom: BorderSide(
                        color: widget.color,
                        width: 3,
                      ))),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("${widget.description}",
                    style: TextStyle(
                        fontFamily: 'Roboto Slab',
                        color: widget.color,
                        fontSize: 15,
                        wordSpacing: 2.0,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            CarouselSlider.builder(
                itemCount: widget.images?.length,
                itemBuilder: (context, index, realIndex) {
                  final urlImage = widget.images![index];
                  return buildImage(urlImage, index);
                },
                options: CarouselOptions(
                  height: 250,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                )),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(widget.color)),
              child: const Text("Done", style: PRIMARY_TEXT_STYLE_C),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage(String urlImage, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Image.asset("assets/$urlImage", fit: BoxFit.cover),
    );
  }
}
