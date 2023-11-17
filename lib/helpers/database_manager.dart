import 'app_database.dart';

class DatabaseManager {
  late AppDatabase _database;

  AppDatabase get database => _database;

  Future<void> openDatabase() async {
    print('CONECTANDO COM O BD...');
    _database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }

  Future<void> closeDatabase() async {
    print('FECHANDO CONEXÃO COM O BD...');
    await _database.close();
  }
}