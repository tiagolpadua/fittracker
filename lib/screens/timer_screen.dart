import 'dart:async';

import 'package:fittracker/constants/app_constants.dart';
import 'package:fittracker/utils/format_utils.dart';
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _remainingSeconds = 60;
  int _selectedSeconds = 60;
  Timer? _timer;
  bool _isRunning = false;

  void _selectPreset(int seconds) {
    _timer?.cancel();
    setState(() {
      _selectedSeconds = seconds;
      _remainingSeconds = seconds;
      _isRunning = false;
    });
  }

  double get _progress {
    if (_selectedSeconds == 0) return 0;
    return _remainingSeconds / _selectedSeconds;
  }

  String _formatTime(int seconds) {
    return FormatUtils.formatTime(seconds);
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _onTimerComplete();
      }
    });
  }

  void _onTimerComplete() {
    _timer?.cancel();

    setState(() {
      _isRunning = false;
      _remainingSeconds = _selectedSeconds;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Descanso completo! Hora de treinar!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _selectedSeconds;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
                Wrap(
                  spacing: 12,
                  children: AppConstants.timerPresets.map((seconds) {
                    bool isSelected = _selectedSeconds == seconds;
                    return ChoiceChip(
                      label: Text(FormatUtils.formatPreset(seconds)),
                      selected: isSelected,
                      selectedColor: Colors.orange,
                      onSelected: _isRunning
                          ? null
                          : (_) => _selectPreset(seconds),
                    );
                  }).toList(),
                ),
                SizedBox(height: 40),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: CircularProgressIndicator(
                        value: _progress,
                        strokeWidth: 12,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _remainingSeconds <= 10 ? Colors.red : Colors.orange,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isRunning ? Icons.timer : Icons.timer_outlined,
                          size: 32,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          _formatTime(_remainingSeconds),
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: _remainingSeconds <= 10
                                ? Colors.red
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      heroTag: 'reset',
                      onPressed: _resetTimer,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.refresh),
                    ),
                    SizedBox(width: 20),
                    FloatingActionButton.large(
                      heroTag: 'playPause',
                      onPressed: _isRunning ? _pauseTimer : _startTimer,
                      backgroundColor: _isRunning ? Colors.red : Colors.green,
                      child: Icon(
                        _isRunning ? Icons.pause : Icons.play_arrow,
                        size: 40,
                      ),
                    ),
                    SizedBox(width: 20),
                    FloatingActionButton(
                      heroTag: 'skip',
                      onPressed: _isRunning ? _onTimerComplete : null,
                      backgroundColor: _isRunning
                          ? Colors.orange
                          : Colors.grey[300],
                      child: Icon(Icons.skip_next),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
