import 'package:flutter/material.dart';

abstract class MyCard extends Widget {
  const MyCard(this.onSelected, this.inSelectionMode, {super.key});

  final Function(int, bool)? onSelected;
  final bool inSelectionMode;
  int get id;
}