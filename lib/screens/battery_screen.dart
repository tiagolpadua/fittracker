import 'package:fittracker/service/native_bridge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BatteryScreen extends StatefulWidget {
  const BatteryScreen({super.key});

  @override
  State<BatteryScreen> createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {
  int? _batteryLevel;
  String? _error;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getBatteryLevel();
  }

  Future<void> _getBatteryLevel() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final int level = await NativeBridge.getBatteryLevel();
      setState(() => _batteryLevel = level);
    } on PlatformException catch (e) {
      setState(() => _error = e.message ?? 'Erro ao obter bateria');
    } on MissingPluginException {
      setState(() => _error = 'Metodo nao implementado na plataforma');
    } catch (e) {
      setState(() => _error = 'Erro inesperado: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Color _getBatteryColor() {
    if (_batteryLevel == null) return Colors.grey;
    if (_batteryLevel! > 50) return Colors.green;
    if (_batteryLevel! > 20) return Colors.orange;
    return Colors.red;
  }

  IconData _getBatteryIcon() {
    if (_batteryLevel == null) return Icons.battery_unknown;
    if (_batteryLevel! > 80) return Icons.battery_full;
    if (_batteryLevel! > 50) return Icons.battery_5_bar;
    if (_batteryLevel! > 20) return Icons.battery_3_bar;
    return Icons.battery_alert;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nivel de Bateria')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _error != null
                ? _buildError()
                : _buildBatteryInfo(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getBatteryLevel,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildBatteryInfo() {
    final level = _batteryLevel ?? 0;
    final color = _getBatteryColor();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(_getBatteryIcon(), size: 80, color: color),
        const SizedBox(height: 16),
        Text(
          '$level%',
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: level / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 12,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          level > 50
              ? 'Bateria boa'
              : level > 20
                  ? 'Bateria media'
                  : 'Bateria baixa!',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildError() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            _error ?? 'Erro desconhecido',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red[600]),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: _getBatteryLevel,
          icon: const Icon(Icons.refresh),
          label: const Text('Tentar novamente'),
        ),
      ],
    );
  }
}
