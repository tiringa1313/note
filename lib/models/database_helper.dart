import 'dart:io';
import 'dart:typed_data';

import 'package:note_gm/models/placa_veiculo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'equipe.dart';
import 'boletim.dart';
import 'observacoes.dart';
import 'pessoa.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Caminho do banco de dados
    String path = join(await getDatabasesPath(), 'boletim_database.db');

    // Abrindo o banco de dados com as configurações necessárias
    return await openDatabase(
      path,
      version: 3, // Atualizando a versão do banco de dados
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Método para fazer upgrades no banco de dados
    );
  }

  Future _onCreate(Database db, int version) async {
    // Criação das tabelas
    await db.execute('''
      CREATE TABLE equipe(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        viatura TEXT,
        nomenclaturaVtr TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE boletim(
        id TEXT PRIMARY KEY,
        tituloAtendimento TEXT,
        descricao TEXT,
        data TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE placas(
        placa TEXT PRIMARY KEY,
        marca TEXT,
        modelo TEXT,
        ano TEXT,
        chassi TEXT,
        fotoPath TEXT,
        fotoChassi TEXT,  
        fotoVeiculo TEXT, 
        dataCadastro TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE observacoes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tituloObservacao TEXT NOT NULL,
        descricao TEXT NOT NULL,
        dataCadastro TEXT NOT NULL,
        placa TEXT,
        FOREIGN KEY (placa) REFERENCES placas(placa) ON DELETE CASCADE
      )
    ''');

    // Agora, a tabela faces também será criada no mesmo banco
    await db.execute('''
     CREATE TABLE faces(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    imagePath TEXT
      )
    ''');

    // Criando a tabela de pessoas
    await db.execute('''
    
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      cpf TEXT,
      face_id TEXT
    )
  ''');
  }

  // Método de upgrade para gerenciar futuras alterações no banco
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Verifica e cria a tabela observacoes na versão 3
      await db.execute('''
        CREATE TABLE IF NOT EXISTS observacoes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          tituloObservacao TEXT NOT NULL,
          descricao TEXT NOT NULL,
          dataCadastro TEXT NOT NULL,
          placa TEXT,
          FOREIGN KEY (placa) REFERENCES placas(placa) ON DELETE CASCADE
        )
      ''');

      await _createFacesDatabase();
    }
  }

  Future<void> _createFacesDatabase() async {
    String path = join(await getDatabasesPath(), 'faces.db');
    final db =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE faces(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
  image_path TEXT
        )
      ''');
    });
  }

  // Método para buscar os detalhes de uma placa específica
  Future<PlacaVeiculo> getPlacaDetails(String placa) async {
    Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'placas',
      where: 'placa = ?',
      whereArgs: [placa],
    );

    print(
        'Resultado da consulta: $result'); // Adicione este print para inspecionar os dados

    if (result.isNotEmpty) {
      return PlacaVeiculo(
        placa: result[0]['placa'],
        marca: result[0]['marca'],
        modelo: result[0]['modelo'],
        ano: result[0]['ano'],
        chassi: result[0]['chassi'],
        fotoPath: result[0]['fotoPath'],
        fotoChassi: result[0]['fotoChassi'], // Retornando fotoChassi
        fotoVeiculo: result[0]['fotoVeiculo'], // Retornando fotoVeiculo
        dataCadastro: DateTime.parse(result[0]['dataCadastro']),
      );
    } else {
      throw Exception('Placa não encontrada');
    }
  }

  // Método para inserir uma nova equipe
  Future<int> insertEquipe(Equipe equipe) async {
    Database db = await database;
    return await db.insert('equipe', equipe.toMap());
  }

  // Método para recuperar a lista de equipes
  Future<List<Equipe>> getEquipes() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('equipe');
    return List.generate(maps.length, (i) {
      return Equipe.fromMap(maps[i]);
    });
  }

  // Métodos para atualizar e deletar equipes
  Future<int> updateEquipe(Equipe equipe) async {
    Database db = await database;
    return await db.update(
      'equipe',
      equipe.toMap(),
      where: 'id = ?',
      whereArgs: [equipe.id],
    );
  }

  Future<int> deleteEquipe(int id) async {
    Database db = await database;
    return await db.delete(
      'equipe',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos para Boletim
  Future<int> insertBoletim(Boletim boletim) async {
    Database db = await database;
    return await db.insert('boletim', boletim.toMap());
  }

  Future<List<Boletim>> getBoletins() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('boletim');
    return List.generate(maps.length, (i) {
      return Boletim.fromMap(maps[i]);
    });
  }

  Future<int> updateBoletim(Boletim boletim) async {
    Database db = await database;
    return await db.update(
      'boletim',
      boletim.toMap(),
      where: 'id = ?',
      whereArgs: [boletim.id],
    );
  }

  Future<int> deleteBoletim(String id) async {
    Database db = await database;
    return await db.delete(
      'boletim',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Boletim>> getUsedBoletins() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('boletim',
        where: 'used = ?',
        whereArgs: [1]); // Ajuste a lógica conforme sua necessidade
    return List.generate(maps.length, (i) {
      return Boletim.fromMap(maps[i]);
    });
  }

  // Métodos para gerenciar placas
  Future<bool> existsPlaca(String placa) async {
    Database db = await database;
    final result =
        await db.query('placas', where: 'placa = ?', whereArgs: [placa]);
    return result.isNotEmpty;
  }

  Future<void> insertPlaca(PlacaVeiculo placaVeiculo) async {
    final db = await database;
    await db.insert(
      'placas', // Nome da tabela no banco
      placaVeiculo.toMap(), // Converte o objeto para Map
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Em caso de conflito, substitui
    );
  }

  Future<List<String>> getPlacas() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('placas');
    return List.generate(maps.length, (i) {
      return maps[i]['placa'] as String;
    });
  }

  /** Inserir Observação */
  Future<int> insertObservacao(Observacao observacao) async {
    Database db = await database;
    return await db.insert(
      'observacoes',
      observacao.toMap(), // Converte o objeto para Map
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Em caso de conflito, substitui
    );
  }

  /** Buscar todas as observações */
  Future<List<Observacao>> getObservacoes() async {
    Database db = await database;
    final List<Map<String, dynamic>> result =
        await db.query('observacoes'); // Sem filtro de placa

    return List.generate(result.length, (i) {
      return Observacao.fromMap(result[i]);
    });
  }

  Future<int> deleteObservacao(int id) async {
    final db = await database;
    return await db.delete(
      'observacoes', // Nome da tabela no banco de dados
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertFace(String imagePath) async {
    final db = await database;
    await db.insert(
      'faces',
      {
        'imagePath': imagePath
      }, // Usar imagePath, de acordo com a definição do banco
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<String>> getAllFaces() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('faces');

    return List.generate(maps.length, (i) {
      // Verifica se image_path é null e, em caso afirmativo, retorna uma string vazia ou outro valor
      return maps[i]['image_path'] ??
          ''; // Retorna uma string vazia se for null
    });
  }

  Future<void> _loadFaces() async {
    final helper = DatabaseHelper();
    final imagePaths = await helper.getAllFaces();

    for (var path in imagePaths) {
      // Usar o caminho da imagem para carregá-la no seu app
      final imageFile = File(path);
      // Exibir a imagem, por exemplo, usando o widget Image.file()
    }
  }

// Função para salvar dados no banco de dados
  Future<void> saveUserData(String faceId, String name, String cpf) async {
    final db = await database;

    // Insere os dados do usuário
    await db.insert(
      'users',
      {
        'name': name,
        'cpf': cpf,
        'face_id': faceId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Substitui se já existir
    );
  }

  // Função para buscar um usuário pelo Face ID
  Future<Map<String, String>?> getUserByFaceId(String faceId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'face_id = ?',
      whereArgs: [faceId],
    );

    if (maps.isNotEmpty) {
      final user = maps.first;
      return {
        'name': user['name'],
        'cpf': user['cpf'],
        'face_id': user['face_id'],
      };
    }
    return null;
  }
}
