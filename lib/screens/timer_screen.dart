import 'package:fittracker/constants/app_constants.dart';
import 'package:fittracker/services/timer_service.dart';
import 'package:fittracker/utils/format_utils.dart';
import 'package:flutter/material.dart';

/// TimerScreen refatorada para usar TimerService com StreamBuilder
/// Demonstra: StreamBuilder, separacao de concerns, Stream-based state
class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final TimerService _timerService = TimerService();
  int _selectedSeconds = 60;

  @override
  void initState() {
    super.initState();
    _timerService.setDuration(_selectedSeconds);
  }

  void _selectPreset(int seconds) {
    setState(() {
      _selectedSeconds = seconds;
    });
    _timerService.setDuration(seconds);
  }

  double _getProgress(int remainingSeconds) {
    if (_selectedSeconds == 0) return 0;
    return remainingSeconds / _selectedSeconds;
  }

  void _onTimerComplete() {
    _timerService.reset();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Descanso completo! Hora de treinar!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _timerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Timer de Descanso')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'Selecione o tempo:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12),
                _buildPresetChips(),
                SizedBox(height: 40),
                _buildTimerDisplay(),
                SizedBox(height: 40),
                _buildControlButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Chips de selecao de tempo predefinido
  Widget _buildPresetChips() {
    return Wrap(
      spacing: 12,
      children: AppConstants.timerPresets.map((seconds) {
        bool isSelected = _selectedSeconds == seconds;
        return ChoiceChip(
          label: Text(FormatUtils.formatPreset(seconds)),
          selected: isSelected,
          selectedColor: Colors.orange,
          onSelected: _timerService.isRunning
              ? null
              : (_) => _selectPreset(seconds),
        );
      }).toList(),
    );
  }

  /// Display do timer com StreamBuilder
  Widget _buildTimerDisplay() {
    return StreamBuilder<int>(
      stream: _timerService.stream,
      initialData: _selectedSeconds,
      builder: (context, snapshot) {
        final remainingSeconds = snapshot.data ?? _selectedSeconds;
        final progress = _getProgress(remainingSeconds);

        // Verificar se o timer completou
        if (remainingSeconds == 0 && _timerService.isRunning == false) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _timerService.seconds == 0) {
              _onTimerComplete();
            }
          });
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 220,
              height: 220,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 12,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  remainingSeconds <= 10 ? Colors.red : Colors.orange,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _timerService.isRunning ? Icons.timer : Icons.timer_outlined,
                  size: 32,
                  color: Colors.grey,
                ),
                SizedBox(height: 8),
                Text(
                  FormatUtils.formatTime(remainingSeconds),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: remainingSeconds <= 10
                        ? Colors.red
                        : Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Botoes de controle do timer
  Widget _buildControlButtons() {
    return StreamBuilder<int>(
      stream: _timerService.stream,
      initialData: _selectedSeconds,
      builder: (context, snapshot) {
        final isRunning = _timerService.isRunning;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: 'reset',
              onPressed: () {
                _timerService.reset();
                setState(() {}); // Atualiza UI para refletir isRunning
              },
              backgroundColor: Colors.grey,
              child: Icon(Icons.refresh),
            ),
            SizedBox(width: 20),
            FloatingActionButton.large(
              heroTag: 'playPause',
              onPressed: () {
                if (isRunning) {
                  _timerService.pause();
                } else {
                  _timerService.start();
                }
                setState(() {}); // Atualiza UI para refletir isRunning
              },
              backgroundColor: isRunning ? Colors.red : Colors.green,
              child: Icon(
                isRunning ? Icons.pause : Icons.play_arrow,
                size: 40,
              ),
            ),
            SizedBox(width: 20),
            FloatingActionButton(
              heroTag: 'skip',
              onPressed: isRunning
                  ? () {
                      _timerService.reset();
                      setState(() {});
                      _onTimerComplete();
                    }
                  : null,
              backgroundColor: isRunning
                  ? Colors.orange
                  : Colors.grey[300],
              child: Icon(Icons.skip_next),
            ),
          ],
        );
      },
    );
  }
}
