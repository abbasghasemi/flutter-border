import 'dart:math';
import 'dart:ui';

import 'package:custom_border/border.dart';
import 'package:flutter/widgets.dart';

part 'border_painter.dart';

/// progress is between 0 and 1
typedef GradientBuilder = Gradient Function(double progress);

class CustomBorder extends StatelessWidget {
  /// any widget
  final Widget? child;

  /// border animated
  final bool animateBorder;

  /// enable animation
  final Duration? animateDuration;

  /// border color
  final Color? color;

  /// border gradient
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

  /// custom path
  /// see [ObjectPath]
  final Path? path;

  /// see [PathStrategy]
  final PathStrategy pathStrategy;

  const CustomBorder({
    super.key,
    this.child,
    this.animateDuration,
    this.animateBorder = false,
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
    return animateDuration == null
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
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.parent.animateDuration,
  );

  @override
  void initState() {
    super.initState();
    Tween<double> tween = Tween(begin: 0, end: 1);
    tween.animate(_controller)
      ..addListener(() {
        if (_controller.isAnimating) setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.repeat();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _AnimatedCustomBorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.parent.animateDuration;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.parent.size,
      painter: BorderPainter(
        progress: _controller.value,
        animated: widget.parent.animateBorder,
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
