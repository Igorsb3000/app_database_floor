import 'package:floor/floor.dart';
import 'package:flutter_database_app/domain/livro.dart';

@dao
abstract class LivroDao {
  @Query('SELECT * FROM livro WHERE id = :id')
  Future<Livro?> findLivroById(int id);

  @Query('SELECT * FROM livro')
  Future<List<Livro>> findAllLivros();

  @insert
  Future<void> insertLivro(Livro livro);

  @update
  Future<void> updateLivro(Livro livro);

  @delete
  Future<void> deleteLivro(Livro livro);

}
