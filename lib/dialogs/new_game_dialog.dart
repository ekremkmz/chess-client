import 'package:flutter/material.dart';

class NewGameDialog extends StatelessWidget {
  const NewGameDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var selected = "";
    return Dialog(
      backgroundColor: Colors.black,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              children: [
                [1, 0],
                [1, 1],
                [2, 1],
                [3, 2],
                [5, 0],
                [5, 3],
              ]
                  .map((e) => InkWell(
                        onTap: () {
                          Navigator.pop(context, {
                            "time": e[0],
                            "add": e[1],
                            if (selected.isNotEmpty) "color": selected,
                          });
                        },
                        child: _GameChoices(
                          time: e[0],
                          adder: e[1],
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 10),
            StatefulBuilder(builder: (context, setState) {
              return GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selected = "w";
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      color:
                          selected == "w" ? Colors.grey.shade700 : Colors.grey,
                      child: Image.asset("assets/images/pieces/white_king.png"),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selected = "";
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      color:
                          selected == "" ? Colors.grey.shade700 : Colors.grey,
                      child: const Icon(Icons.question_mark),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selected = "b";
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      color:
                          selected == "b" ? Colors.grey.shade700 : Colors.grey,
                      child: Image.asset("assets/images/pieces/black_king.png"),
                    ),
                  ),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}

class _GameChoices extends StatelessWidget {
  const _GameChoices({
    required this.time,
    required this.adder,
    Key? key,
  }) : super(key: key);

  final int time;

  final int adder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey,
      margin: const EdgeInsets.all(8),
      child: Center(
        child: Text(
          "$time + $adder",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
