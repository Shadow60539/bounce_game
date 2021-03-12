import 'package:flutter/cupertino.dart';

abstract class Actor {
  double dx;
  double dy;
  String url;
  bool isCollected;

  Actor(
      {@required this.dx,
      @required this.dy,
      @required this.url,
      this.isCollected});

  @override
  String toString() => '${this.runtimeType}(dx: $dx, dy: $dy, url: $url)';
}

class Ball extends Actor {
  Ball({double dx, double dy, String url}) : super(dx: dx, dy: dy, url: url);
}

class Ring extends Actor {
  Ring({double dx, double dy, String url, bool isCollected})
      : super(dx: dx, dy: dy, url: url, isCollected: isCollected);
}

class Wall extends Actor {
  Wall({double dx, double dy, String url}) : super(dx: dx, dy: dy, url: url);
}

class Wall2x2 extends Actor {
  Wall2x2({double dx, double dy, String url}) : super(dx: dx, dy: dy, url: url);
}
