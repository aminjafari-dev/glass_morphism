import 'dart:ui';
import 'glass_toggle_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.dark,
      fontFamily: '.SF Pro Display',
      textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xff142b3b),
    ),
    home: const GlassHome(),
  );
}

class GlassHome extends StatefulWidget {
  const GlassHome({super.key});
  @override
  State<GlassHome> createState() => _GlassHomeState();
}

class _GlassHomeState extends State<GlassHome> {
  bool playing = false;
  bool focus = true;
  bool connected = true;
  double brightness = .68;
  int scene = 0;
  final scenes = ['Unwind', 'Create', 'Recharge'];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        const Positioned.fill(child: CustomPaint(painter: Landscape())),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: .03),
                  const Color(
                    0xff031c2b,
                  ).withValues(alpha: .72 - brightness * .25),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'A little space for you.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            letterSpacing: .2,
                          ),
                        ),
                      ),
                      GlassIcon(
                        icon: Icons.auto_awesome_outlined,
                        label: 'Open glass toggle',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const GlassTogglePage(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GlassIcon(
                        icon: Icons.more_horiz,
                        label: 'About this space',
                        onTap: () => showCupertinoDialog<void>(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title: const Text('Your personal space'),
                            content: const Text(
                              'Choose a mood, adjust the light, and take a moment. Sound controls are a visual demo.',
                            ),
                            actions: [
                              CupertinoDialogAction(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Done'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Make room\nfor calm.',
                    style: TextStyle(
                      fontSize: 42,
                      height: 1.04,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Less noise. More you.',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Glass(
                    radius: 32,
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                scene == 1
                                    ? Icons.light_mode_outlined
                                    : Icons.nightlight_round,
                                size: 23,
                              ),
                              const SizedBox(width: 9),
                              const Text(
                                'YOUR ATMOSPHERE',
                                style: TextStyle(
                                  fontSize: 11,
                                  letterSpacing: 1.8,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xffbcebcf),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Live',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            [
                              'Evening unwind',
                              'Find your flow',
                              'A fresh start',
                            ][scene],
                            style: const TextStyle(
                              fontSize: 28,
                              letterSpacing: -.8,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            [
                              'Settle into a softer kind of evening.',
                              'A little clarity for your next big idea.',
                              'Pause. Breathe. Begin again.',
                            ][scene],
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: List.generate(
                              3,
                              (index) => Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: index == 2 ? 0 : 8,
                                  ),
                                  child: GestureDetector(
                                    onTap: () => setState(() => scene = index),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: scene == index ? .85 : .07,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: .22,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        scenes[index],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: scene == index
                                              ? const Color(0xff263c44)
                                              : Colors.white,
                                        ),
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
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Glass(
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.nightlight_round,
                                      size: 23,
                                    ),
                                    const Spacer(),
                                    Transform.scale(
                                      scale: .75,
                                      alignment: Alignment.centerRight,
                                      child: CupertinoSwitch(
                                        value: focus,
                                        activeTrackColor: const Color(
                                          0xffa5c7bc,
                                        ),
                                        onChanged: (value) =>
                                            setState(() => focus = value),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 17),
                                const Text(
                                  'Focus',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  focus
                                      ? 'The world can wait'
                                      : 'Open to the world',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => connected = !connected),
                          child: Glass(
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.wifi_rounded, size: 25),
                                      const Spacer(),
                                      Icon(
                                        connected
                                            ? Icons.check_circle_outline_rounded
                                            : Icons.radio_button_unchecked,
                                        size: 18,
                                        color: Colors.white70,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Connection',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    connected
                                        ? 'Home · Connected'
                                        : 'Disconnected',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Glass(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 17, 20, 12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.light_mode_outlined, size: 21),
                              const SizedBox(width: 10),
                              const Text(
                                'Ambient light',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${(brightness * 100).round()}%',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 7,
                              activeTrackColor: Colors.white.withValues(
                                alpha: .8,
                              ),
                              inactiveTrackColor: Colors.white.withValues(
                                alpha: .14,
                              ),
                              thumbColor: Colors.white,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 10,
                              ),
                              overlayShape: SliderComponentShape.noOverlay,
                            ),
                            child: Slider(
                              value: brightness,
                              onChanged: (value) =>
                                  setState(() => brightness = value),
                              semanticFormatterCallback: (value) =>
                                  '${(value * 100).round()} percent',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Glass(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xffc3b7a0),
                                  Color(0xff356573),
                                  Color(0xff203e4c),
                                ],
                              ),
                            ),
                            child: const Icon(
                              Icons.graphic_eq_rounded,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Quiet tides',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  playing
                                      ? 'Soundscape · Preview playing'
                                      : 'Soundscape · Ocean sounds',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GlassIcon(
                            icon: playing
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            label: playing ? 'Pause preview' : 'Play preview',
                            onTap: () => setState(() => playing = !playing),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Center(
                    child: Text(
                      'BREATHE IN.  BREATHE OUT.',
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 2.4,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class GlassIcon extends StatelessWidget {
  const GlassIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: GestureDetector(
      onTap: onTap,
      child: Glass(
        radius: 50,
        child: SizedBox(width: 44, height: 44, child: Icon(icon, size: 19)),
      ),
    ),
  );
}

class Glass extends StatelessWidget {
  const Glass({super.key, required this.child, this.radius = 26});
  final Widget child;
  final double radius;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: const Color(0xff071c28).withValues(alpha: .13),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: .16),
                Colors.white.withValues(alpha: .035),
                Colors.white.withValues(alpha: .08),
              ],
              stops: const [0, .5, 1],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: .12),
              width: .5,
            ),
          ),
          child: CustomPaint(
            foregroundPainter: GlassEdge(radius),
            child: child,
          ),
        ),
      ),
    ),
  );
}

