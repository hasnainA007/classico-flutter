import 'package:flutter/material.dart';

class MyCoverScreen extends StatelessWidget {
  final bool gameHasStarted;

  MyCoverScreen({required this.gameHasStarted});

  @override
  Widget build(BuildContext context) {
    return gameHasStarted
        ? Container() // You can customize this part if needed
        : Center(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/images/coverbird.png"),
                ),
              ),
              width: 1000, // Adjust the width as needed
              height: 1000, // Adjust the height as needed
              // You can add padding or other styling as needed
            ),
          );
  }
}
