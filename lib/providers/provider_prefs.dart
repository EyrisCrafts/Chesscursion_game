import 'package:chessnomer/constants.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProviderPrefs extends ChangeNotifier {
  double cellSize = 0;
  ProviderPrefs();

  //Cell size must be small enough to allow side tabs to be at least 120 px
  void setCellSize(BuildContext context) {
    if (cellSize != 0) return;
    Size screenSize = MediaQuery.of(context).size;

    double height = screenSize.height;
    double properCellSize = calculateCellSize(height, screenSize.width);
    double sideBarSize = calculateSideBarSize(screenSize.width, properCellSize);
    while (sideBarSize < 65) {
      height = height - 2;
      properCellSize = calculateCellSize(height, screenSize.width);
      sideBarSize = calculateSideBarSize(screenSize.width, properCellSize);
    }
    cellSize = properCellSize = calculateCellSize(height, screenSize.width);
  }

  double calculateCellSize(double screenHeight, double screenWidth) {
    double height = (screenHeight) / Constants.numVerticalBoxes;
    double width = screenWidth / Constants.numHorizontalBoxes;
    double size = math.min(height, width);
    return size.floor().toDouble();
  }

  double calculateSideBarSize(double screenWidth, double cellSize) =>
      (screenWidth - cellSize * Constants.numHorizontalBoxes) / 2;
}
