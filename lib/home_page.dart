import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pacman/main.dart';
import 'package:pacman/path.dart';
import 'package:pacman/pixel.dart';
import 'package:pacman/player.dart';
import 'generated/assets.dart';
import 'ghost2.dart';
import 'ghost3.dart';
import 'my_ghost.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 16;
  int player = numberInRow * 14 + 1;
  int ghost = numberInRow * 2 - 2;
  int ghost2 = numberInRow * 9 - 2;
  int ghost3 = numberInRow * 11 - 2;
  bool preGame = true;
  bool mouthClosed = false;
  var controller;
  int score = 0;
  bool paused = false;
  int currentLevel = 1;
  final int maxLevel = 5;
  List<List<int>> levelBarriers = [];

  List<int> barriers = [];
  List<int> food = [];
  String direction = "right";
  String ghostLast = "left";
  String ghostLast2 = "left";
  String ghostLast3 = "down";

  @override
  void initState() {
    super.initState();
    // Define barriers for each level (max 200 barriers per level)
    levelBarriers = [
      // Level 1 - Simple maze
      [
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, // Top border
        11, 22, 33, 44, 55, 66, 77, 88, 99, 110, // Right border
        165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, // Bottom border
        154, 143, 132, 121, 110, 99, 88, 77, 66, 55, 44, 33, 22, // Left border
        24, 35, 46, 57, // Small inner walls
        30, 41, 52, 63,
        81, 70, 59,
        147, 148, 149,
      ],

      // Level 2 - More complex
      [
        // Outer walls (same as level 1)
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 22, 33, 44, 55, 66, 77, 88, 99, 110,
        165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175,
        154, 143, 132, 121, 110, 99, 88, 77, 66, 55, 44, 33, 22,
        // Additional inner walls
        23, 34, 45, 56, 67, 78, 89, 100,
        84, 85, 86, 106, 107, 108,
        26, 28, 37, 39,
        123, 134, 145,
        129, 140, 151,
        103, 114, 125,
      ],

      // Level 3 - Cross pattern
      [
        // Outer walls
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 22, 33, 44, 55, 66, 77, 88, 99, 110,
        165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175,
        154, 143, 132, 121, 66, 55, 44, 33, 22,
        // Vertical center wall
        80, 113, 124, 135, 146, 157,
        // Horizontal center wall
        82, 83, 84, 85, 86, 87, 88, 89, 90,
        // Additional blocks
        24, 35, 46, 57,
        147, 148, 149,
        26, 37, 38,
      ],

      // Level 4 - Spiral pattern
      [
        // Outer walls
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 22, 33, 44, 55, 66, 77, 88, 99, 110,
        78, 79,
        165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175,
        154, 143, 132, 121, 110, 99, 88, 77, 66, 55, 44, 33, 22,
        // Spiral walls
        23, 164, 21, 98,
        153, 142, 131, 120, 109, 98, 87, 98, 76, 65, 54, 43, 32,
        31, 30, 29, 28, 27, 26, 25,
        38, 49, 60, 62, 51, 104, 115, 126, 137,
        138, 139, 140, 141, 142, 143, 145, 156,
      ],

      // Level 5 - Final challenge
      [
        // Outer walls
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 22, 33, 44, 55, 66, 77, 88, 99, 110,
        165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175,
        154, 143, 132, 121, 110, 99, 88, 77, 66, 55, 44, 33, 22,
        // Complex inner maze
        24, 35, 46, 57, 68, 79, 90, 123, 134, 145,
        26, 37, 48, 59, 70, 81, 92, 103, 114, 125, 136, 147,
        28, 39, 50, 61, 72, 83, 94, 105, 116, 127, 138, 149,
        30, 41, 52, 63, 74, 85, 96, 107, 118, 129, 140, 151,
        32, 43, 54, 65, 76, 87, 98, 109, 120, 131, 142, 153,
        34,
      ],
    ];

    // Set initial barriers to level 1
    barriers = levelBarriers[0];
  }

  Future<void> startGame() async {
    if (preGame) {
      preGame = false;
      getFood();

      Timer.periodic(Duration(milliseconds: 100), (timer) {
        if (paused) {
        } else {
          // advancedPlayer.resume();
        }
        if (player == ghost || player == ghost2 || player == ghost3) {
          setState(() {
            player = -1;
          });
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return Material(
                color: Colors.transparent,
                child: Center(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    height: height * 0.45,
                    width: width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      image: DecorationImage(
                        image: AssetImage(Assets.assetsGameOverImage),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          currentLevel = 1;
                          barriers = levelBarriers[0];
                          player = numberInRow * 14 + 1;
                          ghost = numberInRow * 2 - 2;
                          ghost2 = numberInRow * 9 - 1;
                          ghost3 = numberInRow * 11 - 2;
                          paused = false;
                          preGame = false;
                          mouthClosed = false;
                          direction = "right";
                          food.clear();
                          getFood();
                          score = 0;
                          Navigator.pop(context);
                        });
                      },
                      child: Text(
                        "OK",
                        style: TextStyle(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    // title: Center(child: Text("Game Over!")),
                    // content: Text("Level $currentLevel | Score: $score"),
                    // actions: [
                    //   GestureDetector(
                    //     onTap: () {
                    //       // audioInGame.load('pacman_beginning.wav');
                    //       setState(() {
                    //         currentLevel = 1;
                    //         barriers = levelBarriers[0];
                    //         player = numberInRow * 14 + 1;
                    //         ghost = numberInRow * 2 - 2;
                    //         ghost2 = numberInRow * 9 - 1;
                    //         ghost3 = numberInRow * 11 - 2;
                    //         paused = false;
                    //         preGame = false;
                    //         mouthClosed = false;
                    //         direction = "right";
                    //         food.clear();
                    //         getFood();
                    //         score = 0;
                    //         Navigator.pop(context);
                    //       });
                    //     },
                    //     child: Text('Restart'),
                    //   ),
                    // ],
                  ),
                ),
              );
            },
          );
        }
      });

      // Ghost movement - slowed down to 750ms
      Timer.periodic(Duration(milliseconds: 750), (timer) {
        if (!paused) {
          moveGhost();
          moveGhost2();
          moveGhost3();
        }
      });

      // Player movement - slowed down to 250ms
      Timer.periodic(Duration(milliseconds: 350), (timer) {
        setState(() {
          mouthClosed = !mouthClosed;
        });
        checkFood();
        switch (direction) {
          case "left":
            if (!paused) moveLeft();
            break;
          case "right":
            if (!paused) moveRight();
            break;
          case "up":
            if (!paused) moveUp();
            break;
          case "down":
            if (!paused) moveDown();
            break;
        }
      });
    }
  }

  void checkFood() {
    if (food.contains(player)) {
      setState(() {
        food.remove(player);
        score++;
      });
      // Check if all food is eaten
      if (food.isEmpty) {
        nextLevel();
      }
    }
  }

  void nextLevel() {
    if (currentLevel < maxLevel) {
      setState(() {
        currentLevel++;
        barriers = levelBarriers[currentLevel - 1];
        // Reset positions
        player = numberInRow * 14 + 1;
        ghost = numberInRow * 2 - 2;
        ghost2 = numberInRow * 9 - 1;
        ghost3 = numberInRow * 11 - 2;
        // Clear and regenerate food
        food.clear();
        getFood();
        // Show level up message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Level $currentLevel!')));
      });
    } else {
      // Game completed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Congratulations!'),
            content: Text('You completed all levels!\nFinal Score: $score'),
            actions: [
              TextButton(
                child: Text('Play Again'),
                onPressed: () {
                  setState(() {
                    currentLevel = 1;
                    barriers = levelBarriers[0];
                    player = numberInRow * 14 + 1;
                    ghost = numberInRow * 2 - 2;
                    ghost2 = numberInRow * 9 - 1;
                    ghost3 = numberInRow * 11 - 2;
                    score = 0;
                    food.clear();
                    getFood();
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void restart() {
    startGame();
  }

  void getFood() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (!barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  void moveLeft() {
    if (!barriers.contains(player - 1)) {
      setState(() {
        player--;
      });
    }
  }

  void moveRight() {
    if (!barriers.contains(player + 1)) {
      setState(() {
        player++;
      });
    }
  }

  void moveUp() {
    if (!barriers.contains(player - numberInRow)) {
      setState(() {
        player -= numberInRow;
      });
    }
  }

  void moveDown() {
    if (!barriers.contains(player + numberInRow)) {
      setState(() {
        player += numberInRow;
      });
    }
  }

  void moveGhost() {
    List<String> possibleDirections = [];

    // Check available directions
    if (!barriers.contains(ghost - 1)) possibleDirections.add("left");
    if (!barriers.contains(ghost + 1)) possibleDirections.add("right");
    if (!barriers.contains(ghost - numberInRow)) possibleDirections.add("up");
    if (!barriers.contains(ghost + numberInRow)) possibleDirections.add("down");

    // Remove the opposite direction to prevent back-and-forth movement
    if (ghostLast == "left") possibleDirections.remove("right");
    if (ghostLast == "right") possibleDirections.remove("left");
    if (ghostLast == "up") possibleDirections.remove("down");
    if (ghostLast == "down") possibleDirections.remove("up");

    if (possibleDirections.isNotEmpty) {
      // Randomly select from available directions
      Random random = Random();
      String newDirection =
          possibleDirections[random.nextInt(possibleDirections.length)];

      setState(() {
        ghostLast = newDirection;
        switch (newDirection) {
          case "left":
            ghost--;
            break;
          case "right":
            ghost++;
            break;
          case "up":
            ghost -= numberInRow;
            break;
          case "down":
            ghost += numberInRow;
            break;
        }
      });
    }
  }

  void moveGhost2() {
    switch (ghostLast2) {
      case "left":
        if (!barriers.contains(ghost2 - 1)) {
          setState(() {
            ghost2--;
          });
        } else {
          if (!barriers.contains(ghost2 + numberInRow)) {
            setState(() {
              ghost2 += numberInRow;
              ghostLast2 = "down";
            });
          } else if (!barriers.contains(ghost2 + 1)) {
            setState(() {
              ghost2++;
              ghostLast2 = "right";
            });
          } else if (!barriers.contains(ghost2 - numberInRow)) {
            setState(() {
              ghost2 -= numberInRow;
              ghostLast2 = "up";
            });
          }
        }
        break;
      case "right":
        if (!barriers.contains(ghost2 + 1)) {
          setState(() {
            ghost2++;
          });
        } else {
          if (!barriers.contains(ghost2 - numberInRow)) {
            setState(() {
              ghost2 -= numberInRow;
              ghostLast2 = "up";
            });
          } else if (!barriers.contains(ghost2 + numberInRow)) {
            setState(() {
              ghost2 += numberInRow;
              ghostLast2 = "down";
            });
          } else if (!barriers.contains(ghost2 - 1)) {
            setState(() {
              ghost2--;
              ghostLast2 = "left";
            });
          }
        }
        break;
      case "up":
        if (!barriers.contains(ghost2 - numberInRow)) {
          setState(() {
            ghost2 -= numberInRow;
            ghostLast2 = "up";
          });
        } else {
          if (!barriers.contains(ghost2 + 1)) {
            setState(() {
              ghost2++;
              ghostLast2 = "right";
            });
          } else if (!barriers.contains(ghost2 - 1)) {
            setState(() {
              ghost2--;
              ghostLast2 = "left";
            });
          } else if (!barriers.contains(ghost2 + numberInRow)) {
            setState(() {
              ghost2 += numberInRow;
              ghostLast2 = "down";
            });
          }
        }
        break;
      case "down":
        if (!barriers.contains(ghost2 + numberInRow)) {
          setState(() {
            ghost2 += numberInRow;
            ghostLast2 = "down";
          });
        } else {
          if (!barriers.contains(ghost2 - 1)) {
            setState(() {
              ghost2--;
              ghostLast2 = "left";
            });
          } else if (!barriers.contains(ghost2 + 1)) {
            setState(() {
              ghost2++;
              ghostLast2 = "right";
            });
          } else if (!barriers.contains(ghost2 - numberInRow)) {
            setState(() {
              ghost2 -= numberInRow;
              ghostLast2 = "up";
            });
          }
        }
        break;
    }
  }

  void moveGhost3() {
    switch (ghostLast3) {
      case "left":
        if (!barriers.contains(ghost3 - 1)) {
          setState(() {
            ghost3--;
          });
        } else {
          if (!barriers.contains(ghost3 + numberInRow)) {
            setState(() {
              ghost3 += numberInRow;
              ghostLast3 = "down";
            });
          } else if (!barriers.contains(ghost3 + 1)) {
            setState(() {
              ghost3++;
              ghostLast3 = "right";
            });
          } else if (!barriers.contains(ghost3 - numberInRow)) {
            setState(() {
              ghost3 -= numberInRow;
              ghostLast3 = "up";
            });
          }
        }
        break;
      case "right":
        if (!barriers.contains(ghost3 + 1)) {
          setState(() {
            ghost3++;
          });
        } else {
          if (!barriers.contains(ghost3 - numberInRow)) {
            setState(() {
              ghost3 -= numberInRow;
              ghostLast3 = "up";
            });
          } else if (!barriers.contains(ghost3 - 1)) {
            setState(() {
              ghost3--;
              ghostLast3 = "left";
            });
          } else if (!barriers.contains(ghost3 + numberInRow)) {
            setState(() {
              ghost3 += numberInRow;
              ghostLast3 = "down";
            });
          }
        }
        break;
      case "up":
        if (!barriers.contains(ghost3 - numberInRow)) {
          setState(() {
            ghost3 -= numberInRow;
            ghostLast3 = "up";
          });
        } else {
          if (!barriers.contains(ghost3 + 1)) {
            setState(() {
              ghost3++;
              ghostLast3 = "right";
            });
          } else if (!barriers.contains(ghost3 - 1)) {
            setState(() {
              ghost3--;
              ghostLast3 = "left";
            });
          } else if (!barriers.contains(ghost3 + numberInRow)) {
            setState(() {
              ghost3 += numberInRow;
              ghostLast3 = "down";
            });
          }
        }
        break;
      case "down":
        if (!barriers.contains(ghost3 + numberInRow)) {
          setState(() {
            ghost3 += numberInRow;
            ghostLast3 = "down";
          });
        } else {
          if (!barriers.contains(ghost3 - 1)) {
            setState(() {
              ghost3--;
              ghostLast3 = "left";
            });
          } else if (!barriers.contains(ghost3 + 1)) {
            setState(() {
              ghost3++;
              ghostLast3 = "right";
            });
          } else if (!barriers.contains(ghost3 - numberInRow)) {
            setState(() {
              ghost3 -= numberInRow;
              ghostLast3 = "up";
            });
          }
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff131827),
        title: Row(
          children: [
            Image(
              image: AssetImage(Assets.assetsPackman),
              height: height * 0.05,
              width: width * 0.1,
            ),
            Image(
              image: AssetImage(Assets.assetsPackmanText),
              height: height * 0.045,
              width: width * 0.4,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xff131827),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0) {
                  direction = "down";
                } else if (details.delta.dy < 0) {
                  direction = "up";
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0) {
                  direction = "right";
                } else if (details.delta.dx < 0) {
                  direction = "left";
                }
              },
              child: GridView.builder(
                padding:EdgeInsets.only(top: height*0.02),

                physics: NeverScrollableScrollPhysics(),
                itemCount: numberOfSquares,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: numberInRow,
                ),
                itemBuilder: (BuildContext context, int index) {
                  if (mouthClosed && player == index) {
                    return Padding(
                      padding: EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Assets.assetsCloseMouthPac),
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  } else if (player == index) {
                    switch (direction) {
                      case "left":
                        return Transform.rotate(angle: pi, child: MyPlayer());
                      case "right":
                        return MyPlayer();
                      case "up":
                        return Transform.rotate(
                          angle: 3 * pi / 2,
                          child: MyPlayer(),
                        );
                      case "down":
                        return Transform.rotate(
                          angle: pi / 2,
                          child: MyPlayer(),
                        );
                      default:
                        return MyPlayer();
                    }
                  } else if (ghost == index) {
                    return MyGhost();
                  } else if (ghost2 == index) {
                    return MyGhost2();
                  } else if (ghost3 == index) {
                    return MyGhost3();
                  } else if (barriers.contains(index)) {
                    return MyPixel(child: Text("$index"));//child: Text("$index")
                  } else if (preGame || food.contains(index)) {
                    return MyPath(
                      innerColor: Colors.yellow,
                      outerColor: Colors.black,
                    );
                  } else {
                    return MyPath(
                      innerColor: Colors.black,
                      outerColor: Colors.black,
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: height*0.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Level $currentLevel | Score: $score",
                  style: TextStyle(color: Colors.white, fontSize: 23),
                ),
                GestureDetector(
                  onTap: startGame,
                  child: Text(
                    "P L A Y",
                    style: TextStyle(color: Colors.white, fontSize: 23),
                  ),
                ),
                if (!paused)
                  GestureDetector(
                    child: Icon(Icons.pause, color: Colors.white),
                    onTap: () => {
                      if (!paused)
                        {
                          paused = true,
                          // advancedPlayer.pause(),
                        }
                      else
                        {
                          paused = false,
                          // advancedPlayer2.stop(),
                        },
                      Icon(Icons.play_arrow, color: Colors.white),
                    },
                  ),
                if (paused)
                  GestureDetector(
                    child: Icon(Icons.play_arrow, color: Colors.white),
                    onTap: () => {
                      if (paused)
                        {
                          paused = false,
                          // advancedPlayer2.stop()
                        }
                      else
                        {
                          paused = true,
                          // advancedPlayer.pause(),
                        },
                    },
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
