import 'package:chessnomer/constants.dart';
import 'package:chessnomer/game/widgets/board.dart';
import 'package:chessnomer/providers/provider_prefs.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

import '../providers/provider_game.dart';

class ScreenGame extends StatefulWidget {
  const ScreenGame({Key? key}) : super(key: key);

  @override
  State<ScreenGame> createState() => _ScreenGameState();
}

class _ScreenGameState extends State<ScreenGame> {
  @override
  void initState() {
    super.initState();
    //Load The Game level from db
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProviderGame>().playMusic();
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProviderGame>().setLevel(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.white, body: Board());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ProviderPrefs>().setCellSize(context);
  }
}
