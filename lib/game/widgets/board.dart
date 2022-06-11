import 'package:chessnomer/constants.dart';
import 'package:chessnomer/game/widgets/cell.dart';
import 'package:chessnomer/providers/provider_game.dart';
import 'package:chessnomer/providers/provider_prefs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../config.dart';

class Board extends StatelessWidget {
  const Board({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      color: const Color.fromARGB(255, 105, 75, 31),
      child: Stack(
        children: [
          //Settings
          Align(
            child: Container(
                height: screenSize.height,
                width: (screenSize.width -
                        context.read<ProviderPrefs>().cellSize *
                            Constants.numHorizontalBoxes) /
                    2,
                color: const Color.fromARGB(255, 141, 102, 42),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text("Menu",
                        style: GoogleFonts.permanentMarker(
                            fontSize: 20, color: Colors.white)),
                    const SizedBox(
                      height: 20,
                    ),
                    IconButton(
                        onPressed: () {
                          ProviderGame prov = context.read<ProviderGame>();
                          prov.setLevel(prov.currentLevel);
                        },
                        icon: const Icon(FontAwesomeIcons.rotate,
                            color: Colors.white, size: 30)),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          ProviderGame prov = context.read<ProviderGame>();
                          prov.switchMusic();
                        },
                        icon: Selector<ProviderGame, bool>(
                            selector: (p0, p1) => p1.isMusicAllowed,
                            builder: (context, isMusicAllowed, _) {
                              return Icon(
                                  isMusicAllowed
                                      ? FontAwesomeIcons.volumeHigh
                                      : FontAwesomeIcons.volumeXmark,
                                  color: Colors.white,
                                  size: 30);
                            })),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )),
            alignment: Alignment.centerLeft,
          ),
          //Levels
          Align(
            child: Container(
              height: screenSize.height,
              width: (screenSize.width -
                      context.read<ProviderPrefs>().cellSize *
                          Constants.numHorizontalBoxes) /
                  2,
              color: const Color.fromARGB(255, 141, 102, 42),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text("Levels !",
                        style: GoogleFonts.permanentMarker(
                            fontSize: 20, color: Colors.white)),
                    const SizedBox(
                      height: 10,
                    ),
                    for (int i = 0; i < Config.levels.length; i++)
                      IconButton(
                          onPressed: () {
                            context.read<ProviderGame>().setLevel(i);
                          },
                          icon: Selector<ProviderGame, int>(
                              selector: (p0, p1) => p1.currentLevel,
                              builder: (context, currentLevel, _) {
                                return Container(
                                    height: 30,
                                    width: 30,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: currentLevel == i
                                            ? Colors.blue
                                            : Colors.white),
                                    child: Text("${i + 1}",
                                        style: GoogleFonts.permanentMarker(
                                            fontSize: 20,
                                            color: currentLevel == i
                                                ? Colors.white
                                                : Colors.black)));
                              }))
                  ],
                ),
              ),
            ),
            alignment: Alignment.centerRight,
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (int ind = 0; ind < Constants.numVerticalBoxes; ind++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int index = 0;
                          index < Constants.numHorizontalBoxes;
                          index++)
                        Consumer<ProviderGame>(builder: (context, game, _) {
                          return Cell(
                            key: context.read<ProviderGame>().boardKeys[ind]
                                [index],
                            index: index + (ind * Constants.numHorizontalBoxes),
                            item: game.board[ind][index],
                            onTap: () {
                              context
                                  .read<ProviderGame>()
                                  .onCellTapped(index, ind, context);
                            },
                          );
                        })
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
