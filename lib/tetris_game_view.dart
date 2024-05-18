import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris/model/tetromino.dart';
import 'package:tetris/util/key_pressing_checker.dart';

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

  KeyPressingChecker leftKeyPressingChecker = KeyPressingChecker();
  KeyPressingChecker rightKeyPressingChecker = KeyPressingChecker();
  KeyPressingChecker downKeyPressingChecker = KeyPressingChecker();

  int currentBlockX = 2;
  int currentBlockY = 0;

  List<List<int>> gameBoard =
      List.generate(20, (columnIndex) => List.generate(10, (rowIndex) => 0));

  int blockWidth(List<List<int>> blockShape) {
    return blockShape
        .map((row) => row.length)
        .reduce((value, element) => value > element ? value : element);
  }

  void fixTetromino() {
    for (int i = 0; i < activeTetromino!.currentShape.shape.length; i++) {
      for (int j = 0; j < activeTetromino!.currentShape.shape[i].length; j++) {
        if (activeTetromino!.currentShape.shape[i][j] != 0) {
          gameBoard[currentBlockY + i][currentBlockX + j] = 1;
        }
      }
    }

    // 가로 줄이 다 찼는지 확인하고 지우는 로직
    for (int i = gameBoard.length - 1; i >= 0; i--) {
      bool isRowFull = true;
      for (int j = 0; j < gameBoard[i].length; j++) {
        if (gameBoard[i][j] == 0) {
          isRowFull = false;
          break;
        }
      }
      if (isRowFull) {
        // 해당 줄을 지우고 윗 줄을 한 칸씩 내림
        for (int k = i; k > 0; k--) {
          gameBoard[k] = List.from(gameBoard[k - 1]);
        }
        // 맨 윗 줄은 비움
        gameBoard[0] = List.generate(10, (index) => 0);
        i++; // 한 줄이 지워졌으므로 다음 줄을 확인하기 위해 인덱스를 증가시킴
      }
    }
  }

  void spawnNewTetromino() {
    activeTetromino = nextTetromino;
    tetrominoBag.shuffle();
    nextTetromino = tetrominoBag.first;
    currentBlockX = 2;
    currentBlockY = 0;

    // 새로운 테트로미노가 충돌하면 게임 오버 처리
    if (checkCollision(
        activeTetromino!, currentBlockX, currentBlockY, gameBoard)) {
      // 게임 오버 로직
    }
  }

  bool checkCollision(
      Tetromino tetromino, int x, int y, List<List<int>> board) {
    for (int i = 0; i < tetromino.currentShape.shape.length; i++) {
      for (int j = 0; j < tetromino.currentShape.shape[i].length; j++) {
        if (tetromino.currentShape.shape[i][j] != 0) {
          int boardX = x + j;
          int boardY = y + i;

          // 보드 경계 확인
          if (boardX < 0 ||
              boardX >= board[0].length ||
              boardY < 0 ||
              boardY >= board.length) {
            return true;
          }

          // 다른 블록과 충돌 확인
          if (board[boardY][boardX] != 0) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void moveBlockDown() {
    bool collision = checkCollision(
      activeTetromino!,
      currentBlockX,
      currentBlockY + 1,
      gameBoard,
    );
    if (collision) {
      fixTetromino();
      spawnNewTetromino();
      return;
    }
    setState(() {
      currentBlockY++;
    });
  }

  void moveBlockLeft() {
    bool collision = checkCollision(
      activeTetromino!,
      currentBlockX - 1,
      currentBlockY,
      gameBoard,
    );
    if (collision) {
      return;
    }
    setState(() {
      currentBlockX--;
    });
  }

  void moveBlockToLeftWall() {
    setState(() {
      currentBlockX = 0;
    });
  }

  void moveBlockRight() {
    bool collision = checkCollision(
      activeTetromino!,
      currentBlockX + 1,
      currentBlockY,
      gameBoard,
    );
    if (collision) {
      return;
    }
    setState(() {
      currentBlockX++;
    });
  }

  void moveBlockToRightWall() {
    setState(() {
      currentBlockX = 7;
    });
  }

  void fallBlock() {
    bool collision = false;
    int fallIndex = 0;
    while (!collision) {
      collision = checkCollision(
        activeTetromino!,
        currentBlockX,
        fallIndex + 2,
        gameBoard,
      );
      fallIndex++;
    }
    setState(() {
      currentBlockY = fallIndex;
    });
  }

  void reset() {
    currentBlockY = 0;
    currentBlockX = 0;
  }

  bool keyUpEvent(KeyUpEvent event) {
    switch (event.logicalKey.keyLabel) {
      case "A":
        leftKeyPressingChecker.isPressing = false;
        leftKeyPressingChecker.cancelTimer;
        break;
      case "D":
        rightKeyPressingChecker.isPressing = false;
        rightKeyPressingChecker.cancelTimer;
        break;
      case "S":
        downKeyPressingChecker.isPressing = false;
        downKeyPressingChecker.cancelTimer;
        break;
      default:
        return false;
    }
    return true;
  }

  bool keyDownEvent(KeyDownEvent event) {
    switch (event.logicalKey.keyLabel) {
      case "A":
        moveBlockLeft();
        leftKeyPressingChecker.isPressing = true;
        leftKeyPressingChecker.setTimer(moveBlockLeft);
        break;
      case "D":
        moveBlockRight();
        rightKeyPressingChecker.isPressing = true;
        rightKeyPressingChecker.setTimer(moveBlockRight);
        break;
      case "S":
        moveBlockDown();
        downKeyPressingChecker.isPressing = true;
        downKeyPressingChecker.setTimer(moveBlockDown);

        break;
      case "W":
        setState(() {
          activeTetromino?.rotate();
        });

      case "X":
        fallBlock();
        break;
      default:
        return false;
    }
    return true;
  }

  bool keyboardHandler(KeyEvent event) {
    if (event is KeyUpEvent) {
      keyUpEvent(event);
    }

    if (event is KeyDownEvent) {
      keyDownEvent(event);
    }
    return false;
  }

  @override
  void initState() {
    HardwareKeyboard.instance.addHandler(keyboardHandler);
    super.initState();
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(keyboardHandler);
    super.dispose();
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
                  width: 210,
                  height: 420,
                  color: Colors.grey,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          for (List<int> rowList in gameBoard)
                            Row(
                              children: [
                                for (int row in rowList)
                                  Container(
                                    width: 19,
                                    height: 19,
                                    color:
                                        row == 0 ? Colors.white : Colors.blue,
                                    margin: const EdgeInsets.all(1),
                                  ),
                              ],
                            ),
                        ],
                      ),
                      // 현재 블록 그리기
                      if (activeTetromino != null)
                        Positioned(
                          top: currentBlockY * 21,
                          left: currentBlockX * 21,
                          // top: 0,
                          // left: 0,
                          child: SizedBox(
                            child: Column(
                              children: [
                                for (List<int> rowList
                                    in activeTetromino!.currentShape.shape)
                                  Row(
                                    children: [
                                      for (int row in rowList)
                                        Container(
                                          width: 19,
                                          height: 19,
                                          color: row == 0
                                              ? Colors.transparent
                                              : activeTetromino!.type.color,
                                          margin: const EdgeInsets.all(1),
                                        ),
                                    ],
                                  ),
                              ],
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
