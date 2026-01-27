import 'package:flutter/material.dart';

import '../core/settings/app_settings.dart';
import '../models/exercise.dart';

/// ExerciseCard com animacoes implicitas
/// Demonstra: AnimatedContainer, AnimatedOpacity, AnimatedSwitcher
class ExerciseCard extends StatefulWidget {
  final Exercise exercise;
  final VoidCallback onDelete;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onDelete,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isCompleted = false;

  Color _getCategoryColor() {
    switch (widget.exercise.category.toLowerCase()) {
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

  @override
  Widget build(BuildContext context) {
    final settings = AppSettings.of(context);
    final categoryColor = _getCategoryColor();

    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: () {
            setState(() => _isCompleted = !_isCompleted);
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeOut,
            transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
            decoration: BoxDecoration(
              color: _isCompleted
                  ? Colors.green.withOpacity(0.1)
                  : (_isHovered ? Colors.grey[50] : Colors.white),
              borderRadius: BorderRadius.circular(_isHovered ? 16 : 12),
              border: Border.all(
                color: _isCompleted
                    ? Colors.green
                    : (_isHovered
                        ? categoryColor.withOpacity(0.5)
                        : Colors.grey[200]!),
                width: _isCompleted ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_isHovered ? 0.1 : 0.05),
                  blurRadius: _isHovered ? 12 : 4,
                  offset: Offset(0, _isHovered ? 6 : 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icone com animacao
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: _isHovered ? 55 : 50,
                    height: _isHovered ? 55 : 50,
                    decoration: BoxDecoration(
                      color: _isCompleted
                          ? Colors.green.withOpacity(0.2)
                          : categoryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(_isHovered ? 16 : 12),
                    ),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        _isCompleted ? Icons.check : Icons.fitness_center,
                        key: ValueKey(_isCompleted),
                        color: _isCompleted ? Colors.green : categoryColor,
                        size: _isHovered ? 28 : 24,
                      ),
                    ),
                  ),

                  SizedBox(width: 16),

                  // Informacoes
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: _isHovered ? 17 : 16,
                            fontWeight: FontWeight.bold,
                            color: _isCompleted
                                ? Colors.green[700]
                                : Colors.black87,
                            decoration: _isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                          child: Text(widget.exercise.name),
                        ),
                        SizedBox(height: 4),
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 200),
                          opacity: _isCompleted ? 0.5 : 1,
                          child: Text(
                            widget.exercise.category,
                            style: TextStyle(
                              fontSize: 12,
                              color: categoryColor,
                            ),
                          ),
                        ),
                        if (widget.exercise.weight != null)
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 200),
                            opacity: _isCompleted ? 0.5 : 1,
                            child: Text(
                              '${widget.exercise.weight} ${settings.weightUnit}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Sets x Reps
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: _isHovered ? 14 : 12,
                      vertical: _isHovered ? 8 : 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          _isCompleted ? Colors.green[50] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${widget.exercise.sets}x${widget.exercise.reps}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isCompleted
                            ? Colors.green[700]
                            : Colors.grey[700],
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  // Botao de remover com fade
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 200),
                    opacity: _isHovered ? 1 : 0.3,
                    child: IconButton(
                      icon: Icon(Icons.delete_outline),
                      color: Colors.red[300],
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Remover exercicio?'),
                            content: Text(
                                'Deseja remover "${widget.exercise.name}" da lista?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  widget.onDelete();
                                },
                                child: Text('Remover',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
