// ignore_for_file: must_be_immutable, file_names, avoid_unnecessary_containers

import 'package:flutter/material.dart';

class PageBuilder extends StatelessWidget {
  
  Color color;
  String imageDirectory;
  String title;
  String subtitle;
  TextStyle headerStyle;
  TextStyle subtext;
  
  
  PageBuilder({Key? key, 
    required this.color,
    required this.imageDirectory,
    required this.title,
    required this.subtitle,
    required this.headerStyle,
    required this.subtext
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color:color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                child: Image.asset(
                    imageDirectory,
                    fit: BoxFit.cover,
                    width:300,
                    height:300
                ),
              ),
            ),
            // const SizedBox(height:20),
            Text(title,
            style: headerStyle
            ),
            // const SizedBox(height:24),
            Center(
              child: Container(
                padding: const EdgeInsets.all(30),child: Text(subtitle, style:subtext ),
                  ),
            )
          ],
          )
        
      ),
    );
  }
}
