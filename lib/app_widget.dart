import 'package:bounce_game/presentation/pages/game_page.dart';
import 'package:bounce_game/providers/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return ChangeNotifierProvider(
      create: (_) => MyProvider()..startGame(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bounce Flutter',
        navigatorKey: navigatorKey,
        home: GamePage(),
        theme: ThemeData.light().copyWith(
          textTheme: GoogleFonts.pressStart2pTextTheme()
        ),
      ),
    );
  }
}
