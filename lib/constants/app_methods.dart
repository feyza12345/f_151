import 'package:flutter/material.dart';

kDefaultPageTransition() => (Widget child, Animation<double> animation) {
      return FadeTransition(
        opacity: Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animation),
        child: child,
      );
    };
