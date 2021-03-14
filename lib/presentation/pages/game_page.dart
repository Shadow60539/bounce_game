import 'dart:math';

import 'package:bounce_game/global/model/actor.dart';
import 'package:bounce_game/presentation/actors/object.dart';
import 'package:bounce_game/presentation/widgets/controls.dart';
import 'package:bounce_game/presentation/widgets/dialog_manager.dart';
import 'package:bounce_game/presentation/widgets/sky_background.dart';
import 'package:bounce_game/providers/provider.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splash_tap/splash_tap.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MyProvider>(context, listen: false)
          .updateScreenSize(MediaQuery.of(context).size);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black12,
          body: Consumer<MyProvider>(
            builder: (context, provider, child) {
              final Wall _wall = provider.wall;
              return RepaintBoundary(
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Container(
                          alignment: Alignment.topLeft,
                          child: Stack(
                              fit: StackFit.expand,
                              children: List.generate(
                                  50,
                                  (index) => Align(
                                      alignment: Alignment(
                                          -_wall.dx + index * 0.18, 0),
                                      child: WallObject(
                                        wall: _wall,
                                      )))),
                        )),
                        Expanded(flex: 4, child: Playground()),
                        Expanded(
                            child: Stack(
                          children: [
                            ...List.generate(
                                50,
                                (index) => Align(
                                    alignment:
                                        Alignment(-_wall.dx + index * 0.18, 0),
                                    child: WallObject(
                                      wall: _wall,
                                    ))),
                          ],
                        )),
                      ],
                    ),
                    Positioned(
                      bottom: 10,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          LeftButton(function: provider.moveLeft),
                          SizedBox(
                            width: 20,
                          ),
                          RightButton(function: provider.moveRight),
                          Spacer(),
                          JumpButton(function: provider.jump),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Row(
                        children: [
                          Transform.rotate(
                            angle: provider.rotationCoefficient * pi / 3,
                            child: Image.asset(
                              'assets/ball_small.png',
                              height: 25,
                              width: 25,
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            'X${provider.lives}',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ...provider.ringsList
                              .skipWhile((e) => e.isCollected)
                              .map((e) => Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: Image.asset(
                                      'assets/score_ring.png',
                                    ),
                                  ))
                        ],
                      ),
                    ),
                    Positioned(
                      top: 15,
                      right: 20,
                      child: Row(
                        children: [
                          Countup(
                            begin: 0.0,
                            end: provider.score.toDouble(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Splash(
                            onTap: () => DialogManager.showPauseDialog(),
                            splashColor: Colors.white,
                            maxRadius: 30,
                            minRadius: 20,
                            child: Icon(
                              Icons.pause_rounded,
                              size: 30,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}

class Playground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SkyBackground(child: Consumer<MyProvider>(
      builder: (context, provider, child) {
        // final Wall _wall = provider.wall;
        final Ball _ball = provider.ball;
        final Ring _ring1 = provider.ring1;
        final Ring _ring2 = provider.ring2;
        final Wall2x2 _wall2x2 = provider.wall2x4;
        final Thorn _thorn1 = provider.thorn1;
        final Thorn _thorn2 = provider.thorn2;
        final Thorn _movingThorn = provider.movingThorn;
        final Finish _finish = provider.finish;
        return RepaintBoundary(
          child: Stack(
            children: [
              Align(
                alignment: Alignment(_ball.dx, _ball.dy),
                child: Transform.rotate(
                  angle: pi * provider.rotationCoefficient,
                  child: BallObject(
                    ball: _ball,
                  ),
                ),
              ),
              Align(
                alignment: Alignment(_ring1.dx, _ring1.dy),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  switchInCurve: Curves.bounceOut,
                  child: RingObject(
                    ring: _ring1,
                    key: ValueKey(_ring1.url),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(_ring2.dx, _ring2.dy),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  switchInCurve: Curves.bounceOut,
                  child: RingObject(
                    ring: _ring2,
                    key: ValueKey(_ring2.url),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(_wall2x2.dx, _wall2x2.dy),
                child: Wall2x2Object(
                  wall2x2: _wall2x2,
                ),
              ),
              Align(
                alignment: Alignment(_thorn1.dx, _thorn1.dy),
                child: ThornObject(
                  thorn: _thorn1,
                ),
              ),
              Align(
                alignment: Alignment(_thorn2.dx, _thorn2.dy),
                child: ThornObject(
                  thorn: _thorn2,
                ),
              ),
              Align(
                alignment: Alignment(_movingThorn.dx, _movingThorn.dy),
                child: ThornObject(
                  thorn: _movingThorn,
                ),
              ),
              Align(
                alignment: Alignment(_finish.dx, _finish.dy),
                child: Finishbject(
                  finish: _finish,
                ),
              ),
            ],
          ),
        );
      },
    ));
  }
}
