import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Clear, magnifying glass derived from the lens on GlassTogglePage.
/// Place over a painted background; child content stays sharp and interactive.
class LiquidGlass extends StatelessWidget {
  const LiquidGlass({
    super.key,
    required this.child,
    this.radius = 26,
    this.tone = 0,
    this.magnification = 1.13,
    this.blur = 1.2,
  });
  final Widget child;
  final double radius;
  final double tone;
  final double magnification;
  final double blur;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: const Color(0xff1e2021).withValues(alpha: .32),
          blurRadius: 25,
          offset: const Offset(0, 14),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // The render proxy below centers the filter on the laid-out surface,
          // including surfaces whose height is determined by their children.
          return CustomPaint(
            foregroundPainter: LiquidGlassPainter(radius: radius, tone: tone),
            child: _LensFilter(
              magnification: magnification,
              blur: blur,
              child: child,
            ),
          );
        },
      ),
    ),
  );
}

class _LensFilter extends SingleChildRenderObjectWidget {
  const _LensFilter({
    required this.magnification,
    required this.blur,
    required super.child,
  });
  final double magnification;
  final double blur;
  @override
  RenderBackdropFilter createRenderObject(BuildContext context) =>
      _RenderLens(magnification, blur);
  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderLens renderObject,
  ) {
    renderObject
      ..magnification = magnification
      ..blur = blur;
    renderObject.markNeedsLayout();
  }
}

class _RenderLens extends RenderBackdropFilter {
  _RenderLens(this.magnification, this.blur)
    : super(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      );
  double magnification;
  double blur;
  @override
  void performLayout() {
    super.performLayout();
    final matrix = Matrix4.identity()
      ..translateByDouble(
        size.width * (1 - magnification) / 2,
        size.height * (1 - magnification) / 2,
        0,
        1,
      )
      ..scaleByDouble(magnification, magnification, 1, 1);
    filter = ImageFilter.compose(
      outer: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      inner: ImageFilter.matrix(matrix.storage),
    );
  }
}

/// The same surface tint, directional edge and inner caustic as the toggle.
class LiquidGlassPainter extends CustomPainter {
  const LiquidGlassPainter({this.radius = 26, this.tone = 0});
  final double radius;
  final double tone;
  @override
  void paint(Canvas canvas, Size size) => paintLens(
    canvas,
    RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
    tone,
  );

  static void paintLens(Canvas canvas, RRect shape, double tone) {
    final rect = shape.outerRect;
    canvas.drawRRect(
      shape,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: .07 + tone * .09),
            Colors.white.withValues(alpha: .005),
            Colors.black.withValues(alpha: .035),
            Colors.white.withValues(alpha: .035 + tone * .08),
          ],
          stops: const [0, .38, .65, 1],
        ).createShader(rect),
    );
    canvas.drawRRect(
      shape.deflate(.5),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = .8
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: .8),
            Colors.white.withValues(alpha: .02),
            Colors.white.withValues(alpha: .015),
            Colors.white.withValues(alpha: .4),
          ],
          stops: const [0, .34, .63, 1],
        ).createShader(rect),
    );
    // Soft internal rim caustics, strongest on the illuminated glass.
    canvas.save();
    canvas.clipRRect(shape);
    canvas.drawRRect(
      shape.deflate(4),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..color = Colors.white.withValues(alpha: .025 + tone * .12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(LiquidGlassPainter oldDelegate) =>
      radius != oldDelegate.radius || tone != oldDelegate.tone;
}

/// Selects the lens material for a shared dashboard subtree.
class LiquidGlassScope extends InheritedWidget {
  const LiquidGlassScope({
    super.key,
    required this.enabled,
    required super.child,
  });
  final bool enabled;
  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LiquidGlassScope>()?.enabled ??
      false;
  @override
  bool updateShouldNotify(LiquidGlassScope oldWidget) =>
      enabled != oldWidget.enabled;
}

/// A compact interactive lens, usable independently of the demo page.
class LiquidGlassSwitch extends StatelessWidget {
  const LiquidGlassSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });
  final bool value;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Focus',
    toggled: value,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () => onChanged(!value),
        child: SizedBox(
          width: 72,
          height: 48,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 66,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: value
                        ? const [Color(0xffa8a8ac), Color(0xff858589)]
                        : const [Color(0xff353538), Color(0xff202023)],
                  ),
                ),
              ),
              AnimatedAlign(
                duration: MediaQuery.disableAnimationsOf(context)
                    ? Duration.zero
                    : const Duration(milliseconds: 400),
                curve: Curves.easeOutBack,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: LiquidGlass(
                  radius: 22,
                  tone: value ? 1 : 0,
                  child: SizedBox(
                    width: 36,
                    height: 44,
                    child: Icon(
                      value ? Icons.light_mode_rounded : Icons.nightlight_round,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class LiquidGlassSliderThumb extends SliderComponentShape {
  const LiquidGlassSliderThumb();
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(28, 32);
  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final lens = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 28, height: 32),
      const Radius.circular(14),
    );
    context.canvas.drawRRect(
      lens,
      Paint()..color = Colors.white.withValues(alpha: .12),
    );
    LiquidGlassPainter.paintLens(context.canvas, lens, value);
  }
}
