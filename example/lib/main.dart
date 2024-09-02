import 'package:custom_border/border.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Providing a restorationScopeId allows the Navigator built by the
      // MaterialApp to restore the navigation stack when a user leaves and
      // returns to the app after it has been killed while running in the
      // background.
      restorationScopeId: 'app',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const BorderActivity(),
    );
  }
}

class BorderActivity extends StatelessWidget {
  const BorderActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Custom border"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            CustomBorder(
              gradientBuilder: (progress) => LinearGradient(
                colors: const [
                  Colors.purple,
                  Colors.green,
                  Colors.blue,
                  Colors.deepOrange
                ],
                transform: GradientRotation(progress * 6),
              ),
              animateDuration: const Duration(seconds: 1),
              animateBorder: true,
              radius: const Radius.circular(25),
              dashPattern: const [15, 5, 7.5, 10],
              strokeWidth: 3,
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.deepOrange,
                ),
                width: 90,
                // 90 + (2 * padding) = 100
                height: 90,
                child: const Center(child: Text("Animated")),
              ),
            ),
            CustomBorder(
              gradientBuilder: (progress) => const LinearGradient(
                colors: [Colors.green, Colors.teal],
              ),
              size: const Size(100, 100),
              strokeWidth: 2,
              strokeJoin: StrokeJoin.miter,
            ),
            CustomBorder(
              animateDuration: const Duration(seconds: 1),
              gradientBuilder: (progress) => LinearGradient(
                colors: const [Colors.blue, Colors.pinkAccent],
                transform: GradientRotation((1 - progress) * 6),
              ),
              radius: const Radius.circular(49),
              dashPattern: const [15, 10],
              strokeCap: StrokeCap.square,
              strokeWidth: 5,
              child: const SizedBox(
                width: 100,
                height: 100,
                child: Center(
                  child: Text(
                    "Circle",
                  ),
                ),
              ),
            ),
            const CustomBorder(
              color: Colors.yellow,
              size: Size(98, 98),
              radius: Radius.circular(25),
              dashPattern: [2, 10],
              strokeCap: StrokeCap.butt,
              strokeWidth: 10,
            ),
            const CustomBorder(
              color: Colors.indigo,
              size: Size(98, 98),
              radius: Radius.circular(25),
              dashPattern: [5, 10],
              strokeCap: StrokeCap.round,
              strokeJoin: StrokeJoin.round,
              strokeWidth: 3,
              pathStrategy: PathStrategy.aroundLine,
            ),
            CustomBorder(
              color: Colors.pink,
              size: const Size(98, 98),
              dashPattern: const [5, 5],
              dashRadius: const Radius.circular(2.5),
              style: PaintingStyle.fill,
              path: ObjectPath.triangle(const Size(98, 98)),
              pathStrategy: PathStrategy.aroundLine,
            ),
            CustomBorder(
              gradientBuilder: (progress) => const LinearGradient(
                colors: [
                  Colors.purple,
                  Colors.green,
                  Colors.blue,
                  Colors.deepOrange
                ],
              ),
              size: const Size(98, 98),
              dashPattern: const [5, 10],
              strokeCap: StrokeCap.round,
              strokeJoin: StrokeJoin.round,
              strokeWidth: 3,
              path: ObjectPath.star(const Size(98, 98), 5),
            ),
            CustomBorder(
              animateBorder: true,
              gradientBuilder: (progress) => LinearGradient(
                colors: const [
                  Colors.purple,
                  Colors.green,
                  Colors.blue,
                  Colors.deepOrange
                ],
                transform: GradientRotation(progress * 6),
              ),
              animateDuration: const Duration(seconds: 5),
              radius: const Radius.circular(15),
              dashPattern: const [10, 3, 30, 3],
              dashRadius: const Radius.circular(5),
              pathStrategy: PathStrategy.horizontalLine,
              strokeWidth: 5,
              style: PaintingStyle.stroke,
              strokeJoin: StrokeJoin.bevel,
              strokeCap: StrokeCap.butt,
              child: const SizedBox(
                width: double.infinity,
                height: 70,
                child: Align(
                  alignment: Alignment(0.0, -0.7),
                  child: Text("Animated & Gradient line"),
                ),
              ),
            ),
            const CustomBorder(
              animateBorder: true,
              animateDuration: Duration(milliseconds: 250),
              color: Colors.redAccent,
              size: Size(98, 98),
              radius: Radius.circular(25),
              dashPattern: [15, 10],
              strokeWidth: 3,
              pathStrategy: PathStrategy.aroundLine,
            ),
            const CustomBorder(
              color: Colors.blue,
              radius: Radius.circular(25),
              dashPattern: [7, 5],
              dashRadius: Radius.circular(3),
              style: PaintingStyle.fill,
              pathStrategy: PathStrategy.aroundLine,
              child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Center(child: Text("Square"))),
            ),
            const CustomBorder(
              color: Colors.green,
              radius: Radius.circular(49),
              dashPattern: [6, 5, 3, 5, 9, 5],
              dashRadius: Radius.circular(3),
              style: PaintingStyle.fill,
              pathStrategy: PathStrategy.aroundLine,
              child: SizedBox(
                  width: 100, height: 100, child: Center(child: Text("Dots"))),
            ),
            const CustomBorder(
              // animationDuration: Duration(seconds: 2),
              // animated: true,
              color: Colors.orange,
              radius: Radius.circular(35),
              dashPattern: [9, 5, 6, 5],
              dashRadius: Radius.circular(2),
              strokeWidth: 1,
              style: PaintingStyle.stroke,
              pathStrategy: PathStrategy.aroundLine,
              child: SizedBox(
                width: 100,
                height: 100,
                child: Center(
                  child: Text(
                    "Squares",
                  ),
                ),
              ),
            ),
            const CustomBorder(
              color: Colors.blueGrey,
              size: Size(100, 100),
              dashPattern: [3, 10, 9, 5],
              pathStrategy: PathStrategy.verticalLine,
              strokeWidth: 3,
              child: SizedBox(
                width: 100,
                height: 100,
                child: Align(
                  alignment: Alignment(0.3, 0),
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Text("Line"),
                  ),
                ),
              ),
            ),
            CustomBorder(
              color: Colors.redAccent,
              size: const Size(98, 98),
              dashPattern: const [10, 5],
              strokeWidth: 3,
              path: ObjectPath.pentagon(const Size(98, 98)),
            ),
            CustomBorder(
              gradientBuilder: (progress) => const RadialGradient(colors: [
                Colors.orange,
                Colors.yellowAccent,
                Colors.orangeAccent,
              ]),
              size: const Size(98, 98),
              dashPattern: const [5, 10],
              strokeCap: StrokeCap.round,
              strokeJoin: StrokeJoin.round,
              strokeWidth: 3,
              path: ObjectPath.boneStar(const Size(98, 98)),
            ),
          ],
        ),
      ),
    );
  }
}
