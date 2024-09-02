part of 'custom_border.dart';

class BorderPainter extends CustomPainter {
  final double progress;
  final bool animated;
  final Color? color;
  final GradientBuilder? gradientBuilder;
  late final CircularInterval<double>? dashPattern;
  final Radius dashRadius;
  final Radius radius;
  final double strokeWidth;
  final StrokeCap strokeCap;
  final StrokeJoin strokeJoin;
  final PaintingStyle style;
  final Path? path;
  final PathStrategy pathStrategy;

  final Paint _paint = Paint();
  late final Gradient gradient;

  BorderPainter({
    super.repaint,
    required this.progress,
    required this.animated,
    required this.color,
    required this.gradientBuilder,
    required List<double>? dashPattern,
    required this.dashRadius,
    required this.radius,
    required this.style,
    required this.strokeWidth,
    required this.strokeCap,
    required this.strokeJoin,
    required this.path,
    required this.pathStrategy,
  }) {
    if (dashPattern != null) {
      assert(_validDashPattern(dashPattern));
      this.dashPattern = CircularInterval(dashPattern);
    } else {
      this.dashPattern = null;
    }
    _paint
      ..style = style
      ..strokeCap = strokeCap
      ..strokeJoin = strokeJoin
      ..strokeWidth = strokeWidth;
    if (color != null) {
      _paint.color = color!;
    } else {
      gradient = gradientBuilder!(progress);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (color == null) {
      _paint.shader = gradient.createShader(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2,
        ),
      );
    }

    if (this.dashPattern == null) {
      if (this.path == null) {
        canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(0, 0, size.width, size.height),
              radius,
            ),
            _paint);
      } else {
        canvas.drawPath(this.path!, _paint);
      }
      return;
    }

    final dashPattern = this.dashPattern!;
    dashPattern.reset();
    final sumDouble = dashPattern.sumDouble;

    if (pathStrategy == PathStrategy.verticalLine ||
        pathStrategy == PathStrategy.horizontalLine) {
      final row = pathStrategy == PathStrategy.horizontalLine;
      final s = row ? size.width : size.height;
      final c = row ? size.height / 2 : size.width / 2;
      final double start = animated ? sumDouble * progress : 0;
      double distance = start;
      while (distance < s) {
        dashPattern.next;
        if (dashPattern.index % 2 == 0) {
          final radiusRatio = dashPattern.index < 2
              ? dashRadius
              : Radius.elliptical(
                  dashRadius.x * dashPattern.current / dashPattern.list.first,
                  dashRadius.y * dashPattern.current / dashPattern.list.first,
                );
          double m = min(dashPattern.current, s - distance);
          canvas.drawRRect(
              RRect.fromRectAndRadius(
                Rect.fromLTWH(
                  row ? distance : c,
                  row ? c : distance,
                  row ? m : 0,
                  row ? 0 : m,
                ),
                radiusRatio,
              ),
              _paint);
        }
        distance += dashPattern.current;
      }
      if (start > 0) {
        final e = start - dashPattern.list.last;
        canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(
                row ? 0 : c,
                row ? c : 0,
                row ? e : 0,
                row ? 0 : e,
              ),
              radius,
            ),
            _paint);
      }
      return;
    }

    Path path = this.path ?? Path();
    if (this.path == null) {
      path.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          radius,
        ),
      );
    }

    Path dashPath = Path();

    for (PathMetric pathMetric in path.computeMetrics()) {
      double distance = animated ? sumDouble * progress : 0;
      if (style == PaintingStyle.stroke && distance > 0) {
        dashPath.addPath(
            pathMetric.extractPath(
                0,
                (dashPattern.current + dashPattern.after) * progress -
                    dashPattern.before),
            Offset.zero);
      }
      while (distance < pathMetric.length) {
        final w = dashPattern.next;
        final s = dashPattern.next;
        if (style == PaintingStyle.stroke &&
            (pathStrategy == PathStrategy.aroundExtract ||
                dashRadius == Radius.zero)) {
          final tangent = pathMetric.getTangentForOffset(distance);
          final start = tangent!.position;
          distance += w;
          final endTangent = pathMetric.getTangentForOffset(distance);
          final end = endTangent?.position ?? tangent.position;
          if (pathStrategy == PathStrategy.aroundExtract) {
            dashPath.addPath(
                pathMetric.extractPath(distance - w, distance), Offset.zero);
          } else {
            dashPath.addPath(
                Path()
                  ..moveTo(start.dx, start.dy)
                  ..lineTo(end.dx, end.dy),
                Offset.zero);
          }
          distance += s;
        } else {
          final tangent = pathMetric.getTangentForOffset(distance);
          if (tangent != null) {
            final offset = tangent.position;
            final radiusRatio = dashPattern.index < 2
                ? dashRadius
                : Radius.elliptical(
                    dashRadius.x * dashPattern.before / dashPattern.list.first,
                    dashRadius.y * dashPattern.before / dashPattern.list.first,
                  );
            dashPath.addRRect(RRect.fromRectAndRadius(
                Rect.fromCenter(center: offset, width: w, height: w),
                radiusRatio));
          }
          distance += w + s;
        }
      }
    }
    canvas.drawPath(dashPath, _paint);
  }

  @override
  bool shouldRepaint(covariant BorderPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        color != oldDelegate.color ||
        gradientBuilder != oldDelegate.gradientBuilder ||
        dashPattern != oldDelegate.dashPattern ||
        dashRadius != oldDelegate.dashRadius ||
        radius != oldDelegate.radius ||
        style != oldDelegate.style ||
        strokeWidth != oldDelegate.strokeWidth ||
        strokeJoin != oldDelegate.strokeJoin ||
        strokeCap != oldDelegate.strokeCap ||
        path != oldDelegate.path ||
        pathStrategy != oldDelegate.pathStrategy;
  }
}

