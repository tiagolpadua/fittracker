import 'package:flutter/material.dart';

/// Utilitarios para formatacao de dados
class FormatUtils {
  /// Formata segundos em formato de tempo (mm:ss)
  static String formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  /// Formata um valor em segundos para um preset legivel
  static String formatPreset(int seconds) {
    if (seconds >= 60) {
      int mins = seconds ~/ 60;
      int secs = seconds % 60;
      return secs > 0 ? '${mins}m${secs}s' : '${mins}min';
    }
    return '${seconds}s';
  }

  /// Retorna a cor baseada na categoria do exercicio
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'peito':
        return Colors.red;
      case 'costas':
        return Colors.blue;
      case 'pernas':
        return Colors.green;
      case 'ombros':
        return Colors.purple;
      case 'biceps':
      case 'bíceps':
        return Colors.orange;
      case 'triceps':
      case 'tríceps':
        return Colors.teal;
      case 'abdomen':
      case 'abdômen':
        return Colors.indigo;
      case 'cardio':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  /// Retorna a cor do progresso baseada no percentual
  static Color getProgressColor(double progress) {
    if (progress < 0.3) return Colors.red;
    if (progress < 0.7) return Colors.orange;
    return Colors.green;
  }
}
