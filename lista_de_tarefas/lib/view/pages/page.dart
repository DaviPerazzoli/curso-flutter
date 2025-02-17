import 'package:flutter/material.dart';

abstract class MyPage extends Widget{
  const MyPage(this.label, this.icon, this.onLoad, {super.key});

  final String label;
  final Icon icon;
  final Function? onLoad;
}