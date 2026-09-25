import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'glass_home.dart';
export 'glass_home.dart';

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
