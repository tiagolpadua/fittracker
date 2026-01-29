# FitTracker

Um aplicativo Flutter para rastreamento de exercícios e treinos com animações sofisticadas.

## 📋 Estrutura do Projeto

```bash
lib/
├── config/              # Configurações da aplicação
│   └── app_theme.dart   # Temas light/dark
├── constants/           # Constantes da aplicação
│   └── app_constants.dart # Constantes globais (rotas, validações, etc)
├── models/              # Modelos de dados
│   └── exercise.dart    # Modelo de exercício
├── screens/             # Telas da aplicação
│   ├── home_screen.dart        # Tela inicial com lista de exercícios
│   ├── new_exercise_screen.dart # Tela para adicionar novo exercício
│   └── timer_screen.dart       # Tela de timer de descanso
├── utils/               # Funções utilitárias
│   └── format_utils.dart # Formatação de dados e cores
├── widgets/             # Widgets reutilizáveis
│   └── exercise_card.dart # Card de exercício com animações
└── main.dart            # Ponto de entrada da aplicação
```

## 🎯 Funcionalidades

- **Lista de Exercícios**: Visualize todos os exercícios com animações staggered
- **Novo Exercício**: Formulário completo com validação para adicionar exercícios
- **Timer de Descanso**: Timer customizável com presets (30s, 60s, 90s, 120s)
- **Progresso Semanal**: Acompanhamento da meta de treinos da semana
- **Animações**:
  - Staggered animations na lista
  - Animações implícitas em cards
  - Pulse animation no FAB
  - Animações de progresso

## 🔧 Como Usar

1. Instalar dependências:

```bash
flutter pub get
```

1. Executar a aplicação:

```bash
flutter run
```

1. Build para produção:

```bash
flutter build apk     # Android
flutter build ios     # iOS
```

## 📝 Melhorias Implementadas

- ✅ Reorganização de imports com padrão correto
- ✅ Remoção de código comentado residual
- ✅ Correção de typo no nome do arquivo (excercise_card → exercise_card)
- ✅ Remoção de widget WorkoutCounter duplicado
- ✅ Criação de estrutura de constantes
- ✅ Criação de utilitários para formatação
- ✅ Centralização de configuração de tema
- ✅ Remoção de print() em produção
- ✅ Uso de constantes para valores mágicos
- ✅ Melhor organização e manutenibilidade do código

## 🎨 Constantes Principais

As constantes estão centralizadas em `lib/constants/app_constants.dart`:

- **Rotas**: `routeHome`, `routeNewExercise`, `routeTimer`
- **Validações**: Limites de séries, repetições, peso, etc.
- **Animações**: Durações em ms
- **Categorias**: Lista de categorias de exercício

## 🚀 Próximos Passos (Sugestões)

- Implementar persistência de dados (SharedPreferences/Hive)
- Adicionar histórico de treinos
- Implementar notificações de timer
- Adicionar gráficos de progresso
- Testes unitários e de widget
