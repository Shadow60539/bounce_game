import 'dart:math';

import 'package:bounce_game/global/components/distance.dart';
import 'package:bounce_game/global/model/actor.dart';
import 'package:bounce_game/presentation/actors/object.dart';
import 'package:bounce_game/presentation/widgets/controls.dart';
import 'package:bounce_game/presentation/widgets/sky_background.dart';
import 'package:bounce_game/providers/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              return Column(
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
                                alignment:
                                    Alignment(-_wall.dx + index * 0.18, 0),
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
                              alignment: Alignment(-_wall.dx + index * 0.18, 0),
                              child: WallObject(
                                wall: _wall,
                              ))),
                      Row(
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
                    ],
                  )),
                ],
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
        final Position _position = provider.position;
        final Ball _ball = provider.ball;
        final Ring _ring = provider.ring;
        final Wall2x2 _wall2x2 = provider.wall2x4;
        return Stack(
          children: [
            Align(
              alignment: Alignment(_ball.dx, _ball.dy),
              child: Transform.rotate(
                angle: pi * _position.dx * 6,
                child: BallObject(
                  ball: _ball,
                ),
              ),
            ),
            Align(
              alignment: Alignment(_ring.dx, _ring.dy),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                switchInCurve: Curves.bounceOut,
                child: RingObject(
                  ring: _ring,
                  key: ValueKey(_ring.url),
                ),
              ),
            ),
            Align(
              alignment: Alignment(_wall2x2.dx, _wall2x2.dy),
              child: Wall2x2Object(
                wall2x2: _wall2x2,
              ),
            ),
          ],
        );
      },
    ));
  }
}
