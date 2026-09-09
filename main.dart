import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    String path = join(docsDir.path, 'congregacao.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Tabela Território
    await db.execute('''
      CREATE TABLE territorios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        descricao TEXT,
        numero INTEGER,
        status TEXT,  -- 'disponivel', 'ocupado', 'atrasado'
        publicador_responsavel TEXT,
        data_atribuicao TEXT,
        data_devolucao TEXT
      )
    ''');

    // Tabela Serviço de Campo
    await db.execute('''
      CREATE TABLE servico_campo(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        publicador TEXT NOT NULL,
        data_saida TEXT,
        data_retorno TEXT,
        territorio_id INTEGER,
        observacao TEXT,
        FOREIGN KEY (territorio_id) REFERENCES territorios(id) ON DELETE SET NULL
      )
    ''');

    // Tabela Eventos
    await db.execute('''
      CREATE TABLE eventos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descricao TEXT,
        data_inicio TEXT,
        data_fim TEXT,
        tipo TEXT  -- 'reuniao', 'assembleia', 'visita', 'outro'
      )
    ''');

    // Tabela Dirigente (escala de oradores)
    await db.execute('''
      CREATE TABLE dirigente(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data TEXT NOT NULL,
        orador TEXT NOT NULL,
        tipo_reuniao TEXT,  -- 'meio de semana', 'fim de semana'
        tema TEXT,
        designacao TEXT
      )
    ''');

    // Tabela S-13 (relatório mensal)
    await db.execute('''
      CREATE TABLE s13(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        publicador TEXT NOT NULL,
        mes INTEGER,
        ano INTEGER,
        horas INTEGER DEFAULT 0,
        revisitas INTEGER DEFAULT 0,
        estudos INTEGER DEFAULT 0,
        videos_mostrados INTEGER DEFAULT 0
      )
    ''');

    // Tabela Admin (configurações, backup)
    await db.execute('''
      CREATE TABLE config(
        chave TEXT PRIMARY KEY,
        valor TEXT
      )
    ''');
  }

  // Métodos genéricos CRUD
  Future<int> insert(String table, Map<String, dynamic> data) async {
    Database db = await database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    Database db = await database;
    return await db.query(table);
  }

  Future<int> update(String table, Map<String, dynamic> data, int id) async {
    Database db = await database;
    return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(String table, int id) async {
    Database db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearTable(String table) async {
    Database db = await database;
    await db.delete(table);
  }

  // Método para backup/restore (exportar JSON)
  Future<Map<String, dynamic>> exportAll() async {
    Map<String, dynamic> data = {};
    List<String> tables = ['territorios', 'servico_campo', 'eventos', 'dirigente', 's13', 'config'];
    for (String table in tables) {
      data[table] = await queryAll(table);
    }
    return data;
  }

  Future<void> importAll(Map<String, dynamic> data) async {
    Database db = await database;
    await db.transaction((txn) async {
      for (String table in data.keys) {
        await txn.delete(table);
        for (var row in data[table]) {
          await txn.insert(table, row);
        }
      }
    });
  }
}
