// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teton_river_explorers/Constants/constants.dart';
import 'package:teton_river_explorers/Controllers/PodcastController.dart';
import 'package:teton_river_explorers/Views/gettingstarted.dart';
import 'package:teton_river_explorers/Views/podcastPlaylist.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  var length = pref.getInt('listLength');
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PodcastController()),
    ],
    child: length == null
        ? TetonRiverApp()
        : MaterialApp(home: FinalPlaylist(), debugShowCheckedModeBanner: false),
  ));
}

class TetonRiverApp extends StatefulWidget {
  const TetonRiverApp({Key? key}) : super(key: key);

  @override
  State<TetonRiverApp> createState() => _TetonRiverAppState();
}

class _TetonRiverAppState extends State<TetonRiverApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GettingStarted(),
      debugShowCheckedModeBanner: false,
      theme: kAppTheme,
    );
  }
}
