import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import './blank_pixel.dart';
import './snake_pixel.dart';
import './food_pixel.dart';
import './Landing_page.dart';

class HomePage extends StatefulWidget {
  //HomePage({Key? key}) : super(key: key);
  int speed;
  HomePage(this.speed);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum SnakeDirection { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  //Grid Dimenstions
  int rowSize = 10;
  int totalNumberOfSquares = 100;
  //int speed = 200;

  //Snake Pos
  List<int> snakePos = [0, 1, 2];

  //Food Pos
  int foodPos = 55;

  //Snake Direction
  var snakeDirection = SnakeDirection.RIGHT;

  //Start Game
  void startGame(bool status) {
    Timer.periodic(Duration(milliseconds: int.parse(widget.speed.toString())),
        (timer) {
      setState(() {
        moveSnake();
        print(widget.speed.toString());

        //check if game id over
        if (gameOver() || !status) {
          timer.cancel();
          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text("Game Over"),
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
          if (widget.speed == 300) {
            if (snakePos.last % rowSize == 9) {
              startGame(false);
            }
          }
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
    int totalScore = snakePos.length;
    return Scaffold(
      appBar: AppBar(
        title: Text('data'),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          //totalscore section
          Expanded(
            child: Container(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const Text("Total Score"),
                    Text(
                      snakePos.length == 3
                          ? "0"
                          : (snakePos.length - 3).toString(),
                    )
                  ],
                ),
              ),
            ),
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
                  onPressed: () => startGame(true),
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
