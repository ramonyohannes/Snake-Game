import 'dart:async';

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
        snake();
      });
    });
  }

  void snake() {
    switch (snakeDirection) {
      case SnakeDirection.RIGHT:
        {
          //add new head
          snakePos.add(snakePos.last + 1);
          //remove the tail
          snakePos.removeAt(0);
        }
        break;

      case SnakeDirection.LEFT:
        {
          //add new head
          snakePos.add(snakePos.last - 1);
          //remove the tail
          snakePos.removeAt(0);
        }
        break;

      case SnakeDirection.DOWN:
        {
          //add new head
          snakePos.add(snakePos.last + rowSize);
          //remove the tail
          snakePos.removeAt(0);
        }
        break;

      case SnakeDirection.UP:
        {
          //add new head
          snakePos.add(snakePos.last - rowSize);
          //remove the tail
          snakePos.removeAt(0);
        }
        break;
      default:
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
