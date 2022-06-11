import 'package:chessnomer/utils.dart';

import 'constants.dart';

extension ChessUtils on int {
  bool isInBounds(String axis) {
    if (axis == 'x') {
      return this < Constants.numHorizontalBoxes;
    }
    return this < 10;
  }

  bool isEmpty() {
    return this == 0 || this == EnumChess.suggested.getNumber();
  }

  bool isSuggested() {
    return this == 2;
  }

  bool isBlock() {
    return this == EnumChess.block.getNumber();
  }

  EnumChess getPiece() {
    if (this < EnumChess.values.length) {
      return EnumChess.values[this];
    }
    return EnumChess.blank;
  }

  bool isPieceBlack() {
    final EnumChess enumPiece = getPiece();
    if (enumPiece.toString().contains('black')) {
      return true;
    }
    return false;
  }

  bool isPieceWhite() {
    final EnumChess enumPiece = getPiece();
    if (enumPiece.toString().contains('white')) {
      return true;
    }
    return false;
  }

  bool isChessPiece() {
    final EnumChess enumPiece = getPiece();

    if (enumPiece != EnumChess.blank &&
        enumPiece != EnumChess.block &&
        enumPiece != EnumChess.suggested) {
      return true;
    }
    return false;
  }
}

extension ChessExtensions on EnumChess {
  int getNumber() {
    return EnumChess.values.indexOf(this);
  }
}
