import 'dart:math';

import 'package:building_tic_tac_toe_game/custom_dialog.dart';
import 'package:building_tic_tac_toe_game/game_button.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GameButton> buttonsList;
  var player1, player2, activePlayer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buttonsList = doInit();
  }

  List<GameButton> doInit() {
    player1 = [];
    player2 = [];
    activePlayer = 1;

    var gameButtons = <GameButton>[
      new GameButton(id: 1),
      new GameButton(id: 2),
      new GameButton(id: 3),
      new GameButton(id: 4),
      new GameButton(id: 5),
      new GameButton(id: 6),
      new GameButton(id: 7),
      new GameButton(id: 8),
      new GameButton(id: 9),
    ];
    return gameButtons;
  }

  void playGame(GameButton gb) {
    setState(() {
      if (activePlayer == 1) {
        gb.text = "X";
        gb.bg = Colors.redAccent;
        activePlayer = 2;
        player1.add(gb.id);
      } else {
        gb.text = "0";
        gb.bg = Colors.black;
        activePlayer = 1;
        player2.add(gb.id);
      }
      gb.enabled = false;
      int winner = checkWinner();
      if (winner == -1) {
        if (buttonsList.every((element) => element.text != "")) {
          showDialog(
              context: context,
              builder: (_) => new CustomDialog("Game Ties",
                  "Press The Reset Button To Start the game", resetGame));
        } else {
          activePlayer == 2 ? autoPlay() : null;
        }
      }
    });
  }

  void autoPlay() {
    var emptyCells = new List();
    var list = new List.generate(9, (index) => index + 1);
    for (var cellID in list) {
      if (player1.contains(cellID) || player2.contains(cellID)) {
        emptyCells.add(cellID);
      }
    }

    var r = new Random();
    var randIndex = r.nextInt(emptyCells.length - 1);
    var cellID = emptyCells[randIndex];
    int i = buttonsList.indexWhere((element) => element.id == cellID);
    playGame(buttonsList[i]);
  }

  int checkWinner() {
    var winner = -1;
    // row 1
    if (player1.contains(1) && player1.contains(2) && player1.contains(3)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(2) && player2.contains(3)) {
      winner = 2;
    }
    // row 2
    if (player1.contains(4) && player1.contains(5) && player1.contain(6)) {
      winner = 1;
    }
    if (player2.contains(4) && player2.contains(5) && player2.contain(6)) {
      winner = 2;
    }

    // row 3
    if (player1.contains(7) && player1.contains(8) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(7) && player2.contains(8) && player2.contains(9)) {
      winner = 2;
    }

    // col 1
    if (player1.contains(1) && player1.contains(4) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(4) && player2.contains(7)) {
      winner = 2;
    }

    // col 2
    if (player1.contains(2) && player1.contains(5) && player1.contains(8)) {
      winner = 1;
    }
    if (player2.contains(2) && player2.contains(5) && player2.contains(8)) {
      winner = 2;
    }

    // col 3
    if (player1.contains(3) && player1.contains(6) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(6) && player2.contains(9)) {
      winner = 2;
    }

    // diagnal 1
    if (player1.contains(1) && player1.contains(5) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(5) && player2.contains(9)) {
      winner = 2;
    }

    // diagnal 2
    if (player1.contains(3) && player1.contains(5) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(5) && player2.contains(7)) {
      winner = 2;
    }

    if (winner != -1) {
      if (winner == 1) {
        showDialog(
            context: context,
            builder: (_) => new CustomDialog("Player 1 Won",
                "Press The Reset Button To Start Again", resetGame));
      } else {
        showDialog(
            context: context,
            builder: (_) => new CustomDialog("Player 2 Won",
                "Press The Reset Button To Start Again", resetGame));
      }
    }
    return winner;
  }

  void resetGame() {
    if (Navigator.canPop(context)) Navigator.pop(context);
    setState(() {
      buttonsList = doInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Tic Tac Toe"),
      ),
      body: new Container(
        child: new Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: new GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 9,
                    mainAxisSpacing: 9,
                  ),
                  itemCount: buttonsList.length,
                  itemBuilder: (context, int index) => new SizedBox(
                    width: 100,
                    height: 100,
                    child: new RaisedButton(
                      padding: const EdgeInsets.all(8.0),
                      onPressed: buttonsList[index].enabled
                          ? () => playGame(buttonsList[index])
                          : null,
                      child: new Text(
                        buttonsList[index].text,
                        style: new TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: buttonsList[index].bg,
                      disabledColor: buttonsList[index].bg,
                    ),
                  ),
                ),
              ),
              new RaisedButton(
                onPressed: resetGame,
                child: new Text(
                  "Reset",
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                color: Colors.redAccent,
              )
            ],
          ),
        ),
      ),
    );
  }
}
