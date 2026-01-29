# Aplicação do Exercício Aula 6 - SettingsProvider

## Mudanças Realizadas

### 1. **pubspec.yaml**
- Adicionado dependência: `provider: ^6.1.5+1`

### 2. **lib/config/settings_provider.dart** (Novo Arquivo)
Criado novo arquivo com a classe `SettingsProvider` que gerencia:
- `themeMode`: Controle do tema (claro/escuro)
- `showCompletedExercises`: Flag para exibir/ocultar exercícios completos
- `measurementUnit`: Unidade de medida (kg/lb)

Métodos fornecidos:
- `toggleTheme()`: Alterna entre tema claro e escuro
- `setThemeMode(mode)`: Define o tema explicitamente
- `toggleShowCompleted()`: Alterna exibição de exercícios completos
- `setMeasurementUnit(unit)`: Define a unidade de medida

### 3. **lib/main.dart**
- Importado `SettingsProvider` e `Provider`
- Envolvido `FitTrackerApp` com `ChangeNotifierProvider`
- `FitTrackerApp` agora usa `Consumer<SettingsProvider>` para reagir a mudanças de tema
- `themeMode` agora é controlado dinamicamente pelo provider

### 4. **lib/screens/home_screen.dart**
- Importado `SettingsProvider` e `provider` package
- Adicionado método `_showSettingsSheet()` que exibe um bottom sheet com:
  - Switch para alternar tema (com toggle do provider)
  - Switch para mostrar/ocultar exercícios completos
  - Dropdown para seleção de unidade de medida
- Adicionado `Selector` no AppBar para otimizar re-builds ao alternar tema
- Botão de tema dinâmico que mostra ícone claro/escuro baseado no estado
- Removed rota hardcoded para settings e implementado sheet dinâmica

## Conceitos Demonstrados

✅ **Provider com ChangeNotifier**: Gerenciamento de estado global
✅ **Consumer**: Reação a mudanças de estado
✅ **Selector**: Otimização de re-builds para propriedades específicas
✅ **Tema Dinâmico**: Alteração de tema em tempo de execução
✅ **Settings Globais**: Configurações persistentes no estado

## Compilação

O projeto foi analisado e não apresenta erros:
```
Analyzing fittracker...
No issues found! (ran in 1.4s)
```

## Como Testar

1. Execute o projeto: `flutter run`
2. Clique no ícone de tema (sol/lua) no AppBar para alternar entre claro e escuro
3. Clique no ícone de configurações para abrir o bottom sheet
4. Teste os switches e dropdowns que refletem mudanças em tempo real
