import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drawing_app/models/drawing_point.dart';
import 'package:drawing_app/services/drawing_service.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  Color selectedColor = Colors.black;
  double strokeWidth = 3.0;

  @override
  Widget build(BuildContext context) {
    final drawingService = Provider.of<DrawingService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawing App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: drawingService.canUndo ? () => drawingService.undo() : null,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: drawingService.canRedo ? () => drawingService.redo() : null,
          ),
        ],
      ),
      body: GestureDetector(
        onPanStart: (details) {
          drawingService.startDrawing(DrawingPoint(details.localPosition, selectedColor, strokeWidth));
        },
        onPanUpdate: (details) {
          drawingService.continueDrawing(DrawingPoint(details.localPosition, selectedColor, strokeWidth));
        },
        onPanEnd: (details) {
          drawingService.endDrawing();
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: DrawingPainter(drawingService.lines),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.color_lens, color: Colors.red),
              onPressed: () => setState(() => selectedColor = Colors.red),
            ),
            IconButton(
              icon: const Icon(Icons.color_lens, color: Colors.blue),
              onPressed: () => setState(() => selectedColor = Colors.blue),
            ),
            IconButton(
              icon: const Icon(Icons.color_lens, color: Colors.green),
              onPressed: () => setState(() => selectedColor = Colors.green),
            ),
            IconButton(
              icon: const Icon(Icons.color_lens, color: Colors.black),
              onPressed: () => setState(() => selectedColor = Colors.black),
            ),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => drawingService.clear(),
            ),
            Slider(
              value: strokeWidth,
              min: 1.0,
              max: 10.0,
              onChanged: (value) => setState(() => strokeWidth = value),
            )
          ],
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<List<DrawingPoint>> lines;

  DrawingPainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    for (var line in lines) {
      for (int i = 0; i < line.length - 1; i++) {
        final p1 = line[i];
        final p2 = line[i + 1];
        if (p1 != null && p2 != null) {
          final paint = Paint()
            ..color = p1.color
            ..strokeWidth = p1.strokeWidth
            ..strokeCap = StrokeCap.round;

          canvas.drawLine(p1.offset, p2.offset, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}