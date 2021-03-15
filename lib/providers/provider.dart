import 'dart:async';
import 'dart:math';

import 'package:bounce_game/global/components/barrier.dart';
import 'package:bounce_game/global/components/distance.dart';
import 'package:bounce_game/global/components/game_level.dart';
import 'package:bounce_game/global/model/actor.dart';
import 'package:bounce_game/presentation/widgets/controls.dart';
import 'package:bounce_game/presentation/widgets/dialog_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class MyProvider extends ChangeNotifier {
  static const _delta = 0.0003;
  static const _deltaWall2x2 = _delta * 1.1;
  static const _deltaThorn = _delta * 0.95;
  static const _deltaRing = _delta * 0.95;
  static const _deltaFinish = _delta * 0.99;

//<----------------------------------Actors------------------------------------>
  Ball _ball = Ball();
  Wall _wall = Wall();
  Wall2x2 _wall2x2 = Wall2x2();
  Ring _ring1 = Ring();
  Ring _ring2 = Ring(dx: 2.12, impactDx: 2.12 - 0.05, dy: -0.54);
  Thorn _thorn1 = Thorn();
  Thorn _thorn2 = Thorn(dx: 3.32);
  Thorn _movingThorn = Thorn(dx: 7.0, url: 'assets/moving_thorn.png');
  Finish _finish = Finish(dx: 7.5);

//<----------------------------------Components-------------------------------->
  Position _position = Position(dx: -1.0, dy: 0.0);
  Level _level = Level();
  Size _screen;
  int _score = 0;
  List<Ring> _ringsList = List<Ring>();

//<----------------------------------Variables--------------------------------->
  double _time = 0.0;
  double _height = 0.0;
  double _initialHeight;
  bool isStopped = false;
  int _lives = 3;
  double _rotationCoefficient = 0.0;

  //Timers
  Duration _refreshDuration = const Duration(milliseconds: 1);

//<----------------------------------Getters----------------------------------->
  Ball get ball => _ball;
  Wall get wall => _wall;
  Wall2x2 get wall2x4 => _wall2x2;
  Ring get ring1 => _ring1;
  Ring get ring2 => _ring2;
  Thorn get thorn1 => _thorn1;
  Thorn get thorn2 => _thorn2;
  Thorn get movingThorn => _movingThorn;
  Finish get finish => _finish;
  Position get position => _position;
  Size get screen => _screen;
  double get rotationCoefficient => _rotationCoefficient;
  int get lives => _lives;
  int get score => _score;
  List<Ring> get ringsList => _ringsList;

//<----------------------------------Methods----------------------------------->

  void startGame() {
    _ring1.reset(0.25, 0.9);
    _ring2.reset(2.12, -0.54);
    _ringsList.clear();
    _ringsList.addAll([_ring1, _ring2]);
    _score = 0;
    _lives = 3;
    _level.reset();
    _ball.reset();
    _wall.reset();
    _wall2x2.reset();

    _thorn1.reset();
    _thorn2.reset(3.32);
    _movingThorn.reset(5.0);
    isStopped = false;
    _resetJump();
    _finish.reset(7.5);
    _position = Position.reset();
    // _moveThorn();
    notifyListeners();
  }

  void moveLeft() {
    isStopped = false;
    Timer.periodic(
      _refreshDuration,
      (timer) {
        if (LeftButton.isHolding) {
          _rotationCoefficient += -_delta * 6;
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
            _ring1.dx += _delta;
            _ring2.dx += _deltaRing;
            _finish.dx += _deltaFinish;
            _thorn1.dx += _deltaThorn;
            _thorn2.dx += _deltaThorn;
            _movingThorn.dx += _deltaThorn;
            _movingThorn.dx += _deltaThorn;
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
          _rotationCoefficient += _delta * 6;

          _checkBarriersAndMove();
          notifyListeners();
        } else {
          timer.cancel();
        }
      },
    );
  }

  void jump() {
    if (_time != 0) {
    } else {
      _resetJump();
      Timer.periodic(_refreshDuration, (timer) {
        _time += 0.004;
        _height = -4.9 * pow(_time, 2) + 5.5 * _time; // y = -1/2 gt^2 + vt + hi

        //Check for barrier
        final List<Barrier> _barriers = _level.barrierList;
        for (Barrier _barrier in _barriers) {
          final _currentDx = double.parse(_position.dx.toStringAsFixed(2));

//<------------------------ Collision Zone ------------------------------------>
          bool _checkBreakPoints =
              ((_barrier.dx < _currentDx && _currentDx <= _barrier.width) ||
                  _barrier.dx == _currentDx);
          if (_checkBreakPoints) {
            if (_barrier.object == Finish) {
              // _barriers.clear();
              // DialogManager.showLevelCompletedDialog(score);
              // break;
            }

            if (_ball.dy <= _barrier.dy) {
              if (_barrier.object == Thorn) {
                _fallToGround(timer);
              } else {
                // _ball.dy = _barrier.dy;
                timer.cancel();
                _resetJump();
              }
            } else {
              _fallToGround(timer);
            }
          }

//<---------------------------Free2Go Zone------------------------------------->
          else {
            _fallToGround(timer);
          }
        }
      });
    }
  }

