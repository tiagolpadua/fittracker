import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/rest_record.dart';

class TimerScreen extends StatefulWidget {
  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _remainingSeconds = 60;
  int _selectedSeconds = 60;
  Timer? _timer;
  bool _isRunning = false;

  final List<RestRecord> _history = [];

  final List<int> _presets = [30, 60, 90, 120];

  @override
  void initState() {
    super.initState();
    debugPrint('TimerScreen: initState()');
  }

  @override
  void dispose() {
    debugPrint('TimerScreen: dispose()');
    _timer?.cancel();
    super.dispose();
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

  void _selectPreset(int seconds) {
    _timer?.cancel();
    setState(() {
      _selectedSeconds = seconds;
      _remainingSeconds = seconds;
      _isRunning = false;
    });
  }

  void _onTimerComplete() {
    _timer?.cancel();

    setState(() {
      _isRunning = false;
      _history.add(RestRecord(seconds: _selectedSeconds, time: DateTime.now()));
      _remainingSeconds = _selectedSeconds;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Descanso completo! Hora de treinar!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _formatPreset(int seconds) {
    if (seconds >= 60) {
      int mins = seconds ~/ 60;
      int secs = seconds % 60;
      return secs > 0 ? '${mins}m${secs}s' : '${mins}min';
    }
    return '${seconds}s';
  }

  double get _progress {
    if (_selectedSeconds == 0) return 0;
    return _remainingSeconds / _selectedSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Timer de Descanso')),
      body: SingleChildScrollView(
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
                children: _presets.map((seconds) {
                  bool isSelected = _selectedSeconds == seconds;
                  return ChoiceChip(
                    label: Text(_formatPreset(seconds)),
                    selected: isSelected,
                    selectedColor: Colors.orange,
                    onSelected:
                        _isRunning ? null : (_) => _selectPreset(seconds),
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
                    backgroundColor:
                        _isRunning ? Colors.orange : Colors.grey[300],
                    child: Icon(Icons.skip_next),
                  ),
                ],
              ),
              SizedBox(height: 40),
              if (_history.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Histórico de Descansos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(onPressed: _clearHistory, child: Text('Limpar')),
                  ],
                ),
                SizedBox(height: 8),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      final record = _history[_history.length - 1 - index];
                      return Container(
                        margin: EdgeInsets.only(right: 12),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange[200]!),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _formatPreset(record.seconds),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[800],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${record.time.hour}:${record.time.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
