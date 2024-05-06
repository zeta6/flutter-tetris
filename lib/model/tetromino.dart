import 'package:flutter/material.dart';

class BlockShape {
  const BlockShape(this.shape);
  final List<List<int>> shape;
}

enum TetrominoType {
  i(
    color: Colors.cyan,
    blockShapes: [
      BlockShape(
        [
          [0, 0, 0, 0],
          [1, 1, 1, 1],
          [0, 0, 0, 0],
          [0, 0, 0, 0]
        ],
      ),
      BlockShape(
        [
          [0, 0, 1, 0],
          [0, 0, 1, 0],
          [0, 0, 1, 0],
          [0, 0, 1, 0]
        ],
      ),
    ],
  ),
  t(
    color: Colors.deepPurple,
    blockShapes: [
      BlockShape(
        [
          [0, 0, 0, 0],
          [0, 1, 1, 1],
          [0, 0, 1, 0],
          [0, 0, 0, 0]
        ],
      ),
      BlockShape(
        [
          [0, 0, 1, 0],
          [0, 0, 1, 1],
          [0, 0, 1, 0],
          [0, 0, 0, 0]
        ],
      ),
      BlockShape(
        [
          [0, 0, 1, 0],
          [0, 1, 1, 1],
          [0, 0, 0, 0],
          [0, 0, 0, 0]
        ],
      ),
      BlockShape(
        [
          [0, 0, 1, 0],
          [0, 1, 1, 0],
          [0, 0, 1, 0],
          [0, 0, 0, 0]
        ],
      ),
    ],
  ),
  o(
    color: Colors.yellow,
    blockShapes: [
      BlockShape(
        [
          [0, 0, 0, 0],
          [0, 1, 1, 0],
          [0, 1, 1, 0],
          [0, 0, 0, 0]
        ],
      ),
    ],
  ),
  z(
    color: Colors.red,
    blockShapes: [
      BlockShape(
        [
          [0, 0, 0, 0],
          [0, 1, 1, 0],
          [0, 0, 1, 1],
          [0, 0, 0, 0]
        ],
      ),
      BlockShape(
        [
          [0, 0, 0, 1],
          [0, 0, 1, 1],
          [0, 0, 1, 0],
          [0, 0, 0, 0]
        ],
      ),
    ],
  ),
  s(
    color: Colors.green,
    blockShapes: [
      BlockShape(
        [
          [0, 0, 0, 0],
          [0, 0, 1, 1],
          [0, 1, 1, 0],
          [0, 0, 0, 0]
        ],
      ),
      BlockShape(
        [
          [0, 0, 1, 0],
          [0, 0, 1, 1],
          [0, 0, 0, 1],
          [0, 0, 0, 0]
        ],
      ),
    ],
  ),
  l(
    color: Colors.blue,
    blockShapes: [
      BlockShape(
        [
          [0, 0, 0, 0],
          [0, 1, 1, 1],
          [0, 1, 0, 0],
          [0, 0, 0, 0]
        ],
      ),
      BlockShape(
        [
          [0, 0, 1, 0],
          [0, 0, 1, 0],
          [0, 0, 1, 1],
          [0, 0, 0, 0]
        ],
      ),
      BlockShape(
        [
          [0, 0, 0, 1],
          [0, 1, 1, 1],
          [0, 0, 0, 0],
          [0, 0, 0, 0]
        ],
      ),
      BlockShape(
        [
          [0, 1, 1, 0],
          [0, 0, 1, 0],
          [0, 0, 1, 0],
          [0, 0, 0, 0]
        ],
      ),
    ],
  ),
  j(
    color: Colors.orange,
    blockShapes: [
      BlockShape(
        [
          [0, 0, 0, 0],
          [0, 1, 1, 1],
          [0, 0, 0, 1],
          [0, 0, 0, 0]
        ],
      ),
      BlockShape(
        [
          [0, 0, 1, 1],
          [0, 0, 1, 0],
          [0, 0, 1, 0],
          [0, 0, 0, 0]
        ],
      ),
      BlockShape(
        [
          [0, 1, 0, 0],
          [0, 1, 1, 1],
          [0, 0, 0, 0],
          [0, 0, 0, 0]
        ],
      ),
      BlockShape(
        [
          [0, 0, 1, 0],
          [0, 0, 1, 0],
          [0, 1, 1, 0],
          [0, 0, 0, 0]
        ],
      ),
    ],
  );

  const TetrominoType({
    required this.blockShapes,
    required this.color,
  });
  final List<BlockShape> blockShapes;
  final Color color;
}

class Tetromino {
  Tetromino({
    required this.type,
  });

  TetrominoType type;
  int currentShapeIndex = 0;

  int get maxShapeIndex => type.blockShapes.length;

  BlockShape get currentShape => type.blockShapes[currentShapeIndex];

  void rotate() {
    if (currentShapeIndex + 1 == maxShapeIndex) {
      currentShapeIndex = 0;
    } else {
      currentShapeIndex++;
    }
  }
}
