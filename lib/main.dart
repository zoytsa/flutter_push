import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

enum GameState { readyToStart, waiting, canBeStopped }

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) { return MaterialApp( home: MyHomePage(),);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String millisecondsText = "";
  GameState gameState = GameState.readyToStart;
  Timer? waitingTimer;
  Timer? stoppableTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Align(
          alignment: const Alignment(0, -0.9),
          child:
          Text("Test your\nreaction speed", textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: Colors.black),
          ),
        ),
        Align(
          alignment: Alignment.center, child: ColoredBox(
          color: Colors.black12,
          child: SizedBox(height: 160, width: 300,
            child: Center(
              child: Text(
                millisecondsText, textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
            ),
          ),
        ),
        ),
        Align(
          alignment: const Alignment(0, 0.9),
          child: GestureDetector(
            onTap: () =>
                setState(() {
                  switch (gameState) {
                    case GameState.readyToStart:
                      gameState = GameState.waiting;
                      millisecondsText = "";
                      startWaitingTimer();
                      break;
                    case GameState.waiting:
                      break;
                    case GameState.canBeStopped:
                      gameState = GameState.readyToStart;
                      stoppableTimer?.cancel();
                      break;
                  }
                }),
            child: ColoredBox(
              color: Colors.black12,
              child: SizedBox(
                height: 200, width: 200, child: Center(child: Text(
                getButtonText(),
                style: TextStyle(fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
              ),
              ),
            ),
          ),
        ),
      ],
      ),
    );
  }

  String getButtonText() {
    switch (gameState) {
      case GameState.readyToStart:
        return "START";
      case GameState.waiting:
        return "WAIT";
      case GameState.canBeStopped:
        return "STOP";
    }
  }

  void startWaitingTimer() {
    final int randomMilliseconds = Random().nextInt(4000) + 1000;
    waitingTimer = Timer(
        Duration(milliseconds: randomMilliseconds),
            () {
          setState(() {
            gameState = GameState.canBeStopped;
          });
          _startStoppableTimer();
        });
  }

  void _startStoppableTimer() {
    stoppableTimer = Timer.periodic(Duration(milliseconds: 16),
            (timer) {
          setState(() {
            millisecondsText = "${timer.tick * 16} ms";
          });
        });
  }

  @override void dispose() {
    waitingTimer?.cancel();
    stoppableTimer?.cancel();
    super.dispose();
  }
}