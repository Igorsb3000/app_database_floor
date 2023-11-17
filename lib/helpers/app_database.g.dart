// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  LivroDao? _livroDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Livro` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `titulo` TEXT NOT NULL, `autor` TEXT NOT NULL, `anoPublicacao` INTEGER NOT NULL, `avaliacao` REAL NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  LivroDao get livroDao {
    return _livroDaoInstance ??= _$LivroDao(database, changeListener);
  }
}

class _$LivroDao extends LivroDao {
  _$LivroDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _livroInsertionAdapter = InsertionAdapter(
            database,
            'Livro',
            (Livro item) => <String, Object?>{
                  'id': item.id,
                  'titulo': item.titulo,
                  'autor': item.autor,
                  'anoPublicacao': item.anoPublicacao,
                  'avaliacao': item.avaliacao
                }),
        _livroUpdateAdapter = UpdateAdapter(
            database,
            'Livro',
            ['id'],
            (Livro item) => <String, Object?>{
                  'id': item.id,
                  'titulo': item.titulo,
                  'autor': item.autor,
                  'anoPublicacao': item.anoPublicacao,
                  'avaliacao': item.avaliacao
                }),
        _livroDeletionAdapter = DeletionAdapter(
            database,
            'Livro',
            ['id'],
            (Livro item) => <String, Object?>{
                  'id': item.id,
                  'titulo': item.titulo,
                  'autor': item.autor,
                  'anoPublicacao': item.anoPublicacao,
                  'avaliacao': item.avaliacao
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Livro> _livroInsertionAdapter;

  final UpdateAdapter<Livro> _livroUpdateAdapter;

  final DeletionAdapter<Livro> _livroDeletionAdapter;

  @override
  Future<Livro?> findLivroById(int id) async {
    return _queryAdapter.query('SELECT * FROM livro WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Livro(
            id: row['id'] as int?,
            titulo: row['titulo'] as String,
            autor: row['autor'] as String,
            anoPublicacao: row['anoPublicacao'] as int,
            avaliacao: row['avaliacao'] as double),
        arguments: [id]);
  }

  @override
  Future<List<Livro>> findAllLivros() async {
    return _queryAdapter.queryList('SELECT * FROM livro',
        mapper: (Map<String, Object?> row) => Livro(
            id: row['id'] as int?,
            titulo: row['titulo'] as String,
            autor: row['autor'] as String,
            anoPublicacao: row['anoPublicacao'] as int,
            avaliacao: row['avaliacao'] as double));
  }

  @override
  Future<void> insertLivro(Livro livro) async {
    await _livroInsertionAdapter.insert(livro, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateLivro(Livro livro) async {
    await _livroUpdateAdapter.update(livro, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteLivro(Livro livro) async {
    await _livroDeletionAdapter.delete(livro);
  }
}
