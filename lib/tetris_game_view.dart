import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tetris/model/tetromino.dart';

class TetrisGameView extends StatefulWidget {
  const TetrisGameView({super.key});

  @override
  State<TetrisGameView> createState() => _TetrisGameViewState();
}

class _TetrisGameViewState extends State<TetrisGameView> {
  List<Tetromino> tetrominoBag =
      TetrominoType.values.map((e) => Tetromino(type: e)).toList()..shuffle();
  late Tetromino? activeTetromino = tetrominoBag.first;
  late Tetromino? nextTetromino = tetrominoBag[1];
  List<List<int>> gameBoard =
      List.generate(20, (i) => List.generate(10, (j) => 0));
  int currentBlockX = 2;
  int currentBlockY = 0;

  int blockWidth(List<List<int>> blockShape) {
    return blockShape
        .map((row) => row.length)
        .reduce((value, element) => value > element ? value : element);
  }

  void moveBlockDown() {
    currentBlockY++;
  }

  void moveBlockLeft() {
    currentBlockX--;
  }

  void moveBlockRight() {
    currentBlockX++;
  }

  void reset() {
    currentBlockX = 0;
    currentBlockY = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tetris'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 400,
                  color: Colors.grey,
                  child: Stack(
                    children: [
                      // 게임 보드 그리기
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 200,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          int row = index ~/ 10;
                          int col = index % 10;
                          return Container(
                            color: gameBoard[row][col] == 0
                                ? Colors.white
                                : Colors.blue,
                            margin: EdgeInsets.all(1),
                          );
                        },
                      ),
                      // 현재 블록 그리기
                      if (activeTetromino != null)
                        Positioned(
                          top: currentBlockY * 20.0,
                          left: currentBlockX * 20.0,
                          child: Container(
                            width: 80,
                            height: 80,
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 16,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                int row = index ~/ 4;
                                int col = index % 4;
                                return Container(
                                  color: activeTetromino!
                                              .currentShape.shape[row][col] ==
                                          0
                                      ? Colors.transparent
                                      : activeTetromino!.type.color,
                                  margin: EdgeInsets.all(1),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentBlockY = 17;
                    });
                  },
                  child: Text('Full Down'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      moveBlockDown();
                    });
                  },
                  child: Text('Move Down'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      moveBlockLeft();
                    });
                  },
                  child: Text('Move Left'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      moveBlockRight();
                    });
                  },
                  child: Text('Move Right'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      reset();
                    });
                  },
                  child: Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      activeTetromino?.rotate();
                      // rotateLeft(blockShape);
                    });
                  },
                  child: Text('rocate left'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      activeTetromino?.rotate();
                      // rotateRight(blockShape);
                    });
                  },
                  child: Text('rocate right'),
                ),
              ],
            ),
            Column(
              children: [
                Text("Next"),
                SizedBox(
                  width: 80,
                  height: 80,
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 16,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      int row = index ~/ 4;
                      int col = index % 4;
                      return Container(
                        color: nextTetromino!.currentShape.shape[row][col] == 0
                            ? Colors.transparent
                            : nextTetromino!.type.color,
                        margin: EdgeInsets.all(1),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
