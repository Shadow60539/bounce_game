import 'dart:async';
import 'dart:math';

import 'package:bounce_game/global/components/barrier.dart';
import 'package:bounce_game/global/components/distance.dart';
import 'package:bounce_game/global/components/level.dart';
import 'package:bounce_game/global/model/actor.dart';
import 'package:bounce_game/presentation/widgets/controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class MyProvider extends ChangeNotifier {
  static const _delta = 0.002;
  static const _deltaWall2x2 = 0.0022;

//<----------------------------------Actors------------------------------------>
  Ball _ball = Ball(url: 'assets/ball_small.png', dx: -1.0, dy: 1.0);
  Wall _wall = Wall(url: 'assets/wall.png', dx: 1.0, dy: 1.0);
  Wall2x2 _wall2x2 = Wall2x2(url: 'assets/wall_2x2.png', dx: 0.975, dy: 1.0);
  Ring _ring =
      Ring(url: 'assets/ring.png', dx: 0.25, dy: 1.0, isCollected: false);

//<----------------------------------Components-------------------------------->
  Position _position = Position(dx: -1.0, dy: 0.0);
  Barrier _barrierClass = Barrier();
  Size _screen;

//<----------------------------------Variables--------------------------------->
  double _time = 0.0;
  double _height = 0.0;
  double _initialHeight;

  //Timers
  Duration _refreshDuration = const Duration(milliseconds: 1);

//<----------------------------------Getters----------------------------------->
  Ball get ball => _ball;
  Wall get wall => _wall;
  Wall2x2 get wall2x4 => _wall2x2;
  Ring get ring => _ring;
  Position get position => _position;
  Size get screen => _screen;

  bool get _didRingTouch =>
      _position.dx > 0.17 && !_ring.isCollected && _ball.dy >= _ring.dy;

//<----------------------------------Methods----------------------------------->
  void moveLeft() {
    print(_ball.toString());
    Timer.periodic(
      _refreshDuration,
      (timer) {
        if (LeftButton.isHolding) {
          //_wall.dx<-1 then stop the ball.
          if (_wall.dx <= 1.0) {
            //_ball.dx>0 then move the wall.
            if (_ball.dx != -1.0) {
              _ball.dx += -_delta;
              _position.dx += -_delta;
            } else {
              _ball.dx = -1.0;
              _position.dx = -1.0;
            }
          } else {
            _wall.dx += -_delta;
            _ring.dx += _delta;
            _wall2x2.dx += _deltaWall2x2;
            _position.dx += -_delta;
          }

          notifyListeners();
        } else {
          timer.cancel();
        }
      },
    );
  }

  void moveRight() {
    Timer.periodic(
      _refreshDuration,
      (timer) {
        if (RightButton.isHolding) {
          _checkBarriersAndMove();
          notifyListeners();
        } else {
          timer.cancel();
        }
      },
    );
  }

  void jump() {
    _resetJump();
    Timer.periodic(_refreshDuration, (timer) {
      _time += 0.004;
      _height = -4.9 * pow(_time, 2) + 5.5 * _time;

      //Check for barrier
      final List<Level> _barriers = _barrierClass.barrierList;
      _barriers.forEach((_barrier) {
        final _currentDx = double.parse(_position.dx.toStringAsFixed(2));

//<------------------------ Collision Zone ------------------------------------>
        bool _checkBreakPoints =
            ((_barrier.dx < _currentDx && _currentDx <= _barrier.width) ||
                _barrier.dx == _currentDx);
        if (_checkBreakPoints) {
          if (_ball.dy <= _barrier.dy) {
            timer.cancel();
            _resetJump();
          } else {
            _fallToGround(timer);
          }
        }

//<---------------------------Free2Go Zone------------------------------------->
        else {
          _fallToGround(timer);
        }
      });
    });
  }

//<----------------------------------Helpers----------------------------------->
  void _checkIfRingCollected() {
    if (_didRingTouch) {
      smallJump();
      _ring.url = 'assets/ring_collected.png';
      _ring.isCollected = true;
    }
  }

  void updateScreenSize(Size size) {
    _screen = size;
    notifyListeners();
  }

  void _resetJump() {
    _time = 0.0;
    _initialHeight = _ball.dy;
  }

  void _fallToGround(Timer timer) {
    if (_initialHeight - _height > 1) {
      //Dragforce
      smallJump();
      _resetJump();
      timer.cancel();
    } else {
      _ball.dy = _initialHeight - _height;
    }

    if (_ball.dy == 0.0) {
      timer.cancel();
    }
    notifyListeners();
  }

  void smallJump() {
    _resetJump();
    Timer.periodic(_refreshDuration, (timer) {
      _time += 0.004;
      _height = -4.9 * pow(_time, 2) + 1.5 * _time;

      if (_initialHeight - _height > 1) {
        //Dragforce
        _resetJump();
        timer.cancel();
      } else {
        _ball.dy = _initialHeight - _height;
      }

      if (_ball.dy == 0.0) {
        _resetJump();
        timer.cancel();
      }
    });
  }

  void _increaseBallDistance() {
    _position.dx += _delta;
  }

  void _checkBarriersAndMove() {
    final List<Level> _barriers = _barrierClass.barrierList;
    _barriers.forEach((_barrier) {
      final _currentDx = double.parse(_position.dx.toStringAsFixed(2));

      bool _checkColission = ((_barrier.dx < _currentDx &&
              _currentDx <= _barrier.width &&
              !_barrier.isPassed) ||
          _barrier.dx == _currentDx);

//<--------------------------- Collision Zone --------------------------------->
      if (_checkColission) {
        //Conditions to Move:
        //1. _ball.dy < _barrier.dy
        if (_ball.dy <= _barrier.dy) {
          // print('CORREZCT JUMP');
          if (RightButton.isHolding) {
            // print('MOVING');
            _ball.dy = _barrier.dy;
            _keepMoving();
          }
        }
      } else if ((_currentDx - _barrier.width).abs() > 0.01 &&
          (_currentDx - _barrier.width).abs() < 0.021 &&
          !_barrier.isPassed) {
        smallJump();
        _keepMoving();
        // _ball.dy = 1.0;
        _barrier.isPassed = true;
      }

//<-------------------------------- Free2Go Zone ------------------------------>
      else {
        _keepMoving();
      }
    });
  }

  void _keepMoving() {
    _checkIfRingCollected();

    if (_ball.dx > 0) {
      _wall.dx += _delta;
      _ring.dx += -_delta;
      _wall2x2.dx += -_deltaWall2x2;
    } else {
      _ball.dx += _delta;
    }

    _increaseBallDistance();
  }
}
