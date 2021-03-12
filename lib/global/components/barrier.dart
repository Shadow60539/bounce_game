import 'package:bounce_game/global/components/level.dart';
import 'package:bounce_game/global/model/actor.dart';

class Barrier {
  List<Level> barrierList = [
    Level(object: Wall2x2, width: 1.1, dy: -0.2, dx: 0.65, isPassed: false),
  ];
}
