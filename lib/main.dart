import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drawing_app/screens/drawing_screen.dart';
import 'package:drawing_app/services/drawing_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => DrawingService(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawing App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DrawingScreen(),
    );
  }
}