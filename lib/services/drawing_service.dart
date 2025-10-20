import 'package:flutter/material.dart';
import 'package:drawing_app/models/drawing_point.dart';

class DrawingService extends ChangeNotifier {
  List<List<DrawingPoint>> lines = [];
  List<List<DrawingPoint>> undoneLines = [];
  List<DrawingPoint> currentLine = [];

  void startDrawing(DrawingPoint point) {
    currentLine = [point];
    lines.add(currentLine);
    undoneLines.clear();
    notifyListeners();
  }

  void continueDrawing(DrawingPoint point) {
    currentLine.add(point);
    notifyListeners();
  }

  void endDrawing() {
    currentLine = [];
    notifyListeners();
  }

  void undo() {
    if (lines.isNotEmpty) {
      undoneLines.add(lines.removeLast());
      notifyListeners();
    }
  }

  void redo() {
    if (undoneLines.isNotEmpty) {
      lines.add(undoneLines.removeLast());
      notifyListeners();
    }
  }

  void clear() {
    lines.clear();
    undoneLines.clear();
    notifyListeners();
  }

  bool get canUndo => lines.isNotEmpty;
  bool get canRedo => undoneLines.isNotEmpty;
}