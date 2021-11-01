import 'package:flutter/material.dart';
import 'package:sm_flutter_app/screens/welcome_choice_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:splashscreen/splashscreen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 5,
      navigateAfterSeconds: WelcomeChoice(),
      title: Text("Lorem ipsum",
      style: GoogleFonts.modak(fontSize: 20.0,
      color: Colors.white),
      ),
      image: Image.asset("lib/images/sm.png",),
      photoSize: 200.0,
      gradientBackground:  LinearGradient(
      colors: [Colors.blueGrey, Colors.blueAccent],
      begin: const FractionalOffset(0.0, 0.0),
      end: const FractionalOffset(1.0, 0.0),
      tileMode: TileMode.clamp,
    ),
    );
  }
}
