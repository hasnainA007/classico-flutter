import 'dart:async';
//import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:classico/bird.dart';
import 'package:classico/barrier.dart';
import 'package:classico/coverscreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -4.9;
  double velocity = 3.5;
  double birdWidth = 0.1;
  double birdHeight = 0.1;
  //bool playSounds = true;
  //double soundVolume = 0.1;

  bool gameHasStarted = false;
  int score = 0;
  int bestScore = 0;
  int barrierCount = 0;

  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.2;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6],
  ];
  void startGame() {
    gameHasStarted = true;
    // playSounds = true;
    // FlameAudio.play('lib/sounds/pickupCoin.wav', volume: soundVolume);
    score = 0;
    Timer.periodic(Duration(milliseconds: 25), (timer) {
      height = gravity * time * time + velocity * time;

      setState(() {
        birdY = initialPos - height;
      });

      if (birdIsDead()) {
        timer.cancel();

        _showDialog();
      }
      moveMap();

      time += 0.01;
    });
  }

  void moveMap() {
    double speedIncreaseFactor =
        0.0003; // Adjust this value based on how fast you want the speed to increase
    double speed = 0.009 + speedIncreaseFactor * barrierCount;

    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= speed;
      });

      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
        barrierCount++;
        score++;
      }
    }

    if (score > bestScore) {
      bestScore = score;
    }
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdY = 0;
      initialPos = 0;
      gameHasStarted = false;
      time = 0;
      score = 0;
      int barrierCount = 0;
      barrierX = [2, 2 + 1.5];
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: Center(
            child: Text(
              "G A M E  O V E R",
              style: TextStyle(color: Colors.white),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Score: $score',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Best Score: $bestScore',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: resetGame,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: EdgeInsets.all(7),
                  color: Colors.white,
                  child: Text(
                    'PLAY  AGAIN',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  bool birdIsDead() {
    if (birdY < -1 || birdY > 1) {
      return true;
    }

    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.lightBlue[200],
                child: Center(
                  child: Stack(
                    children: [
                      MyBird(
                        birdY: birdY,
                        birdWidth: birdWidth,
                        birdHeight: birdHeight,
                      ),
                      MyCoverScreen(gameHasStarted: gameHasStarted),
                      MyBarrier(
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][0],
                        isThisBottomBarrier: false,
                      ),
                      MyBarrier(
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][1],
                        isThisBottomBarrier: true,
                      ),
                      MyBarrier(
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][0],
                        isThisBottomBarrier: false,
                      ),
                      MyBarrier(
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][1],
                        isThisBottomBarrier: true,
                      ),
                      Container(
                        alignment: Alignment(0, -0.5),
                        child: Text(
                          gameHasStarted ? '' : 'T A P  T O  P L A Y',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 5, // Thin line height
              color: Colors.brown[100], // Green color for the line
            ),
            Expanded(
              child: Container(
                color: Colors.orange[100],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Score',
                              style: TextStyle(
                                color: Colors.brown[100],
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '$score',
                              style: TextStyle(
                                  color: Colors.brown[100], fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Best Score',
                              style: TextStyle(
                                  color: Colors.brown[100], fontSize: 20),
                            ),
                            Text(
                              '$bestScore',
                              style: TextStyle(
                                  color: Colors.brown[100], fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
