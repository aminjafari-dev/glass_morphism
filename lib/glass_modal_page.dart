import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

/// A bottom-anchored glass surface, timed against the 30 fps reference clip.
class GlassModalPage extends StatefulWidget {
  const GlassModalPage({super.key});

  @override
  State<GlassModalPage> createState() => _GlassModalPageState();
}

class _GlassModalPageState extends State<GlassModalPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  bool _expanded = false;
  bool _closing = false;
  double _start = 0;
  double _drag = 0;
  double _startBottomOffset = 0;

  double _sample(List<double> times, List<double> values, double t) {
    for (var i = 1; i < times.length; i++) {
      if (t <= times[i]) {
        final f = ((t - times[i - 1]) / (times[i] - times[i - 1])).clamp(
          0.0,
          1.0,
        );
        // Smooth the measured frames without flattening the brief recoil.
        final eased = f * f * (3 - 2 * f);
        return lerpDouble(values[i - 1], values[i], eased)!;
      }
    }
    return values.last;
  }

  double get _progress => _closing
      ? _sample(
          [0, .12, .27, .44, .62, .8, 1],
          [
            _start,
            _start * .99,
            _start * .91,
            _start * .64,
            _start * .30,
            _start * .075,
            0,
          ],
          _motion.value,
        )
      : _sample(
          [0, .17, .28, .39, .50, .64, .8, 1],
          [
            _start,
            _start,
            .13 + _start * .87,
            .39 + _start * .61,
            .71 + _start * .29,
            1.025,
            .99,
            1,
          ],
          _motion.value,
        );

  // The lower rim lifts, dips past its resting position, then settles.
  // Keep its current offset when a tap reverses an unfinished transition.
  double get _bottomOffset => _closing
      ? _sample(
          [0, .18, .40, .65, .83, 1],
          [_startBottomOffset, -3, 5, -2.5, .8, 0],
          _motion.value,
        )
      : _sample(
          [0, .17, .40, .64, .82, 1],
          [_startBottomOffset, 2, -7, 3.5, -1.2, 0],
          _motion.value,
        );

  void _toggle() {
    final current = _progress;
    final currentBottomOffset = _bottomOffset;
    setState(() {
      _start = current;
      _startBottomOffset = currentBottomOffset;
      _closing = _expanded;
      _expanded = !_expanded;
    });
    _motion.duration = Duration(milliseconds: _closing ? 470 : 600);
    if (MediaQuery.disableAnimationsOf(context)) {
      _motion.value = 1;
    } else {
      _motion.forward(from: 0);
    }
  }

  @override
  void initState() {
    super.initState();
    _closing = true;
    _motion.value = 1;
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xff8e9495),
    body: Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = math.min(320.0, constraints.maxWidth - 48);
              final scale = width / 320;
              final bottom = math.max(
                67.0,
                MediaQuery.paddingOf(context).bottom + 28,
              );
              return AnimatedBuilder(
                animation: _motion,
                builder: (context, _) {
                  final progress = _progress;
                  final pulse = math
                      .sin(math.pi * _motion.value)
                      .clamp(0.0, 1.0);
                  final stretch = _closing
                      ? 12 * pulse
                      : _sample(
                          [0, .16, .30, .48, .7, 1],
                          [0, 12, 7, -13, 2, 0],
                          _motion.value,
                        );
                  final panelWidth = (282 + 20 * progress + stretch) * scale;
                  final height = (50 + 210 * progress) * scale;
                  final rect = Rect.fromLTWH(
                    (constraints.maxWidth - panelWidth) / 2,
                    constraints.maxHeight -
                        bottom -
                        height +
                        _bottomOffset * scale,
                    panelWidth,
                    height,
                  );
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _ModalPainter(
                            rect,
                            width,
                            progress,
                            pulse,
                            scale,
                            bottom,
                          ),
                        ),
                      ),
                      Positioned.fromRect(
                        rect: rect,
                        child: Semantics(
                          button: true,
                          expanded: _expanded,
                          label: _expanded
                              ? 'Collapse glass modal'
                              : 'Expand glass modal',
                          child: Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                              key: const Key('glass-modal-surface'),
                              borderRadius: BorderRadius.circular(40 * scale),
                              splashFactory: NoSplash.splashFactory,
                              highlightColor: Colors.transparent,
                              onTap: _toggle,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onVerticalDragStart: (_) => _drag = 0,
                                onVerticalDragUpdate: (details) =>
                                    _drag += details.delta.dy,
                                onVerticalDragEnd: (details) {
                                  final movement =
                                      details.primaryVelocity!.abs() > 150
                                      ? details.primaryVelocity!
                                      : _drag;
                                  if ((movement < -12 && !_expanded) ||
                                      (movement > 12 && _expanded)) {
                                    _toggle();
                                  }
                                },
                                child: const SizedBox.expand(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Back to calm',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: const Color(0xff444d50),
                  ),
                  const Spacer(),
                  const Text(
                    'GLASS MOTION',
                    style: TextStyle(
                      color: Color(0xff485154),
                      fontSize: 11,
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _ModalPainter extends CustomPainter {
  const _ModalPainter(
    this.rect,
    this.trackWidth,
    this.progress,
    this.pulse,
    this.scale,
    this.bottom,
  );
  final Rect rect;
  final double trackWidth, progress, pulse, scale, bottom;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Color(0xffe0e0e2), Color(0xffa2a4a5), Color(0xff4c5a60)],
          stops: [0, .47, 1],
        ).createShader(bounds),
    );
    final trackRect = Rect.fromLTWH(
      (size.width - trackWidth) / 2,
      -60,
      trackWidth,
      size.height - bottom + 69 * scale,
    );
    final track = RRect.fromRectAndRadius(
      trackRect,
      Radius.circular(46 * scale),
    );
    canvas.drawRRect(
      track.shift(Offset(0, 8 * scale)),
      Paint()
        ..color = Colors.black.withValues(alpha: .12)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 17 * scale),
    );
    canvas.drawRRect(
      track,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: .13),
            Colors.white.withValues(alpha: .08),
            Colors.white.withValues(alpha: .19),
          ],
        ).createShader(trackRect),
    );

    final radius = lerpDouble(25, 40, progress.clamp(0, 1))! * scale;
    final panel = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    canvas.drawRRect(
      panel.shift(Offset(0, 5 * scale)),
      Paint()
        ..color = const Color(0xffe8e9eb).withValues(alpha: .15)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8 * scale),
    );
    canvas.drawRRect(
      panel,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: .12 + pulse * .13),
            const Color(0xffeeeef2).withValues(alpha: .35 + pulse * .2),
            const Color(0xfff7f5f9).withValues(alpha: .82 + pulse * .16),
          ],
          stops: const [0, .43, 1],
        ).createShader(rect),
    );
    canvas.save();
    canvas.clipRRect(panel);
    // Diffuse interior light gathers at the lower left and follows the morph.
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(
          rect.left + rect.width * .24,
          rect.bottom - rect.height * .21,
        ),
        width: rect.width * .8,
        height: rect.height * .85,
      ),
      Paint()
        ..color = Colors.white.withValues(alpha: .23 + pulse * .35)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 25 * scale),
    );
    canvas.drawRRect(
      panel.deflate(3 * scale),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5 * scale
        ..color = Colors.white.withValues(alpha: .13 + pulse * .3)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4 * scale),
    );
    canvas.restore();
    canvas.drawRRect(
      panel.deflate(.65 * scale),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3 * scale
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: .64),
            Colors.white.withValues(alpha: .18),
            Colors.white.withValues(alpha: .62),
          ],
        ).createShader(rect),
    );
    final handle = Rect.fromCenter(
      center: Offset(rect.center.dx, rect.top + 7 * scale),
      width: 43 * scale,
      height: 2.5 * scale,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(handle, Radius.circular(2 * scale)),
      Paint()..color = const Color(0xff707a7b).withValues(alpha: .29),
    );
  }

  @override
  bool shouldRepaint(_ModalPainter oldDelegate) =>
      oldDelegate.rect != rect ||
      oldDelegate.pulse != pulse ||
      oldDelegate.trackWidth != trackWidth ||
      oldDelegate.bottom != bottom;
}
