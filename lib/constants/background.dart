import 'package:flutter/material.dart';

final background = Container(
  height: double.infinity,
  width: double.infinity,
  decoration: const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
        Color.fromARGB(150, 33, 150, 243),
        Color.fromARGB(175, 33, 150, 243),
        Color.fromARGB(200, 33, 150, 243),
        Color.fromARGB(225, 33, 150, 243),
      ],
          stops: [
        0.1,
        0.4,
        0.7,
        0.9
      ])),
);
