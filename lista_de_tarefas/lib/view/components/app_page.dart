import 'package:flutter/material.dart';

abstract class AppPage  extends Widget{
  const AppPage(this.label, this.icon, {super.key});

  final String label;
  final Icon icon;
}