/// Directional reflections keep transparent surfaces legible without an opaque fill.
class GlassEdge extends CustomPainter {
  const GlassEdge(this.radius);
  final double radius;
  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(.7);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = .85
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: .8),
            Colors.white.withValues(alpha: .06),
            Colors.white.withValues(alpha: .12),
            Colors.white.withValues(alpha: .45),
          ],
          stops: const [0, .4, .65, 1],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(GlassEdge oldDelegate) => radius != oldDelegate.radius;
}

class Landscape extends CustomPainter {
  const Landscape();
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff748a9b),
            Color(0xffc2ab98),
            Color(0xff769898),
            Color(0xff245567),
          ],
          stops: [0, .36, .57, 1],
        ).createShader(rect),
    );
    canvas.drawCircle(
      Offset(size.width * .79, size.height * .31),
      60,
      Paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40)
        ..color = const Color(0xfff5d3ab).withValues(alpha: .55),
    );
    final mountain = Path()
      ..moveTo(0, size.height * .47)
      ..cubicTo(
        size.width * .15,
        size.height * .39,
        size.width * .21,
        size.height * .45,
        size.width * .38,
        size.height * .48,
      )
      ..cubicTo(
        size.width * .60,
        size.height * .50,
        size.width * .78,
        size.height * .40,
        size.width,
        size.height * .46,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      mountain,
      Paint()..color = const Color(0xff436d77).withValues(alpha: .55),
    );
    final coast = Path()
      ..moveTo(0, size.height * .57)
      ..cubicTo(
        size.width * .23,
        size.height * .53,
        size.width * .44,
        size.height * .61,
        size.width * .68,
        size.height * .64,
      )
      ..cubicTo(
        size.width * .93,
        size.height * .68,
        size.width * .58,
        size.height * .80,
        size.width,
        size.height * .86,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      coast,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff183d50), Color(0xff37616b), Color(0xff092c41)],
        ).createShader(rect),
    );
    for (int i = 0; i < 24; i++) {
      final y = size.height * (.48 + i * .022);
      canvas.drawLine(
        Offset(size.width * .5, y),
        Offset(size.width, y + 8),
        Paint()
          ..color = Colors.white.withValues(alpha: .025)
          ..strokeWidth = 1,
      );
    }
  }

  @override
  bool shouldRepaint(covariant Landscape oldDelegate) => false;
}
