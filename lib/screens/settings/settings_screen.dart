import 'package:flutter/material.dart';

import '../../core/settings/app_settings.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = AppSettings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Modo Escuro'),
            subtitle: Text('Ativar tema escuro'),
            secondary: Icon(
              settings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
            value: settings.isDarkMode,
            onChanged: (_) => settings.toggleDarkMode(),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.fitness_center),
            title: Text('Unidade de Peso'),
            subtitle: Text('Quilogramas (kg) ou Libras (lb)'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<String>(
              selected: {settings.weightUnit},
              onSelectionChanged: (Set<String> selected) {
                settings.setWeightUnit(selected.first);
              },
              segments: [
                ButtonSegment(
                  value: 'kg',
                  label: Text('Quilogramas (kg)'),
                ),
                ButtonSegment(
                  value: 'lb',
                  label: Text('Libras (lb)'),
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Sobre o FitTracker'),
            subtitle: Text('Versão 1.0.0 - Aula 04 Flutter'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'FitTracker',
                applicationVersion: '1.0.0',
                applicationLegalese: 'Projeto educacional - Curso Flutter',
              );
            },
          ),
        ],
      ),
    );
  }
}
