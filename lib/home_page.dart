import 'package:flutter/material.dart';

import './blank_pixel.dart';
import './snake_pixel.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Grid Dimenstions
  int rowSize = 10;
  int totalNumberOfSquares = 100;

  //Snake index;s
  List<int> snakePos = [0, 1, 2];

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
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rowSize,
              ),
              itemCount: totalNumberOfSquares,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                if (snakePos.contains(index)) {
                  return SnakePixel();
                } else {
                  return BlankPixel();
                }
              },
            ),
          ),
          //Playbutton
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}
