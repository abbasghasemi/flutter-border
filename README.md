<h1 style="text-align: center">Border</h1>

![Demo](https://github.com/abbasghasemi/flutter-border/blob/master/shut/demo.jpg?raw=true)

#### A flutter package to add border for each widget

## Installation

```shell
flutter pub add custom_border
```

## Usage

### Animate & Gradient border
```dart
CustomBorder(
  gradientBuilder: (progress) => LinearGradient(
    colors: const [Colors.purple, Colors.green, Colors.blue, Colors.deepOrange],
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
)
```

### Dotted border
```dart
CustomBorder(
  color: Colors.green,
  size: const Size(100, 100),
  radius: Radius.circular(50),
  dashPattern: [6, 5],
  dashRadius: Radius.circular(3),
  style: PaintingStyle.fill,
  pathStrategy: PathStrategy.aroundLine,
)
```

### Dashed border
```dart
CustomBorder(
  color: Colors.red,
  radius: const Radius.circular(25),
  dashPattern: const [15, 5, 7.5, 10],
  strokeWidth: 3,
  size: const Size(100, 100),
)
```

### Lined border
```dart
CustomBorder(
    color: Colors.blueGrey,
    size: Size(100, 100),
    dashPattern: [3, 10, 9, 5],
    pathStrategy: PathStrategy.verticalLine, // or PathStrategy.horizontalLine
    strokeWidth: 3,
)
```

### Path border
```dart
CustomBorder(
  color: Colors.blue,
  dashPattern: const [15, 5, 7.5, 10],
  strokeWidth: 3,
  size: const Size(100, 100),
  path: ObjectPath.triangle(const Size(100, 100)),
)
```