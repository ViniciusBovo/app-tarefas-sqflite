class TarefaModel {
  final int? id;
  final String titulo;
  final String descricao;
  final bool concluida;
  final String categoria;

  TarefaModel({
    this.id,
    required this.titulo,
    required this.descricao,
    this.concluida = false,
    this.categoria = 'Geral',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'concluida': concluida ? 1 : 0,
      'categoria': categoria,
    };
  }

  factory TarefaModel.fromMap(Map<String, dynamic> map) {
    return TarefaModel(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String,
      concluida: (map['concluida'] as int) == 1,
      categoria: (map['categoria'] as String?) ?? 'Geral',
    );
  }
}

