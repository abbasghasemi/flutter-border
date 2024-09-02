import 'dart:math';
import 'dart:ui';

/// A collection of paths
class ObjectPath {
  static Path star(Size size, int raysCount) {
    final Path path = Path();
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double outer = min(centerX, centerY);

    double deltaAngleRad = pi / raysCount;
    for (int i = 0; i < raysCount * 2; i++) {
      double angleRad = -45 + i * deltaAngleRad;
      double ca = cos(angleRad);
      double sa = sin(angleRad);
      double relX = ca;
      double relY = sa;
      if ((i & 1) == 0) {
        relX *= outer / 2;
        relY *= outer / 2;
      } else {
        relX *= outer;
        relY *= outer;
      }
      if (i == 0) {
        path.moveTo(centerX + relX, centerY + relY);
      } else {
        path.lineTo(centerX + relX, centerY + relY);
      }
    }
    path.close();
    return path;
  }

  static Path boneStar(Size size) {
    final Path path = Path();
    final double r1 = size.width / 2;
    final double r2 = r1 / 2.5;
    final Offset center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 5; i++) {
      double theta1 = (2 * pi * i) / 5 - pi / 2;
      double theta2 = (2 * pi * (i + 2)) / 5 - pi / 2;

      Offset p1 = Offset(r1 * cos(theta1), r1 * sin(theta1)) + center;
      Offset p2 = Offset(r2 * cos(theta2), r2 * sin(theta2)) + center;

      if (i == 0) {
        path.moveTo(p1.dx, p1.dy);
      } else {
        path.lineTo(p1.dx, p1.dy);
      }
      path.lineTo(p2.dx, p2.dy);
    }

    path.close();
    return path;
  }

  static Path triangle(Size size) {
    final Path path = Path();
    final Offset p1 = Offset(size.width / 2, 0);
    final Offset p2 = Offset(size.width, size.height);
    final Offset p3 = Offset(0, size.height);

    path.moveTo(p1.dx, p1.dy);
    path.lineTo(p2.dx, p2.dy);
    path.lineTo(p3.dx, p3.dy);
    path.close();
    return path;
  }

  static Path pentagon(Size size) {
    final Path path = Path();
    final double r = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 5; i++) {
      double theta = (2 * pi * i) / 5 - pi / 2;
      Offset p = Offset(r * cos(theta), r * sin(theta)) + center;

      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }

    path.close();
    return path;
  }

  static Path octagon(Size size) {
    final Path path = Path();
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = min(centerX, centerY);

    for (int i = 0; i < 8; i++) {
      double angle = (i * 45) * (3.14 / 180);
      double x = centerX + radius * cos(angle);
      double y = centerY + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }
}
