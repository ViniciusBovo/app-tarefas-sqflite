import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/tarefa_model.dart';

class TarefasScreen extends StatefulWidget {
  const TarefasScreen({super.key});

  @override
  State<TarefasScreen> createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen>
    with SingleTickerProviderStateMixin {
  final _dbHelper = DatabaseHelper.instance;
  List<TarefaModel> _tarefas = [];
  bool _carregando = true;

  // Desafio: Filtro por Categoria (Abas)
  late TabController _tabController;
  final List<String> _categorias = [
    'Todas',
    'Geral',
    'Trabalho',
    'Pessoal',
    'Estudos'
  ];
  final List<String> _categoriasFormulario = [
    'Geral',
    'Trabalho',
    'Pessoal',
    'Estudos'
  ];

  // Desafio: Busca Local via SQL (LIKE)
  bool _estaBuscando = false;
  final TextEditingController _buscaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categorias.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _carregarTarefas();
      }
    });
    _carregarTarefas();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregarTarefas() async {
    setState(() => _carregando = true);
    final categoriaAtual = _categorias[_tabController.index];
    final termoBusca = _buscaController.text.trim();

    final List<TarefaModel> lista;
    if (termoBusca.isNotEmpty) {
      lista = await _dbHelper.buscarTarefas(
        termoBusca,
        categoria: categoriaAtual,
      );
    } else {
      lista = await _dbHelper.listarTarefas(categoria: categoriaAtual);
    }

    setState(() {
      _tarefas = lista;
      _carregando = false;
    });
  }

  void _abrirFormulario({TarefaModel? tarefa}) {
    final tituloController = TextEditingController(text: tarefa?.titulo ?? '');
    final descController = TextEditingController(text: tarefa?.descricao ?? '');
    String categoriaSelecionada = tarefa?.categoria ??
        (_tabController.index > 0 ? _categorias[_tabController.index] : 'Geral');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                tarefa == null ? 'Nova Tarefa' : 'Editar Tarefa',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: categoriaSelecionada,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                items: _categoriasFormulario
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setModalState(() {
                      categoriaSelecionada = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (tituloController.text.trim().isEmpty) return;
                  if (tarefa == null) {
                    await _dbHelper.criarTarefa(
                      TarefaModel(
                        titulo: tituloController.text.trim(),
                        descricao: descController.text.trim(),
                        categoria: categoriaSelecionada,
                      ),
                    );
                  } else {
                    await _dbHelper.atualizarTarefa(
                      TarefaModel(
                        id: tarefa.id,
                        titulo: tituloController.text.trim(),
                        descricao: descController.text.trim(),
                        concluida: tarefa.concluida,
                        categoria: categoriaSelecionada,
                      ),
                    );
                  }
                  if (mounted) {
                    Navigator.pop(ctx);
                    _carregarTarefas();
                  }
                },
                child: Text(tarefa == null ? 'Salvar' : 'Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int concluidas = _tarefas.where((t) => t.concluida).length;
    final int total = _tarefas.length;

    return Scaffold(
      appBar: AppBar(
        title: _estaBuscando
            ? TextField(
                controller: _buscaController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar tarefa (SQL LIKE)...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      _buscaController.clear();
                      _carregarTarefas();
                    },
                  ),
                ),
                onChanged: (_) => _carregarTarefas(),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Tarefas SQLite'),
                  Text(
                    '$total tarefas • $concluidas concluídas',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_estaBuscando ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _estaBuscando = !_estaBuscando;
                if (!_estaBuscando) {
                  _buscaController.clear();
                  _carregarTarefas();
                }
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categorias.map((cat) => Tab(text: cat)).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _tarefas.isEmpty
              ? const Center(child: Text('Nenhuma tarefa cadastrada.'))
              : ListView.builder(
                  itemCount: _tarefas.length,
                  itemBuilder: (ctx, index) {
                    final t = _tarefas[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: ListTile(
                        leading: Checkbox(
                          value: t.concluida,
                          onChanged: (val) async {
                            await _dbHelper.atualizarTarefa(
                              TarefaModel(
                                id: t.id,
                                titulo: t.titulo,
                                descricao: t.descricao,
                                concluida: val ?? false,
                                categoria: t.categoria,
                              ),
                            );
                            _carregarTarefas();
                          },
                        ),
                        title: Text(
                          t.titulo,
                          style: TextStyle(
                            decoration:
                                t.concluida ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (t.descricao.isNotEmpty) Text(t.descricao),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                t.categoria,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await _dbHelper.deletarTarefa(t.id!);
                            _carregarTarefas();
                          },
                        ),
                        onTap: () => _abrirFormulario(tarefa: t),
                      ),
                    );
                  },
                ),
    );
  }
}

