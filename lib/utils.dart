import 'package:chessnomer/extensions.dart';
import 'package:chessnomer/game/widgets/cell.dart';
import 'package:chessnomer/providers/provider_game.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'constants.dart';

enum EnumChess {
  blank,
  block,
  suggested,
  whiteKing,
  whiteQueen,
  whiteBishop,
  whiteKnight,
  whiteRook,
  whitePawn,
  blackKing,
  blackQueen,
  blackBishop,
  blackKnight,
  blackRook,
  blackPawn,
}

enum UniqueChessPieces { king, queen, bishop, knight, rook, pawn }

class Utils {
  static Widget iconWidget(IconData iconData, double cellSize,
      {Color color = Colors.white, double size = -1}) {
    return Icon(iconData, color: color, size: size == -1 ? cellSize - 5 : size);
  }

  static Widget getIcon(EnumChess piece, double cellSize) {
    switch (piece) {
      case EnumChess.blank:
        return const SizedBox();
      case EnumChess.block:
        return iconWidget(FontAwesomeIcons.squareXmark, cellSize,
            color: Colors.black, size: cellSize - 2);
      case EnumChess.suggested:
        return const CellSuggested();
      case EnumChess.whiteKing:
        return iconWidget(FontAwesomeIcons.solidChessKing, cellSize,
            color: Colors.white);
      case EnumChess.whiteQueen:
        return iconWidget(FontAwesomeIcons.solidChessQueen, cellSize,
            color: Colors.white);
      case EnumChess.whiteBishop:
        return iconWidget(FontAwesomeIcons.solidChessBishop, cellSize,
            color: Colors.white);
      case EnumChess.whiteKnight:
        return iconWidget(FontAwesomeIcons.solidChessKnight, cellSize,
            color: Colors.white);
      case EnumChess.whiteRook:
        return iconWidget(FontAwesomeIcons.solidChessRook, cellSize,
            color: Colors.white);
      case EnumChess.whitePawn:
        return iconWidget(FontAwesomeIcons.solidChessPawn, cellSize,
            color: Colors.white);
      case EnumChess.blackKing:
        return iconWidget(FontAwesomeIcons.solidChessKing, cellSize,
            color: Colors.black);
      case EnumChess.blackQueen:
        return iconWidget(FontAwesomeIcons.solidChessQueen, cellSize,
            color: Colors.black);
      case EnumChess.blackBishop:
        return iconWidget(FontAwesomeIcons.solidChessBishop, cellSize,
            color: Colors.black);
      case EnumChess.blackKnight:
        return iconWidget(FontAwesomeIcons.solidChessKnight, cellSize,
            color: Colors.black);
      case EnumChess.blackRook:
        return iconWidget(FontAwesomeIcons.solidChessRook, cellSize,
            color: Colors.black);
      case EnumChess.blackPawn:
        return iconWidget(FontAwesomeIcons.solidChessPawn, cellSize,
            color: Colors.black);
    }
  }

  //All possible moves of a piece
  static List<Position> getPossibleMove(
      List<List<int>> board, Position position) {
    EnumChess piece = board[position.y][position.x].getPiece();
    List<Position> toReturn = [];
    switch (piece) {
      case EnumChess.blank:
      case EnumChess.block:
      case EnumChess.suggested:
      case EnumChess.blackKing:
      case EnumChess.blackQueen:
      case EnumChess.blackBishop:
      case EnumChess.blackKnight:
      case EnumChess.blackRook:
      case EnumChess.blackPawn:
      case EnumChess.whitePawn:
        return [];
      case EnumChess.whiteKing:
        for (int i = -1; i < 2; i++) {
          for (int j = -1; j < 2; j++) {
            final Position pos1 = Position(position.x + i, position.y + j);
            if (pos1.isValid() &&
                (board[pos1.y][pos1.x].isEmpty() ||
                    board[pos1.y][pos1.x].isPieceBlack())) {
              toReturn.add(pos1);
            }
          }
        }
        return toReturn;
      case EnumChess.whiteKnight:
        final Position pos1 = Position(position.x - 1, position.y - 2);
        if (pos1.isValid() &&
            (board[pos1.y][pos1.x].isEmpty() ||
                board[pos1.y][pos1.x].isPieceBlack())) {
          toReturn.add(pos1);
        }
        final Position pos2 = Position(position.x + 1, position.y - 2);
        if (pos2.isValid() &&
            (board[pos2.y][pos2.x].isEmpty() ||
                board[pos2.y][pos2.x].isPieceBlack())) {
          toReturn.add(pos2);
        }
        final Position pos3 = Position(position.x - 1, position.y + 2);
        if (pos3.isValid() &&
            (board[pos3.y][pos3.x].isEmpty() ||
                board[pos3.y][pos3.x].isPieceBlack())) {
          toReturn.add(pos3);
        }
        final Position pos4 = Position(position.x + 1, position.y + 2);
        if (pos4.isValid() &&
            (board[pos4.y][pos4.x].isEmpty() ||
                board[pos4.y][pos4.x].isPieceBlack())) {
          toReturn.add(pos4);
        }

        final Position pos5 = Position(position.x + 2, position.y + 1);
        if (pos5.isValid() &&
            (board[pos5.y][pos5.x].isEmpty() ||
                board[pos5.y][pos5.x].isPieceBlack())) {
          toReturn.add(pos5);
        }

        final Position pos6 = Position(position.x + 2, position.y - 1);
        if (pos6.isValid() &&
            (board[pos6.y][pos6.x].isEmpty() ||
                board[pos6.y][pos6.x].isPieceBlack())) {
          toReturn.add(pos6);
        }

        final Position pos7 = Position(position.x - 2, position.y - 1);
        if (pos7.isValid() &&
            (board[pos7.y][pos7.x].isEmpty() ||
                board[pos7.y][pos7.x].isPieceBlack())) {
          toReturn.add(pos7);
        }

        final Position pos8 = Position(position.x - 2, position.y + 1);
        if (pos8.isValid() &&
            (board[pos8.y][pos8.x].isEmpty() ||
                board[pos8.y][pos8.x].isPieceBlack())) {
          toReturn.add(pos8);
        }
        return toReturn;
      case EnumChess.whiteQueen:
        return [
          ...getPossibleDiagonals(board, position),
          ...getPossibleStraights(board, position)
        ];
      case EnumChess.whiteBishop:
        return getPossibleDiagonals(board, position);
      case EnumChess.whiteRook:
        return getPossibleStraights(board, position);
    }
  }

