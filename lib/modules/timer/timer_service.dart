import 'dart:async';

class TimerService {
  StreamController<int>? _controller;
  Timer? _timer;
  int _seconds = 0;
  int _initialSeconds = 60;
  bool _isRunning = false;

  /// Stream de segundos restantes
  Stream<int> get stream {
    _controller ??= StreamController<int>.broadcast();
    return _controller!.stream;
  }

  /// Indica se o timer esta rodando
  bool get isRunning => _isRunning;

  /// Segundos restantes
  int get seconds => _seconds;

  /// Segundos iniciais configurados
  int get initialSeconds => _initialSeconds;

  /// Define a duracao do timer
  void setDuration(int seconds) {
    _initialSeconds = seconds;
    _seconds = seconds;
    _controller?.add(_seconds);
  }

  /// Inicia o timer
  void start() {
    if (_isRunning) return;

    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        _seconds--;
        _controller?.add(_seconds);
      } else {
        stop();
      }
    });
  }

  /// Pausa o timer
  void pause() {
    _timer?.cancel();
    _isRunning = false;
  }

  /// Reseta o timer para o valor inicial
  void reset() {
    _timer?.cancel();
    _isRunning = false;
    _seconds = _initialSeconds;
    _controller?.add(_seconds);
  }

  /// Para o timer completamente
  void stop() {
    _timer?.cancel();
    _isRunning = false;
    _seconds = 0;
    _controller?.add(_seconds);
  }

  /// Libera recursos
  void dispose() {
    _timer?.cancel();
    _controller?.close();
    _controller = null;
  }
}
