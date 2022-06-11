import 'package:chessnomer/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/provider_game.dart';
import '../providers/provider_prefs.dart';

class OverlayPiece extends StatefulWidget {
  const OverlayPiece(
      {Key? key, required this.start, required this.end, required this.piece})
      : super(key: key);
  final Position start;
  final Position end;
  final EnumChess piece;

  @override
  State<OverlayPiece> createState() => _OverlayPieceState();
}

class _OverlayPieceState extends State<OverlayPiece> {
  late double top;
  late double left;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    List<double> pos = widget.start.getAbsolutePosition(context);
    top = pos[1];
    left = pos[0];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      List<double> pos = widget.end.getAbsolutePosition(context);
      top = pos[1];
      left = pos[0];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double cellSize = context.read<ProviderPrefs>().cellSize;
    return AnimatedPositioned(
        duration: const Duration(milliseconds: 400),
        curve: Curves.decelerate,
        top: top,
        left: left,
        child: Container(
          height: cellSize,
          width: cellSize,
          alignment: Alignment.center,
          child: Utils.getIcon(widget.piece, cellSize),
        ));
  }
}
