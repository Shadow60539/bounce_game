import 'package:bounce_game/global/model/actor.dart';
import 'package:flutter/material.dart';

abstract class Object extends StatelessWidget {
  final Actor actor;

  const Object({Key key, @required this.actor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.asset(actor.url);
  }
}

class BallObject extends Object {
  BallObject({Ball ball, Key key}) : super(actor: ball, key: key);
}

class WallObject extends Object {
  WallObject({Wall wall, Key key}) : super(actor: wall, key: key);
}

class Wall2x2Object extends Object {
  Wall2x2Object({Wall2x2 wall2x2, Key key}) : super(actor: wall2x2, key: key);
}

class RingObject extends Object {
  RingObject({Actor ring, Key key}) : super(actor: ring, key: key);
}

class ThornObject extends Object {
  ThornObject({Thorn thorn, Key key}) : super(actor: thorn, key: key);
}

class Finishbject extends Object {
  Finishbject({Finish finish, Key key}) : super(actor: finish, key: key);
}
