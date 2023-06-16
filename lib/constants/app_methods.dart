import 'package:flutter/material.dart';

FadeTransition kDefaultPageTransition(
        Widget child, Animation<double> animation) =>
    FadeTransition(
      opacity: Tween<double>(
        begin: 0,
        end: 1,
      ).animate(animation),
      child: child,
    );
