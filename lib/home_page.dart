import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import './blank_pixel.dart';
import './snake_pixel.dart';
import './food_pixel.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum SnakeDirection { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  //Grid Dimenstions
  int rowSize = 10;
  int totalNumberOfSquares = 100;

  //Snake Pos
  List<int> snakePos = [0, 1, 2];

  //Food Pos
  int foodPos = 55;

  //Snake Direction
  var snakeDirection = SnakeDirection.RIGHT;

  //Start Game
  void startGame() {
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        moveSnake();
        //check if game id over
        if (gameOver()) {
          timer.cancel();
          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text("Game Over"),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          snakePos = [0, 1, 2];
                          foodPos = 55;
                          snakeDirection = SnakeDirection.RIGHT;
                        });
                      },
                      child: const Text("Restart Game"),
                    )
                  ],
                );
              });
        }
      });
    });
  }

  void eatFood() {
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(totalNumberOfSquares);
    }
  }

  bool gameOver() {
    List<int> bodySnake = snakePos.sublist(0, snakePos.length - 1);
    if (bodySnake.contains(snakePos.last)) {
      return true;
    } else {
      return false;
    }
  }

  void moveSnake() {
    switch (snakeDirection) {
      case SnakeDirection.RIGHT:
        {
          //If snake is at the last of the row, readjest
          if (snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            //add new head
            snakePos.add(snakePos.last + 1);
          }
        }
        break;

      case SnakeDirection.LEFT:
        {
          //If snake is at the last of the row, readjest
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            //add new head
            snakePos.add(snakePos.last - 1);
          }
        }
        break;

      case SnakeDirection.DOWN:
        {
          //IF snake is at last down , readjust
          if (snakePos.last + rowSize > totalNumberOfSquares) {
            snakePos.add(snakePos.last + rowSize - totalNumberOfSquares);
          } else {
            //add new head
            snakePos.add(snakePos.last + rowSize);
          }
        }
        break;

      case SnakeDirection.UP:
        {
          //If snake head is at very top, readjust
          if (snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + totalNumberOfSquares);
          } else {
            //add new head
            snakePos.add(snakePos.last - rowSize);
          }
        }
        break;
      default:
    }
    if (snakePos.last == foodPos) {
      eatFood();
    } else {
//remove the tail
      snakePos.removeAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          //totalscore section
          Expanded(
            child: Container(),
          ),
          //Game space
          Expanded(
            flex: 3,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 &&
                    snakeDirection != SnakeDirection.UP) {
                  setState(() {
                    snakeDirection = SnakeDirection.DOWN;
                  });
                } else if (details.delta.dy < 0 &&
                    snakeDirection != SnakeDirection.DOWN) {
                  setState(() {
                    snakeDirection = SnakeDirection.UP;
                  });
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0 &&
                    snakeDirection != SnakeDirection.LEFT) {
                  setState(() {
                    snakeDirection = SnakeDirection.RIGHT;
                  });
                } else if (details.delta.dx < 0 &&
                    snakeDirection != SnakeDirection.RIGHT) {
                  setState(() {
                    snakeDirection = SnakeDirection.LEFT;
                  });
                }
              },
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowSize,
                ),
                itemCount: totalNumberOfSquares,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  if (snakePos.contains(index)) {
                    return const SnakePixel();
                  } else if (foodPos == index) {
                    return const FoodPixel();
                  } else {
                    return BlankPixel();
                  }
                },
              ),
            ),
          ),
          //Playbutton
          Expanded(
            child: Container(
              child: Center(
                child: MaterialButton(
                  onPressed: () => startGame(),
                  child: Text("PLAY"),
                  color: Colors.pink,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