//<----------------------------------Helpers----------------------------------->

  void _moveThorn() {
    Timer.periodic(
      _refreshDuration,
      (timer) {
        int a = 1;

        if (timer.tick % 5000 > 2295) {
          if (a == 1) {
            a = -1;
          } else {
            a = 1;
          }
        }
        _movingThorn.dx += a * 0.0003;

        notifyListeners();
      },
    );
  }

  void _checkIfRingCollected() {
    for (Actor ring in _ringsList) {
      if (!ring.isCollected &&
          _position.dx > ring.impactDx &&
          _position.dx < ring.impactDx + 0.1 &&
          _ball.dy >= ring.dy) {
        if (ring.dy.isNegative) {
        } else {
          smallJump();
        }
        ring.url = 'assets/ring_collected.png';
        ring.isCollected = true;
        _score += 2500;
        break;
      }
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
    final List<Barrier> _barriers = _level.barrierList;
    for (Barrier _barrier in _barriers) {
      final _currentDx = double.parse(_position.dx.toStringAsFixed(2));

      bool _checkColission = ((_barrier.dx < _currentDx &&
              _currentDx <= _barrier.width &&
              !_barrier.isPassed) ||
          _barrier.dx == _currentDx);

//<--------------------------- Collision Zone --------------------------------->
      if (_checkColission) {
        if (_barrier.object == Finish) {
          print('//////////////////////////////COPLETED');
          _barriers.clear();
          DialogManager.showLevelCompletedDialog(_score, _lives);

          break;
        }
        if (_barrier.object == Thorn && _ball.dy >= _barrier.dy) {
          _ball.url = 'assets/ball_pop.png';
          Future.delayed(const Duration(milliseconds: 250)).then((value) {
            _gameOver();
          });
          _barriers.clear(); //Stop iterating.
          break;
        }

        if (_barrier.object == Thorn) {
          if (_ball.dy < _barrier.dy) {
            isStopped = false;
            _barrier.isPassed = true;
            _keepMoving();
            break;
          }
        }

        //Conditions to Move:
        //1. _ball.dy < _barrier.dy
        if (_ball.dy <= _barrier.dy) {
          if (RightButton.isHolding) {
            _ball.dy = _barrier.dy;
            isStopped = false;
            _keepMoving();
          }
        }
        isStopped = true;
      } else if (_currentDx > _barrier.width &&
          !_barrier.isPassed &&
          _barrier.object != Thorn) {
        isStopped = false;
        _barrier.isPassed = true;
        smallJump();
        _keepMoving();

        // _ball.dy = 1.0;
      }

//<-------------------------------- Free2Go Zone ------------------------------>
      else {
        _keepMoving();
      }
    }
  }

  void _keepMoving() {
    print(_position.dx);
    _checkIfRingCollected();

    if (!isStopped) {
      if (_position.dx > 6.5) {
        _ball.dx += _delta;
        _position.dx += _delta;
      } else {
        if (_ball.dx > 0) {
          _wall.dx += _delta;
          _ring1.dx += -_delta;
          _ring2.dx += -_deltaRing;
          _finish.dx += -_deltaFinish;
          _thorn1.dx += -_deltaThorn;
          _thorn2.dx += -_deltaThorn;
          _movingThorn.dx += -_deltaThorn;
          _wall2x2.dx += -_deltaWall2x2;
        } else {
          _ball.dx += _delta;
        }

        _increaseBallDistance();
      }
    } else {
      //Stop
    }
  }

  void _gameOver() {
    _lives -= 1;
    if (lives > 0) {
      //Decrease 1 live and restart from start.
      _score = 0;
      _level.reset();
      _ball.reset();
      _wall.reset();
      _wall2x2.reset();
      _ring1.reset(0.25, 0.9);
      _ring2.reset(2.12, -0.54);
      _thorn1.reset();
      _thorn2.reset(3.32);
      _movingThorn.reset(6.5);
      isStopped = false;
      _resetJump();
      _finish.reset(7.5);
      _position = Position.reset();

      notifyListeners();
    } else {
      //Game Over
      DialogManager.showGameOverDialog();
    }
  }
}
