import 'package:flutter/material.dart';

import '../domain/livro.dart';
import '../helpers/app_database.dart';
import '../helpers/database_manager.dart';

class CatalogoPage extends StatelessWidget {
  final DatabaseManager databaseManager;
  const CatalogoPage({super.key, required this.databaseManager});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Catálogo dos livros"),
      ),
      body: CatalogoBody(databaseManager: databaseManager,),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
class CatalogoBody extends StatefulWidget {
  final DatabaseManager databaseManager;
  CatalogoBody({super.key, required this.databaseManager});

  @override
  State<CatalogoBody> createState() => _CatalogoBodyState();
}

class _CatalogoBodyState extends State<CatalogoBody> {
  Future<List<Livro>> livros = Future.value([]);
  late List<Livro> listaDeLivros;
  int indiceAtual = 0;

  @override
  void initState() {
    super.initState();
    _loadLivros();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isButtonAnteriorEnabled(){
    if(indiceAtual == 0){
      return false;
    } else {
      return true;
    }
  }

  bool isButtonProximoEnabled(){
    if(indiceAtual == listaDeLivros.length - 1){
      return false;
    } else {
      return true;
    }

  }

  Future<void> _loadLivros() async {
    final loadedLivros = await widget.databaseManager.database.livroDao.findAllLivros();
    setState(() {
      livros = Future.value(loadedLivros);
    });
  }

  obterAnterior(){
    if (this.indiceAtual > 0) {
      setState(() {
        indiceAtual--;
      });
    }
  }

  obterProximo(){
    if (this.indiceAtual < this.listaDeLivros.length - 1) {
      setState(() {
        indiceAtual++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Livro livro;

      return FutureBuilder(
          future: livros,
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const CircularProgressIndicator();
            } else if (snapshot.hasError){
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty){
              return const Text('Sem dados');
            } else {
              listaDeLivros = snapshot.data as List<Livro>;


              return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    livro = listaDeLivros[indiceAtual];

                    return Column(
                      children: [
                        const SizedBox(height: 80),
                        const Text(
                            'Título:',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 28,
                              letterSpacing: 1.2,
                            ),
                        ),
                        Text(
                            livro.titulo,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Theme.of(context).colorScheme.surfaceTint,
                              letterSpacing: 1.2,
                            ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                            'Autor(a):',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 28,
                              letterSpacing: 1.2,
                            ),
                        ),
                        Text(
                            livro.autor,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Theme.of(context).colorScheme.surfaceTint,
                              letterSpacing: 1.2,
                            ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                            'Ano de Publicação:',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 28,
                              letterSpacing: 1.2,
                            ),
                        ),
                        Text(
                            livro.anoPublicacao.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Theme.of(context).colorScheme.surfaceTint,
                              letterSpacing: 1.2,
                            ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                            'Avaliação:',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 28,
                              letterSpacing: 1.2,
                            ),
                        ),
                        Text(
                            livro.avaliacao.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Theme.of(context).colorScheme.surfaceTint,
                              letterSpacing: 1.2,
                            ),
                        ),
                        const SizedBox(height: 80),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                    onPressed: isButtonAnteriorEnabled() ? obterAnterior : null,
                                    style: TextButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                                        minimumSize: const Size(150, 50)),
                                    child: const Text("Anterior"),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                    onPressed: isButtonProximoEnabled() ? obterProximo : null,
                                    style: TextButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                                        minimumSize: const Size(150, 50)),
                                    child: const Text("Próximo"),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),

                      ],
                    );
                  }
              );
            }
          });
  }
}