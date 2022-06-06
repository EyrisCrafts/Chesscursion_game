import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OverlayWon extends StatefulWidget {
  const OverlayWon({Key? key}) : super(key: key);

  @override
  State<OverlayWon> createState() => _OverlayWonState();
}

class _OverlayWonState extends State<OverlayWon> {
  bool visibile = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() {
        visibile = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedOpacity(
        opacity: visibile ? 1 : 0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeIn,
        child: Container(
          alignment: Alignment.center,
          color: Colors.black.withOpacity(0.4),
          child: Material(
            color: Colors.transparent,
            child: Text("You have Won !",
                style: GoogleFonts.permanentMarker(
                    color: Colors.white, fontSize: 40)),
          ),
        ),
      ),
    );
  }
}
