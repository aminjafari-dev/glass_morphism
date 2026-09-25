import 'package:flutter/material.dart';
import 'glass_home.dart';

/// The original dashboard, rendered using the toggle's clear lens material.
class LiquidGlassPage extends StatelessWidget {
  const LiquidGlassPage({super.key});
  @override
  Widget build(BuildContext context) => const GlassHome(liquid: true);
}
