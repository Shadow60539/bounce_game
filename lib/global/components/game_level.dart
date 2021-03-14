import 'package:bounce_game/global/components/barrier.dart';
import 'package:bounce_game/global/model/actor.dart';

class Level {
  List<Barrier> barrierList = [
    Barrier(
        object: Wall2x2,
        width: 1.1,
        dy: -0.2,
        dx: 0.65,
        isPassed: false), //width = dx+0.45
    Barrier(
        object: Thorn,
        width: 2.16,
        dy: 0.9,
        dx: 2.12,
        isPassed: false), //width = dx+0.04
    Barrier(
        object: Thorn,
        width: 3.42,
        dy: 0.9,
        dx: 3.38,
        isPassed: false), //width = dx+0.04

    Barrier(object: Finish, width: 7.6, dy: 1.0, dx: 7.5, isPassed: false),

    // Barrier(object: Thorn, width: -0.2, dy: 0.9, dx: -0.25, isPassed: false),
  ];

  void reset() {
    barrierList = [
      Barrier(
          object: Wall2x2,
          width: 1.1,
          dy: -0.2,
          dx: 0.65,
          isPassed: false), //width = dx+0.45
      Barrier(object: Thorn, width: 2.16, dy: 0.9, dx: 2.12, isPassed: false),
      Barrier(object: Thorn, width: 3.42, dy: 0.9, dx: 3.38, isPassed: false),
      Barrier(object: Finish, width: 7.6, dy: 1.0, dx: 7.5, isPassed: false),
    ];
  }
}
