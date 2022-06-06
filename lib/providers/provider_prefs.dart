import 'package:chessnomer/constants.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProviderPrefs extends ChangeNotifier {
  double cellSize = 0;
  ProviderPrefs();
  void setCellSize(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double height = screenSize.height / Constants.numVerticalBoxes;
    double width = screenSize.width / Constants.numHorizontalBoxes;
    double size = math.min(height, width);

    cellSize = size.floor().toDouble();
  }
}
