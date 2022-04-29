// ignore_for_file: await_only_futures, avoid_function_literals_in_foreach_calls, avoid_print, non_constant_identifier_names, file_names, library_prefixes, prefer_final_fields
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teton_river_explorers/Constants/PodcastWidget.dart';
import 'package:teton_river_explorers/Constants/constants.dart';
import 'dart:convert';
import 'package:teton_river_explorers/Models/Podcasts.dart';

class PodcastController extends ChangeNotifier {
  List<PodcastItem> _podCastList = [];

  UnmodifiableListView<PodcastItem> get podCastList =>
      UnmodifiableListView(_podCastList);

  addPodcast(PodcastItem podcast) {
    var contain =
        _podCastList.where((element) => element.title == podcast.title);
    if (contain.isEmpty) {
      //if value does not exist
      _podCastList.add(podcast);
    } else {
      //If value exists
      _podCastList;
    }
    notifyListeners();
  }

  Future<List<Podcast>> readJsonData() async {
    //read json file
    final jsondata =
        await rootBundle.rootBundle.loadString('assets/podcasts.json');
    //decode json data as list
    final list = json.decode(jsondata) as List<dynamic>;

    //map json and initialize using DataModel
    return list.map((e) => Podcast.fromJson(e)).toList();
  }

  podCastStatus(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: PRIMARY_COLOR,
      textColor: Colors.white,
      fontSize: 22.0,
    );
  }
}
