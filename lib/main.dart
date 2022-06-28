import 'package:flame/game.dart';
import "package:flutter/material.dart";
import "game.dart";
import 'package:game2048/game_board.dart';

main() {
  runApp(const MainMenu());
}

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "2048 game",
      home: GameMenu(),
    );
  }
}

class GameMenu extends StatelessWidget {
  const GameMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("select board size")),
      body: Container(
          height: 360.0,
          width: 100.0,
          child: ListView(
            children: [
              Container(
                height: 120.0,
                width: 120.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/matrix4x4.png'),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: TextButton(
                    child: const Text("4x4"),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => GameWidget(
                                  game: MyGame(
                                      size: Vector2(800, 640),
                                      // position: Vector2(100, 100),
                                      matrix: Vector2(4, 4)),
                                )))),
              ),
              Container(
                height: 120.0,
                width: 120.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/matrix5x5.png'),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: TextButton(
                    child: const Text("5x5"),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => GameWidget(
                                  game: MyGame(
                                      size: Vector2(800, 640),
                                      //    position: Vector2(100, 100),
                                      matrix: Vector2(5, 5)),
                                )))),
              ),
              Container(
                height: 120.0,
                width: 120.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/matrix6x6.png'),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: TextButton(
                    child: const Text("6x6"),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => GameWidget(
                                  game: MyGame(
                                      size: Vector2(800, 640),
                                      //        position: Vector2(100, 100),
                                      matrix: Vector2(6, 6)),
                                )))),
              )
            ],
          )),
    );
  }
}
// Container(
//       height: 120.0,
//       width: 120.0,
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage(
//               'assets/assets/alucard.jpg'),
//           fit: BoxFit.fill,
//         ),
//         shape: BoxShape.circle,
//       ),
//     )

 