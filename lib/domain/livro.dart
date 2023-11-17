import 'package:floor/floor.dart';

@entity
class Livro{
  @PrimaryKey(autoGenerate: true)
  final int? id;

  String titulo;

  String autor;

  int anoPublicacao;

  double avaliacao;

  Livro({required this.id, required this.titulo, required this.autor, required this.anoPublicacao, required this.avaliacao});


  @override
  String toString() {
    return 'Livro{titulo: $titulo, autor: $autor, anoPublicacao: $anoPublicacao, avaliacao: $avaliacao}';
  }
}