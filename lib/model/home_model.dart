import 'package:flutter/material.dart';

class WorkplanMenu {
  Image image;
  Color color;
  String title;

  WorkplanMenu(
      {required this.image, required this.title, required this.color});
}

class WorkplanMenu2 {
  IconData image;
  Color color;
  String title;

  WorkplanMenu2(
      {required this.image, required this.title, required this.color});
}

class Menu {
  String title;
  String image;
  Menu({required this.title, required this.image});
}

class Menu2 {
  String image;
  String title;
  String content;
  String button;

  Menu2(
      {required this.image,
      required this.title,
      required this.content,
      required this.button});
}
