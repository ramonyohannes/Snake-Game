import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Grid Dimenstions
  int rowSize = 10;
  int totalNumberOfSquares = 100;

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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.white,
                  ),
                );
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
