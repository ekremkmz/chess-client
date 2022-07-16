import 'package:chess/logic/cubit/game_board_logic/piece_color.dart';
import 'package:flutter/material.dart';

class PawnPromoteDialog extends StatelessWidget {
  const PawnPromoteDialog({
    required this.color,
    super.key,
  });

  final PieceColor color;

  @override
  Widget build(BuildContext context) {
    final isWhite = color == PieceColor.white;
    final prefix = isWhite ? "white" : "black";
    final assets = [
      "${prefix}_queen",
      "${prefix}_rook",
      "${prefix}_bishop",
      "${prefix}_knight",
    ];
    final results = isWhite ? ["Q", "W", "B", "K"] : ["q", "w", "b", "k"];
    final data = Map.fromIterables(assets, results);
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: data.entries
              .map(
                (e) => Flexible(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: InkWell(
                      child: Card(
                        margin: const EdgeInsets.all(8),
                        color: Colors.grey,
                        child: Image(
                          image:
                              AssetImage("assets/images/pieces/${e.key}.png"),
                        ),
                      ),
                      onTap: () {
                        Navigator.maybePop(context, e.value);
                      },
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
