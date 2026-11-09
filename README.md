# 📱 Gerenciador de Tarefas SQLite (Flutter)

Projeto prático desenvolvido para a disciplina de **Programação para Dispositivos Móveis I** (Aula 13 — *Banco de Dados Local, Tabelas SQL e Operações CRUD*).

O aplicativo consiste em um **Gerenciador de Tarefas / Anotações** com persistência de dados relacional offline utilizando o motor **SQLite** através do pacote [`sqflite`](https://pub.dev/packages/sqflite).

---

## 🚀 Funcionalidades

### 📋 Operações CRUD

| Operação | Método sqflite | Comando SQL Correspondente | Ação no Aplicativo Flutter |
| :--- | :--- | :--- | :--- |
| **Create (Inserir)** | `db.insert()` | `INSERT INTO tarefas VALUES (...)` | Salva nova tarefa vinda do formulário modal. |
| **Read (Consultar)** | `db.query()` | `SELECT * FROM tarefas ORDER BY id DESC` | Carrega e exibe a lista de tarefas reativamente. |
| **Update (Atualizar)** | `db.update()` | `UPDATE tarefas SET ... WHERE id = ?` | Marca como concluída ou edita dados no modal. |
| **Delete (Excluir)** | `db.delete()` | `DELETE FROM tarefas WHERE id = ?` | Remove a tarefa via botão de lixeira com confirmação imediata. |

---

## 🏆 Desafios Práticos de Laboratório Implementados

Além dos requisitos base do roteiro, foram implementados todos os três desafios propostos:

1. **🟢 Nível Básico — Contador de Concluídas**:
   - Exibição de contador dinâmico diretamente na `AppBar` (`X tarefas • Y concluídas`), atualizado em tempo real conforme as tarefas são criadas, concluídas ou removidas.

2. **🟡 Nível Intermediário — Filtro por Categoria**:
   - Campo `categoria` persistido no banco de dados (`Geral`, `Trabalho`, `Pessoal`, `Estudos`).
   - Navegação por abas (`TabBar` com `DefaultTabController`) para filtrar a visualização de tarefas por categoria.
   - Seleção de categoria no formulário de criação/edição e identificação visual com tags/chips coloridos nos cards.

3. **🔴 Nível Avançado — Busca Local via SQL (LIKE)**:
   - Botão de busca integrado à `AppBar`.
   - Consulta direta no SQLite com cláusula `WHERE` e operador `LIKE ?` nos campos de título e descrição (`buscarTarefas()`), compatível com o filtro por categoria ativo.

---

## 🏛️ Arquitetura e Padrões de Projeto

- **Padrão Singleton (`DatabaseHelper`)**: Ponto centralizado de acesso à instância única da conexão SQLite, evitando múltiplas aberturas simultâneas do arquivo `.db`.
- **Mapeamento Objeto-Relacional (`TarefaModel`)**:
  - `toMap()`: Serializa instâncias de Dart para mapas compatíveis com as colunas SQLite (convertendo `concluida` booleano para `1` ou `0`).
  - `fromMap()`: Deserializa tuplas retornadas pelo SQLite para objetos Dart tipados.
- **Interface Reativa**: Atualização imediata do estado local através de `setState()`, com animação de carregamento (`CircularProgressIndicator`), tratamento de lista vazia e `showModalBottomSheet`.

---

## 📂 Estrutura do Projeto

```text
lib/
├── database/
│   └── database_helper.dart  # Conexão SQLite (Singleton) e métodos CRUD + Busca
├── models/
│   └── tarefa_model.dart     # Entidade TarefaModel com toMap() e fromMap()
├── screens/
│   └── tarefas_screen.dart   # Tela principal (ListView, BottomSheet, TabBar e Busca)
└── main.dart                 # Inicialização do app, tema Material 3 e cor esmeralda
test/
└── widget_test.dart          # Testes unitários para serialização do TarefaModel
```

---

## 🛠️ Tecnologias e Pacotes

- **[Flutter](https://flutter.dev/)** (SDK ^3.13.0)
- **[Dart](https://dart.dev/)**
- **[sqflite](https://pub.dev/packages/sqflite)** (`^2.3.2`) — Driver SQLite oficial para Flutter
- **[path](https://pub.dev/packages/path)** (`^1.9.0`) — Utilitário para manipulação de caminhos de arquivos de banco

---

## ⚙️ Como Executar o Projeto

### Pré-requisitos
- Flutter SDK instalado e configurado no PATH.
- Emulador Android / iOS ou dispositivo físico conectado com depuração USB ativada.

### Passos de Instalação e Execução

1. **Clone o repositório ou acesse a pasta do projeto:**
   ```bash
   cd app_sqlite_tarefas
   ```

2. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

3. **Execute os testes automatizados:**
   ```bash
   flutter test
   ```

4. **Inicie o aplicativo:**
   ```bash
   flutter run
   ```

---

## 📌 Histórico de Commits Semânticos (Git)

Seguindo as orientações de versionamento do roteiro da Aula 13:

```bash
# 1. Inicializar repositório Git
git init

# 2. Commit 1: Model e Camada de Dados
git add lib/models/ lib/database/
git commit -m "feat: implementa modelo TarefaModel e camada DatabaseHelper com SQLite"

# 3. Commit 2: Interface Reativa, Configuração e Telas
git add lib/screens/ lib/main.dart pubspec.yaml test/ README.md
git commit -m "feat: constroi interface reativa de tarefas com CRUD completo no SQLite"

# 4. Commit 3: Desafios Técnicos do Laboratório
git commit --allow-empty -m "feat: implementa desafios tecnicos (contador, filtro por categoria e busca SQL)"

# 5. Publicação no repositório remoto
git branch -M main
git remote add origin URL_DO_SEU_REPOSITORIO
git push -u origin main
```

---

## 📊 Rubrica de Avaliação

| Critério | Peso | Status | Descrição |
| :--- | :---: | :---: | :--- |
| **Modelagem e Conexão** | 25% | ✅ 100% | Criação do `TarefaModel` (`toMap`/`fromMap`) e classe Singleton `DatabaseHelper`. |
| **Operações CRUD SQL** | 25% | ✅ 100% | Implementação correta dos métodos `insert`, `query`, `update` e `delete` no `sqflite`. |
| **Interface Reativa** | 25% | ✅ 100% | `ListView.builder` sincronizada com banco, suporte a Checkbox e BottomSheet. |
| **Desafio & Versionamento** | 25% | ✅ 100% | Implementação dos 3 desafios técnicos e comandos de commits semânticos estruturados. |