  static List<Position> getPossibleStraights(
      List<List<int>> board, Position position) {
    List<Position> toReturn = [];
    //Left all the way
    for (int i = position.x - 1; i != -1; i--) {
      if (board[position.y][i].isEmpty()) {
        toReturn.add(Position(i, position.y));
      } else if (board[position.y][i].isPieceBlack()) {
        toReturn.add(Position(i, position.y));
        break;
      } else {
        break;
      }
    }
    //Right all the way
    for (int i = position.x + 1; i != Constants.numHorizontalBoxes; i++) {
      if (board[position.y][i].isEmpty()) {
        toReturn.add(Position(i, position.y));
      } else if (board[position.y][i].isPieceBlack()) {
        toReturn.add(Position(i, position.y));
        break;
      } else {
        break;
      }
    }

    //Bottom all the way
    for (int i = position.y + 1; i != 10; i++) {
      if (board[i][position.x].isEmpty()) {
        toReturn.add(Position(position.x, i));
      } else if (board[i][position.x].isPieceBlack()) {
        toReturn.add(Position(position.x, i));
        break;
      } else {
        break;
      }
    }
    //Top all the way
    for (int i = position.y - 1; i != -1; i--) {
      if (board[i][position.x].isEmpty()) {
        toReturn.add(Position(position.x, i));
      } else if (board[i][position.x].isPieceBlack()) {
        toReturn.add(Position(position.x, i));
        break;
      } else {
        break;
      }
    }

    return toReturn;
  }

  static List<Position> getPossibleDiagonals(
      List<List<int>> board, Position position) {
    List<Position> toReturn = [];
    //Bottom right
    for (int i = position.x + 1, j = position.y + 1;
        i != Constants.numHorizontalBoxes && j != 10;
        i++, j++) {
      if (board[j][i].isEmpty()) {
        toReturn.add(Position(i, j));
      } else if (board[j][i].isPieceBlack()) {
        toReturn.add(Position(i, j));
        break;
      } else {
        break;
      }
    }
    //Top right
    for (int i = position.x + 1, j = position.y - 1;
        i != Constants.numHorizontalBoxes && j != -1;
        i++, j--) {
      if (board[j][i].isEmpty()) {
        toReturn.add(Position(i, j));
      } else if (board[j][i].isPieceBlack()) {
        toReturn.add(Position(i, j));
        break;
      } else {
        break;
      }
    }
    //Bottom left
    for (int i = position.x - 1, j = position.y + 1;
        i != -1 && j != 10;
        i--, j++) {
      if (board[j][i].isEmpty()) {
        toReturn.add(Position(i, j));
      } else if (board[j][i].isPieceBlack()) {
        toReturn.add(Position(i, j));
        break;
      } else {
        break;
      }
    }
    //Top left
    for (int i = position.x - 1, j = position.y - 1;
        i != -1 && j != -1;
        i--, j--) {
      if (board[j][i].isEmpty()) {
        toReturn.add(Position(i, j));
      } else if (board[j][i].isPieceBlack()) {
        toReturn.add(Position(i, j));
        break;
      } else {
        break;
      }
    }
    return toReturn;
  }
}
