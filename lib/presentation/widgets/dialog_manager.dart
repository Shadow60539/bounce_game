import 'package:bounce_game/app_widget.dart';
import 'package:bounce_game/providers/provider.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splash_tap/splash_tap.dart';

class DialogManager {
  static void showPauseDialog() {
    showDialog(
      context: navigatorKey.currentContext,
      barrierColor: Colors.white.withOpacity(0.3),
      builder: (_) {
        return Dialog(
          elevation: 0,
          insetPadding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'LEVEL 1',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Image.asset('assets/resume.png'),
              Image.asset('assets/restart.png'),
              Image.asset('assets/sound_on.png'),
              Image.asset('assets/menu.png'),
            ],
          ),
        );
      },
    );
  }

  static void showGameOverDialog() {
    showDialog(
      context: navigatorKey.currentContext,
      barrierColor: Colors.white.withOpacity(0.3),
      builder: (_) {
        return Dialog(
          elevation: 0,
          insetPadding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/game_over.png'),
              Row(
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/red_menu.png'),
                  const SizedBox(
                    width: 8,
                  ),
                  Splash(
                      splashColor: Colors.white,
                      onTap: () {
                        Navigator.pop(navigatorKey.currentContext);
                        Provider.of<MyProvider>(navigatorKey.currentContext,
                                listen: false)
                            .startGame();
                      },
                      child: Image.asset('assets/red_retry.png')),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static void showLevelCompletedDialog(int score, int lives) {
    showDialog(
      context: navigatorKey.currentContext,
      barrierColor: Colors.white.withOpacity(0.3),
      builder: (_) {
        return Dialog(
          elevation: 0,
          insetPadding: const EdgeInsets.all(80),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'LEVEL 1',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 14),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          'COMPLETE',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 14),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset('assets/blue_menu.png'),
                        const SizedBox(
                          width: 8,
                        ),
                        Splash(
                          splashColor: Colors.white,
                          onTap: () {
                            Navigator.pop(navigatorKey.currentContext);
                            Provider.of<MyProvider>(navigatorKey.currentContext,
                                    listen: false)
                                .startGame();
                          },
                          child: Image.asset('assets/blue_retry.png'),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Countup(
                          begin: 0,
                          end: score.toDouble(),
                          style:
                              TextStyle(color: Colors.redAccent, fontSize: 22),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Stack(
                          children: [
                            Row(
                              children: List.generate(
                                  3,
                                  (index) =>
                                      Image.asset('assets/grey_star.png')),
                            ),
                            Row(
                              children: List.generate(
                                  lives,
                                  (index) =>
                                      Image.asset('assets/yellow_star.png')),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Image.asset('assets/red_next.png')
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
