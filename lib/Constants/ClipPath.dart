// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'package:teton_river_explorers/Constants/constants.dart';

class TopClipPath extends StatelessWidget {
  final double height;
  final Color clr;
  final CustomClipper custClip;
  TopClipPath(this.height, this.clr, this.custClip);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: clr,
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 30))
          ],
          color: PRIMARY_COLOR,
        ),
      ),
      clipper: custClip as CustomClipper<Path>,
    );
  }
}

class Clipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double _xScaling = size.width / 414;
    final double _yScaling = size.height / 896;
    path.lineTo(415 * _xScaling, 1 * _yScaling);
    path.cubicTo(
      415 * _xScaling,
      1 * _yScaling,
      398 * _xScaling,
      254 * _yScaling,
      204 * _xScaling,
      152 * _yScaling,
    );
    path.cubicTo(
      10 * _xScaling,
      50 * _yScaling,
      1 * _xScaling,
      284 * _yScaling,
      1 * _xScaling,
      284 * _yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}