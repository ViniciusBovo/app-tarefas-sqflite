import 'package:flutter_test/flutter_test.dart';
import 'package:app_sqlite_tarefas/models/tarefa_model.dart';

void main() {
  group('TarefaModel Tests', () {
    test('toMap converte corretamente para Map', () {
      final tarefa = TarefaModel(
        id: 1,
        titulo: 'Estudar Flutter',
        descricao: 'Aula 13 SQLite',
        concluida: true,
        categoria: 'Estudos',
      );

      final map = tarefa.toMap();

      expect(map['id'], 1);
      expect(map['titulo'], 'Estudar Flutter');
      expect(map['descricao'], 'Aula 13 SQLite');
      expect(map['concluida'], 1);
      expect(map['categoria'], 'Estudos');
    });

    test('fromMap instancia TarefaModel corretamente', () {
      final map = {
        'id': 2,
        'titulo': 'Comprar café',
        'descricao': 'Mercado central',
        'concluida': 0,
        'categoria': 'Pessoal',
      };

      final tarefa = TarefaModel.fromMap(map);

      expect(tarefa.id, 2);
      expect(tarefa.titulo, 'Comprar café');
      expect(tarefa.descricao, 'Mercado central');
      expect(tarefa.concluida, false);
      expect(tarefa.categoria, 'Pessoal');
    });
  });
}
