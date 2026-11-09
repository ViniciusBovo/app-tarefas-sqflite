import 'package:flutter/material.dart';
import 'screens/tarefas_screen.dart';

void main() => runApp(const MeuApp());

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aula 13 - SQLite',
      theme: ThemeData(
        useMaterial3: true,
        // O roteiro cita Colors.emerald; como no Flutter SDK nativo não há Colors.emerald,
        // utiliza-se a cor esmeralda hexadecimal correspondente (0xFF00A86B)
        colorSchemeSeed: const Color(0xFF00A86B),
      ),
      home: const TarefasScreen(),
    );
  }
}
