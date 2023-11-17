import 'package:flutter/material.dart';
import 'package:flutter_database_app/helpers/app_database.dart';
import 'package:flutter_database_app/ui/edicao_page.dart';

import '../domain/livro.dart';
import '../helpers/database_manager.dart';
import '../helpers/livro_dao.dart';


class ListPage extends StatelessWidget {
  final DatabaseManager databaseManager;
  const ListPage({super.key, required this.databaseManager,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Meus livros"),
      ),
      body: ListBody(databaseManager: databaseManager,),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}


class ListBody extends StatefulWidget {
  final DatabaseManager databaseManager;
  const ListBody({super.key, required this.databaseManager});

  @override
  State<ListBody> createState() => _ListBodyState();
}

class _ListBodyState extends State<ListBody> {
  Future<List<Livro>> livros = Future.value([]);


  @override
  void initState() {
    super.initState();
    _loadLivros();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadLivros() async {
    final loadedLivros = await widget.databaseManager.database.livroDao.findAllLivros();
    setState(() {
      livros = Future.value(loadedLivros);
    });
  }

  void onUpdateList() {
    _loadLivros();
  }


  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder<List<Livro>>(
      future: livros,
      builder: (context, snapshot) {
        return snapshot.hasData  ? ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, i) {
                  return ListItem(livro: snapshot.data![i], databaseManager: widget.databaseManager, onUpdateList: onUpdateList);
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}

class ListItem extends StatelessWidget {
  final DatabaseManager databaseManager;
  final Livro livro;
  final Function onUpdateList;
  const ListItem({super.key, required this.livro, required this.databaseManager, required this.onUpdateList,});

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Editar livro!"),
          ));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EdicaoPage(
                livro.id!,
                livro.titulo,
                livro.autor,
                livro.anoPublicacao,
                livro.avaliacao,
                databaseManager,
              ),
            ),
          ).then((result) {
            // Esta função será chamada após o Navigator.pop na tela de destino
            if (result != null && result is String && result == 'listaAtualizada') {
              // Atualize sua lista aqui chamando a função de callback
              onUpdateList();
            }
          });
        },
        onLongPress: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${livro.titulo} foi excluído!"),
          ));
          print("ID do livro = ${livro.id}");
          databaseManager.database.livroDao.deleteLivro(livro);
          //livroHelper.deleteLivro(livro.id);
          onUpdateList();
        },
        child: ListTile(
          title: Text(livro.titulo),
        ),
      );
  }
}

