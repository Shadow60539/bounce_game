import 'package:flutter/material.dart';

class SkyBackground extends StatelessWidget {
  final Widget child;

  const SkyBackground({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            tileMode: TileMode.mirror,
            begin: Alignment(-1.0, -0.8),
            end: Alignment.bottomLeft,
            colors: [
              Color(0xff50b1ff),
              Color(0xff36e8f4),
            ],
            stops: [
              0,
              1,
            ]),
        backgroundBlendMode: BlendMode.srcOver,
      ),
      child: child,
    );
  }
}
