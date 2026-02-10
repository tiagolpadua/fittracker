import 'package:fittracker/modules/timer/timer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Pagina do timer de descanso (modulo Timer).
///
/// O [TimerService] e injetado como Lazy Singleton
/// pelo [TimerModule] via Flutter Modular.
class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final TimerService timerService = Modular.get<TimerService>();

  @override
  void initState() {
    super.initState();
    timerService.reset();
    timerService.setDuration(60);
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timer de Descanso')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Timer de Descanso',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Timer com StreamBuilder
            StreamBuilder<int>(
              stream: timerService.stream,
              initialData: timerService.seconds,
              builder: (context, snapshot) {
                final seconds = snapshot.data ?? 0;
                final progress = seconds / 60;

                return Column(
                  children: [
                    // Progresso circular
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 10,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation(
                                seconds <= 10 && seconds > 0
                                    ? Colors.red
                                    : Colors.orange,
                              ),
                            ),
                          ),
                          Text(
                            _formatTime(seconds),
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                              color: seconds <= 10 && seconds > 0
                                  ? Colors.red
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (seconds == 0)
                      const Text(
                        'Tempo esgotado!',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                  ],
                );
              },
            ),

            const SizedBox(height: 32),

            // Controles
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!timerService.isRunning)
                  ElevatedButton.icon(
                    onPressed: () {
                      timerService.start();
                      setState(() {});
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Iniciar'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: () {
                      timerService.pause();
                      setState(() {});
                    },
                    icon: const Icon(Icons.pause),
                    label: const Text('Pausar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    timerService.reset();
                    timerService.setDuration(60);
                    setState(() {});
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Resetar'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Selecao de tempo
            Text('Duracao:', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [30, 60, 90, 120].map((secs) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ActionChip(
                    label: Text('${secs}s'),
                    onPressed: () {
                      timerService.reset();
                      timerService.setDuration(secs);
                      setState(() {});
                    },
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
