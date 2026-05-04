import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentGeometry.center,
      children: [
        Transform.rotate(
          angle: 18.54 * pi / 180,
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 60,
                  color: Colors.grey,
                ),
              ],
              color: HexColor('FF5722'),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Image.asset('assets/images/cook.png'),
      ],
    );
  }
}
