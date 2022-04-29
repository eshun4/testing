// ignore_for_file: prefer_const_constructors, constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';

/// *This class will hold all the contants for the App***/

const Color PRIMARY_COLOR = Color(0xFF246f99);
const Color SECONDARY_COLOR = Color(0xFFefdd5c);
const TextStyle PRIMARY_TEXT_STYLE = TextStyle(
  fontFamily: 'Roboto Slab',
  color: Colors.black,
  fontSize: 25,
  wordSpacing: 2.0,
);

const TextStyle PRIMARY_TEXT_STYLE_SUB1 = TextStyle(
  fontFamily: 'Roboto Slab',
  color: Colors.black,
  fontSize: 20,
  wordSpacing: 2.0,
);

const TextStyle PRIMARY_TEXT_STYLE_SUB2 = TextStyle(
  fontFamily: 'Roboto Slab',
  color: Colors.black,
  fontSize: 15,
  wordSpacing: 2.0,
);

const TextStyle PRIMARY_TEXT_STYLE_SUB3 = TextStyle(
    fontFamily: 'Roboto Slab',
    color: Colors.black,
    fontSize: 22,
    wordSpacing: 2.0,
    fontWeight: FontWeight.bold);

const TextStyle PRIMARY_TEXT_STYLE_B = TextStyle(
  fontFamily: 'Roboto Slab',
  color: Colors.white,
  fontSize: 25,
  wordSpacing: 2.0,
);

const TextStyle PRIMARY_TEXT_STYLE_B_2 = TextStyle(
  fontFamily: 'Roboto Slab',
  color: PRIMARY_COLOR,
  fontSize: 30,
  wordSpacing: 2.0,
);

const TextStyle PRIMARY_TEXT_STYLE_E = TextStyle(
  fontFamily: 'Roboto Slab',
  color: SECONDARY_COLOR,
  fontSize: 20,
  wordSpacing: 2.0,
);

const TextStyle PRIMARY_TEXT_STYLE_C = TextStyle(
    fontFamily: 'Roboto Slab',
    color: Colors.white,
    fontSize: 15,
    wordSpacing: 2.0,
    fontWeight: FontWeight.bold);

const TextStyle PRIMARY_TEXT_STYLE_D = TextStyle(
    fontFamily: 'Roboto Slab',
    color: Colors.white,
    fontSize: 19,
    wordSpacing: 2.0,
    fontWeight: FontWeight.bold);

const TextStyle PRIMARY_TEXT_STYLE_F = TextStyle(
    fontFamily: 'Roboto Slab',
    color: Colors.black,
    fontSize: 25,
    wordSpacing: 2.0,
    fontWeight: FontWeight.bold);

const TextStyle PRIMARY_TEXT_STYLE_2 = TextStyle(
    fontFamily: 'Roboto Slab',
    color: Colors.black,
    fontSize: 25,
    wordSpacing: 2.0,
    fontWeight: FontWeight.normal);

const TextStyle PRIMARY_TEXT_STYLE_3 = TextStyle(
    fontFamily: 'Roboto Slab',
    color: Colors.white,
    fontSize: 22,
    wordSpacing: 2.0,
    fontWeight: FontWeight.normal);

const TextStyle PRIMARY_TEXT_STYLE_3_B = TextStyle(
    fontFamily: 'Roboto Slab',
    color: Colors.white,
    fontSize: 24,
    wordSpacing: 2.0,
    fontWeight: FontWeight.bold);

const TextStyle PRIMARY_TEXT_STYLE_3_C = TextStyle(
    fontFamily: 'Roboto Slab',
    color: Colors.black,
    fontSize: 22,
    wordSpacing: 2.0,
    fontWeight: FontWeight.bold);

const TextStyle PRIMARY_TEXT_STYLE_4 = TextStyle(
    fontFamily: 'Roboto Slab',
    color: Colors.black,
    fontSize: 45,
    wordSpacing: 2.0,
    fontWeight: FontWeight.bold,
    decorationStyle: TextDecorationStyle.solid,
    decoration: TextDecoration.overline,
    decorationThickness: 3,
    shadows: [
      Shadow(
        color: PRIMARY_COLOR,
        blurRadius: 16,
      )
    ]);

const TextStyle PRIMARY_TEXT_STYLE_5 = TextStyle(
    fontFamily: 'Roboto Slab',
    color: PRIMARY_COLOR,
    fontSize: 30,
    wordSpacing: 2.0,
    fontWeight: FontWeight.bold,
    decorationStyle: TextDecorationStyle.solid,
    decoration: TextDecoration.overline,
    decorationThickness: 3,
    shadows: [
      Shadow(
        color: Colors.black,
        blurRadius: 16,
      )
    ]);

const TextStyle PRIMARY_TEXT_STYLE_6 = TextStyle(
    fontFamily: 'Roboto Slab',
    color: Colors.white,
    fontSize: 45,
    wordSpacing: 2.0,
    fontWeight: FontWeight.bold,
    decorationStyle: TextDecorationStyle.solid,
    decoration: TextDecoration.overline,
    decorationThickness: 3,
    shadows: [
      Shadow(
        color: Colors.grey,
        blurRadius: 16,
      )
    ]);

const TextStyle PRIMARY_TEXT_STYLE_6_B = TextStyle(
    fontFamily: 'Roboto Slab',
    color: Colors.black,
    fontSize: 38,
    wordSpacing: 2.0,
    fontWeight: FontWeight.bold,
    decorationStyle: TextDecorationStyle.solid,
    decorationThickness: 3,
    shadows: [
      Shadow(
        color: Colors.grey,
        blurRadius: 16,
      )
    ]);

ThemeData kAppTheme = ThemeData(
    primaryColor: PRIMARY_COLOR,
    backgroundColor: Colors.white,
    buttonTheme: ButtonThemeData(buttonColor: PRIMARY_COLOR),
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(bodyText1: PRIMARY_TEXT_STYLE),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white));

String ENDING_VIDEO_URL =
    'https://drive.google.com/uc?id=10EJt_y5vqGiGL5nxXwiiCKsDyUHIoer5&export=download';

String PLAYLIST_IMAGE =
    "https://drive.google.com/uc?id=1A28ovm2r_YvEs3vSQBcJ1FigWMJLrrWL&export=download";
