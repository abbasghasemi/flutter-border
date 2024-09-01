import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart';

part 'border_painter.dart';

/// progress is between 0 and 1
typedef GradientBuilder = Gradient Function(double progress);

class CustomBorder extends StatelessWidget {
  final Widget? child;

  /// border animated
  final bool animated;
  final Duration? animationDuration;
  final Color? color;
  final GradientBuilder? gradientBuilder;

  ///  [width & space]
  ///  [width,space, ...]
  final List<double>? dashPattern;

  /// Used if the pathStrategy is not PathStrategy.aroundExtract
  final Radius dashRadius;

  /// border radius
  final Radius radius;
  final PaintingStyle style;
  final double strokeWidth;
  final StrokeJoin strokeJoin;
  final StrokeCap strokeCap;

  /// box size, for when child is null
  final Size size;
  final Path? path;

  final PathStrategy pathStrategy;

  const CustomBorder({
    super.key,
    this.child,
    this.animationDuration,
    this.animated = false,
    this.color,
    this.gradientBuilder,
    this.dashPattern,
    this.dashRadius = Radius.zero,
    this.radius = Radius.zero,
    this.strokeWidth = 0,
    this.style = PaintingStyle.stroke,
    this.strokeJoin = StrokeJoin.round,
    this.strokeCap = StrokeCap.round,
    this.size = Size.zero,
    this.path,
    this.pathStrategy = PathStrategy.aroundExtract,
  }) : assert(
            color != null && gradientBuilder == null ||
                gradientBuilder != null && color == null,
            "Cannot provide both a color and a gradientBuilder or both are null.");

  @override
  Widget build(BuildContext context) {
    return animationDuration == null
        ? CustomPaint(
            size: size,
            painter: BorderPainter(
              progress: 0,
              animated: false,
              color: color,
              gradientBuilder: gradientBuilder,
              dashPattern: dashPattern,
              dashRadius: dashRadius,
              radius: radius,
              strokeWidth: strokeWidth,
              strokeCap: strokeCap,
              strokeJoin: strokeJoin,
              style: style,
              path: path,
              pathStrategy: pathStrategy,
            ),
            child: child,
          )
        : _AnimatedCustomBorder(parent: this);
  }
}

class _AnimatedCustomBorder extends StatefulWidget {
  final CustomBorder parent;

  const _AnimatedCustomBorder({
    required this.parent,
  });

  @override
  State<_AnimatedCustomBorder> createState() => _AnimatedCustomBorderState();
}

class _AnimatedCustomBorderState extends State<_AnimatedCustomBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.parent.animationDuration,
    );
    Tween<double> tween = Tween(begin: 0, end: 1);
    tween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.repeat();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.stop();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.parent.size,
      painter: BorderPainter(
        progress: controller.value,
        animated: widget.parent.animated,
        color: widget.parent.color,
        gradientBuilder: widget.parent.gradientBuilder,
        dashPattern: widget.parent.dashPattern,
        dashRadius: widget.parent.dashRadius,
        radius: widget.parent.radius,
        strokeWidth: widget.parent.strokeWidth,
        strokeCap: widget.parent.strokeCap,
        strokeJoin: widget.parent.strokeJoin,
        style: widget.parent.style,
        path: widget.parent.path,
        pathStrategy: widget.parent.pathStrategy,
      ),
      child: widget.parent.child,
    );
  }
}
