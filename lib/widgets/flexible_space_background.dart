import 'package:flutter/material.dart';

Widget flexibleSpaceBackground (BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
          colors: [
            //Theme.of(context).cursorColor,
            //Theme.of(context).accentColor,
            const Color(0xFF3366FF),
            const Color(0xFF00CCFF),
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp),
    ),
  );
}