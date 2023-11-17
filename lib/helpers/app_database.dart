import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:flutter_database_app/helpers/livro_dao.dart';
import '../domain/livro.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [Livro])
abstract class AppDatabase extends FloorDatabase {
  LivroDao get livroDao;
}