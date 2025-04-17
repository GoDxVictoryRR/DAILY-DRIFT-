import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'splash.dart'; // Keep your splash here

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase initialization
  runApp(MyApp());
}

Color blendColors(Color c1, Color c2, [double t = 0.5]) {
  return Color.lerp(c1, c2, t)!;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final blendedColor = blendColors(
      Colors.orange.shade700,
      Colors.purple.shade700,
      1,
    );

    return MaterialApp(
      title: 'Daily Drift!!!',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: blendedColor),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Splash(), // Show splash, which will handle auth navigation
    );
  }
}
