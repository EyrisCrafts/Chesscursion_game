import 'package:audioplayers/audioplayers.dart';
import 'package:chessnomer/config.dart';
import 'package:chessnomer/constants.dart';
import 'package:chessnomer/overlays/overlay_piece.dart';
import 'package:chessnomer/overlays/overlay_won.dart';
import 'package:chessnomer/providers/provider_prefs.dart';
import 'package:chessnomer/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderGame extends ChangeNotifier {
  List<List<int>> board = [];
  late SelectedPiece selectedPiece;
  List<List<GlobalKey>> boardKeys = [];
  late int currentLevel;
  late AudioPlayer audioBackground;
  late AudioPlayer audioMove;
  late AudioCache audioCacheBackground;
  late AudioCache audioCacheMove;
  bool isMusicAllowed = true;

  void onCellTapped(int x, int y, BuildContext context) {
    if (selectedPiece.isSelected) {
      if (Utils.getPossibleMove(board, selectedPiece.position!)
          .contains(Position(x, y))) {
        board[selectedPiece.position!.y][selectedPiece.position!.x] = 0;
        if (board[y][x].isEmpty()) {
          playMove();
        } else {
          playMove(isKill: true);
        }
        board[y][x] = selectedPiece.selectedPiece!.index;
        notifyListeners();

        //Win check

        winCheckCondition(context);

        //Gravity Check !
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          for (int my = 0; my < 10; my++) {
            for (int mx = 0; mx < Constants.numHorizontalBoxes; mx++) {
              if (!board[my][mx].isEmpty() && !board[my][mx].isBlock()) {
                gravitycheck(context, Position(mx, my));
              }
            }
          }
        });
      }
      selectedPiece.isSelected = false;
      removeSuggestions();
    } else {
      if (board[y][x].isPieceWhite()) {
        selectedPiece.isSelected = true;
        selectedPiece.selectedPiece = board[y][x].getPiece();
        selectedPiece.position = Position(x, y);

        updateSuggestions();
      }
    }
  }

  void setLevel(int level) {
    currentLevel = level;
    board =
        Config.levels[level].map((element) => List<int>.from(element)).toList();
    selectedPiece.isSelected = false;
    notifyListeners();
  }

  void resetGame() {}

  bool blackExists() {
    for (int my = 0; my < 10; my++) {
      for (int mx = 0; mx < Constants.numHorizontalBoxes; mx++) {
        if (board[my][mx].isPieceBlack()) {
          return true;
        }
      }
    }
    return false;
  }

  void winCheckCondition(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (!blackExists()) {
      OverlayEntry entry =
          OverlayEntry(builder: (context) => const OverlayWon());
      Overlay.of(context)!.insert(entry);
      Future.delayed(const Duration(milliseconds: 3000), () {
        entry.remove();
        setLevel(++currentLevel);
      });
    }
  }

  void gravitycheck(
    BuildContext context,
    Position endPos,
  ) {
    //If piece has empty below
    if (!(endPos.y + 1 != 10 && board[endPos.y + 1][endPos.x].isEmpty())) {
      return;
    }
    //Get old piece
    EnumChess piece = board[endPos.y][endPos.x].getPiece();
    board[endPos.y][endPos.x] = 0;
    notifyListeners();
    //Calculat the last position
    int newY = endPos.y + 1;
    while (newY + 1 != 10 && board[newY + 1][endPos.x].isEmpty()) {
      newY++;
    }
    if (newY == 10) newY--;
    OverlayEntry entry;
    entry = OverlayEntry(
        builder: (context) => OverlayPiece(
              start: endPos,
              end: Position(endPos.x, newY),
              piece: piece,
            ));
    Overlay.of(context)!.insert(entry);
    Future.delayed(const Duration(milliseconds: 599), () {
      board[newY][endPos.x] = piece.index;
      notifyListeners();
      entry.remove();
    });
  }

  void removeSuggestions() {
    for (int i = 0; i < Constants.numVerticalBoxes; i++) {
      for (int j = 0; j < Constants.numHorizontalBoxes; j++) {
        if (board[i][j].isSuggested()) {
          board[i][j] = 0;
        }
      }
    }
    notifyListeners();
  }

  void updateSuggestions() {
    List<Position> possibles =
        Utils.getPossibleMove(board, selectedPiece.position!);
    for (Position pos in possibles) {
      if (!board[pos.y][pos.x].isPieceBlack())
        board[pos.y][pos.x] = EnumChess.suggested.getNumber();
    }
    notifyListeners();
    //
  }

  switchMusic() async {
    isMusicAllowed = !isMusicAllowed;
    if (isMusicAllowed) {
      audioBackground = await audioCacheBackground.loop("music.mp3");
    } else {
      audioBackground.stop();
    }
    notifyListeners();
  }

  playMove({bool isKill = false}) async {
    if (!isMusicAllowed) return;
    String music = "move.mp3";
    if (isKill) {
      music = "kill.mp3";
    }
    audioMove = await audioCacheMove.play(music);
    // audioMove.play(music, isLocal: true);
  }

  playMusic() async {
    audioBackground = await audioCacheBackground.play("music.mp3");
    // audioBackground.play("assets/music.mp3", isLocal: true);
  }

  ProviderGame() {
    //Start the Game
    audioCacheBackground = AudioCache();
    audioCacheMove = AudioCache();
    audioBackground = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    audioMove = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    selectedPiece = SelectedPiece();
    for (int i = 0; i < 10; i++) {}
    boardKeys = List.generate(10, (index) {
      return List.generate(
          Constants.numHorizontalBoxes, (index) => GlobalKey());
    });
    //Load the Game
    currentLevel = 0;
    board =
        Config.levels.first.map((element) => List<int>.from(element)).toList();
    // board = [
    //   [
    //     0,
    //     0,
    //     0,
    //     0,
    //     0,
    //     0,
    //     EnumChess.whiteQueen.getNumber(),
    //     0,
    //     0,
    //     0,
    //     EnumChess.blackKnight.getNumber(),
    //     0,
    //     0,
    //     EnumChess.whiteBishop.getNumber(),
    //     0,
    //     0
    //   ],
    //   [
    //     0,
    //     EnumChess.block.getNumber(),
    //     0,
    //     0,
    //     0,
    //     0,
    //     0,
    //     0,
    //     0,
    //     0,
    //     0,
    //     0,
    //     0,
    //     0,
    //     0,
    //     0
    //   ],
    //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    // ];
  }
}

class SelectedPiece {
  bool isSelected = false;
  EnumChess? selectedPiece;
  Position? position;
}

class Position {
  int x;
  int y;
  Position(this.x, this.y);
  bool isValid() {
    return y > -1 && y < 10 && x < Constants.numHorizontalBoxes && x > -1;
  }

  List<double> getAbsolutePosition(BuildContext context) {
    final render = context
        .read<ProviderGame>()
        .boardKeys[y][x]
        .currentContext!
        .findRenderObject() as RenderBox;
    final offset = render.localToGlobal(Offset.zero);

    return [offset.dx, offset.dy];
  }

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }

  @override
  int get hashCode => (x.toString() + y.toString()).hashCode;
}