/// Border Feature
enum PathStrategy {
  /// The pattern in the corners will be move exactly on the path
  aroundExtract,

  /// The pattern in the corners will be slightly out of the path
  aroundLine,

  /// Draws the vertical line
  verticalLine,

  /// Draws the horizontal line
  horizontalLine,
}

bool _validDashPattern(List<double> dp) {
  if (dp.isEmpty || dp.first == 0) return false;
  for (var i = 2; i < dp.length; i += 2) {
    if (dp[i] == 0) {
      if (i + 1 == dp.length) {
        if (dp[i - 1] == 0) return false;
      } else {
        if (dp[i + 1] == 0) return false;
      }
    }
  }
  return true;
}

/// Provides loop in the list
class CircularInterval<T> {
  late final List<T> _list;
  late int _i;

  /// list
  List<T> get list => _list;

  /// index of pointer
  int get index => _i;

  /// Takes a non empty list and if the number of elements is not even pair
  /// it will add it from the beginning of the list
  CircularInterval(List<T> list) {
    assert(list.isNotEmpty, 'List is empty!');
    if (list.length % 2 == 0) {
      _list = list;
      reset();
    } else {
      _i = list.length;
      _list = list.toList()..add(list.first);
    }
  }

  /// changes pointer to index of the last element
  void reset() {
    _i = _list.length - 1;
  }

  /// returns the element before the current element
  T get before {
    if (_i == 0) return _list.last;
    return _list[_i - 1];
  }

  /// returns the element before the current element and updates the pointer
  T get back {
    if (_list.length == 1) return _list.first;
    if (_i == 0) {
      _i = _list.length - 1;
      return _list.last;
    }
    return _list[--_i];
  }

  /// returns the current element
  T get current {
    return _list[_i];
  }

  /// returns the element after the current element and updates the pointer
  T get next {
    if (_list.length == 1) return _list.first;
    if (_i + 1 == _list.length) {
      _i = 0;
      return _list.first;
    }
    return _list[++_i];
  }

  /// returns the element after the current element
  T get after {
    if (_list.length == _i + 1) return _list.first;
    return _list[_i + 1];
  }

  /// reduce
  double get sumDouble {
    return (_list as List<double>).reduce((e1, e2) => e1 + e2);
  }
}
