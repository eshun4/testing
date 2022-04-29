// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, file_names, annotate_overrides

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teton_river_explorers/Constants/constants.dart';

class TetonLoadingIndicator extends StatefulWidget {


  @override
  State<TetonLoadingIndicator> createState() => _TetonLoadingIndicatorState();
}

class _TetonLoadingIndicatorState extends State<TetonLoadingIndicator> with TickerProviderStateMixin {

  late AnimationController animation;
  late Animation<double> _fadeInFadeOut;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 2.0).animate(animation);
    animation.forward();

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animation.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animation.forward();
      }
    });
  }
  // ignore: must_call_super
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: PRIMARY_COLOR.withOpacity(0.4),
      child: FadeTransition(
        opacity: _fadeInFadeOut,
        child: Center(
          child: Container(
            color: PRIMARY_COLOR,
            // width:MediaQuery.of(context).size.width,
            // height:MediaQuery.of(context).size.height,
            child:SvgPicture.asset('assets/teton_svg.svg')
          ),
        ),
      )
    );
  }
}