import 'package:chessnomer/constants.dart';
import 'package:chessnomer/extensions.dart';
import 'package:chessnomer/providers/provider_prefs.dart';
import 'package:chessnomer/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cell extends StatelessWidget {
  const Cell(
      {Key? key, required this.index, required this.item, required this.onTap})
      : super(key: key);
  final int index;
  final int item;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    double cellSize = context.read<ProviderPrefs>().cellSize;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: cellSize,
        width: cellSize,
        alignment: Alignment.center,
        child: Utils.getIcon(item.getPiece(), cellSize),
        decoration: BoxDecoration(
            color: ((index + (index ~/ Constants.numHorizontalBoxes)) % 2) == 0
                ? Constants.cellColorLight
                : Constants.cellColorDark),
      ),
    );
  }
}

class CellSuggested extends StatelessWidget {
  const CellSuggested({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cellSize = context.read<ProviderPrefs>().cellSize;
    return Container(
      height: cellSize - 10,
      width: cellSize - 10,
      decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.2), shape: BoxShape.circle),
    );
  }
}
