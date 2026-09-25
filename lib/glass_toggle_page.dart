import 'dart:math' as math;
import 'dart:ui';
import 'liquid_glass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A fully painted, package-free recreation of the reference's glass switch.
class GlassTogglePage extends StatefulWidget {
  const GlassTogglePage({super.key});
  @override
  State<GlassTogglePage> createState() => _GlassTogglePageState();
}

class _GlassTogglePageState extends State<GlassTogglePage> {
  bool light = false;
  void toggle() => setState(() => light = !light);

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(end: light ? 1 : 0),
    duration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 800),
    curve: const Cubic(.34, 1.56, .64, 1),
    builder: (context, value, _) {
      final tone = value.clamp(0.0, 1.0);
      return Scaffold(
        backgroundColor: Color.lerp(
          const Color(0xff646468),
          const Color(0xff99999d),
          tone,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Back to calm',
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      '02 / GLASS STUDIES',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 2,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: Column(
                            children: [
                              const Spacer(flex: 2),
                              const Text(
                                'A little shift.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Glass Toggle',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 42,
                                  height: 1.1,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -2,
                                ),
                              ),
                              const SizedBox(height: 22),
                              const Text(
                                'Two moods. One fluid motion.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              const Spacer(),
                              const SizedBox(height: 36),
                              Semantics(
                                label: 'Light mode',
                                enabled: true,
                                toggled: light,
                                onTap: toggle,
                                child: FocusableActionDetector(
                                  shortcuts: const {
                                    SingleActivator(LogicalKeyboardKey.space):
                                        ActivateIntent(),
                                    SingleActivator(LogicalKeyboardKey.enter):
                                        ActivateIntent(),
                                  },
                                  actions: {
                                    ActivateIntent:
                                        CallbackAction<ActivateIntent>(
                                          onInvoke: (_) {
                                            toggle();
                                            return null;
                                          },
                                        ),
                                  },
                                  child: GestureDetector(
                                    key: const Key('glass-mode-toggle'),
                                    behavior: HitTestBehavior.opaque,
                                    onTap: toggle,
                                    onHorizontalDragEnd: (details) {
                                      final velocity =
                                          details.primaryVelocity ?? 0;
                                      if (velocity.abs() > 50) {
                                        setState(() => light = velocity < 0);
                                      } else {
                                        toggle();
                                      }
                                    },
                                    child: AspectRatio(
                                      aspectRatio: 360 / 270,
                                      child: CustomPaint(
                                        painter: _TogglePainter(value),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                light ? 'Light' : 'Dark',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Tap to switch the atmosphere',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white60,
                                ),
                              ),
                              const Spacer(flex: 3),
                              const SizedBox(height: 40),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: .08),
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: .1),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.blur_on_rounded,
                                      size: 19,
                                      color: Colors.white70,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Light, shaped by glass.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.swipe_rounded,
                                      size: 18,
                                      color: Colors.white54,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _TogglePainter extends CustomPainter {
  const _TogglePainter(this.position);
  final double position;
  double get tone => position.clamp(0.0, 1.0);
  Color mix(Color dark, Color light) => Color.lerp(dark, light, tone)!;

  void track(Canvas canvas) {
    const rect = Rect.fromLTWH(30, 75, 290, 110);
    final pill = RRect.fromRectAndRadius(rect, const Radius.circular(55));
    canvas.drawRRect(
      pill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            mix(const Color(0xff353538), const Color(0xffa8a8ac)),
            mix(const Color(0xff202023), const Color(0xff858589)),
          ],
          stops: const [0, .8],
        ).createShader(rect),
    );
    canvas.drawRRect(
      pill.deflate(1),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.7)
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: .12 + tone * .42),
            Colors.transparent,
            Colors.black.withValues(alpha: .2),
          ],
        ).createShader(rect),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 360, size.height / 270);
    // A broad, offset shadow follows the proportions of the Figma example.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(23, 116, 286, 105),
        const Radius.circular(60),
      ),
      Paint()
        ..color = const Color(0xff1e2021).withValues(alpha: .62)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25),
    );
    if (tone > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(29, 73, 292, 112),
          const Radius.circular(60),
        ),
        Paint()
          ..color = Colors.white.withValues(alpha: tone * .24)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
      );
    }
    track(canvas);
    final text = TextPainter(
      text: TextSpan(
        text: tone < .5 ? 'Dark' : 'Light',
        style: TextStyle(
          fontFamily: '.SF Pro Display',
          fontSize: 42,
          letterSpacing: -1.7,
          fontWeight: FontWeight.w500,
          color: Color.lerp(const Color(0xff939397), Colors.white, tone),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    text.paint(canvas, Offset(70 + 109 * tone, 130 - text.height / 2));

    final x = lerpDouble(273, 76, position)!;
    final lensRect = Rect.fromCenter(
      center: Offset(x, 130),
      width: 164,
      height: 200,
    );
    final lens = RRect.fromRectAndRadius(lensRect, const Radius.circular(82));
    // Clip and magnify the pill underneath the lens to produce visible refraction.
    canvas.save();
    canvas.clipRRect(lens);
    canvas.saveLayer(
      lensRect,
      Paint()..imageFilter = ImageFilter.blur(sigmaX: 1.2, sigmaY: 1.2),
    );
    canvas.translate(x, 130);
    canvas.scale(1.13, 1.09);
    canvas.translate(-x, -130);
    track(canvas);
    canvas.restore();
    canvas.restore();
    LiquidGlassPainter.paintLens(canvas, lens, tone);
    final center = Offset(x, 130);
    canvas.drawCircle(
      center,
      21,
      Paint()
        ..color = Colors.white.withValues(alpha: .3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
    final iconPaint = Paint()..color = Colors.white;
    if (tone < .5) {
      final moon = Path.combine(
        PathOperation.difference,
        Path()..addOval(Rect.fromCircle(center: center, radius: 22)),
        Path()..addOval(
          Rect.fromCircle(center: center + const Offset(10, -9), radius: 19),
        ),
      );
      canvas.drawPath(moon, iconPaint);
    } else {
      canvas.drawCircle(center, 11, iconPaint);
      for (var i = 0; i < 8; i++) {
        final angle = i * math.pi / 4;
        final direction = Offset(math.cos(angle), math.sin(angle));
        canvas.drawLine(
          center + direction * 18,
          center + direction * 24,
          Paint()
            ..color = Colors.white
            ..strokeWidth = 2.8
            ..strokeCap = StrokeCap.round,
        );
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_TogglePainter oldDelegate) =>
      position != oldDelegate.position;
}
