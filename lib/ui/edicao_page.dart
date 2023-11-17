import 'package:flutter/material.dart';
import 'package:flutter_database_app/helpers/app_database.dart';
import 'package:flutter_database_app/helpers/livro_dao.dart';
import 'package:flutter_database_app/widgets/custom_form_field.dart';
import 'package:flutter_database_app/widgets/custom_rating_bar.dart';

import '../domain/livro.dart';
import '../helpers/database_manager.dart';

class EdicaoPage extends StatelessWidget {
  late int id;
  late String titulo;
  late String autor;
  late int ano;
  late double avaliacao;
  final DatabaseManager databaseManager;

  EdicaoPage(this.id, this.titulo, this.autor, this.ano, this.avaliacao, this.databaseManager,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Meus livros"),
      ),
      body: FormEdicaoLivroBody(
          id, titulo, autor, ano, avaliacao, databaseManager),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}

class FormEdicaoLivroBody extends StatefulWidget {
  late int id;
  late String titulo;
  late String autor;
  late int ano;
  late double avaliacao;
  final DatabaseManager databaseManager;

  FormEdicaoLivroBody(
      this.id, this.titulo, this.autor, this.ano, this.avaliacao, this.databaseManager,
      {super.key});

  @override
  State<FormEdicaoLivroBody> createState() => _FormEdicaoLivroBodyState();
}

class _FormEdicaoLivroBodyState extends State<FormEdicaoLivroBody> {
  final _formKey = GlobalKey<FormState>();

  late final int id;
  TextEditingController tituloController = TextEditingController();
  TextEditingController autorController = TextEditingController();
  TextEditingController anoController = TextEditingController();
  double rating = 0.0;


  @override
  void initState() {
    super.initState();
    id = widget.id;
    tituloController.text = widget.titulo;
    autorController.text = widget.autor;
    anoController.text = widget.ano.toString();
    rating = widget.avaliacao;
  }

  @override
  void dispose() {
    tituloController.dispose();
    autorController.dispose();
    anoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      "Editar Livro",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                    ),
                    const SizedBox(height: 30),
                    CustomFormField(
                      controller: tituloController,
                      labelText: "Título",
                      validate_function: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Adicione um título';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomFormField(
                      controller: autorController,
                      labelText: "Autor(a)",
                      validate_function: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Adicione um autor';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomFormField(
                      controller: anoController,
                      labelText: "Ano",
                      keyboard_type: TextInputType.number,
                      validate_function: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Adicione um ano';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomRatingBar(
                      initialValue: rating,
                      ratingFunction: (value) {
                        rating = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Livro l = Livro(
                              id: id,
                              titulo: tituloController.text,
                              autor: autorController.text,
                              anoPublicacao: int.parse(anoController.text),
                              avaliacao: rating);
                          print("Livro atualizado = " + l.toString());
                          widget.databaseManager.database.livroDao.updateLivro(l);
                          //livroHelper.updateLivro(l);
                          Navigator.pop(context, 'listaAtualizada');
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text(
                        "Salvar",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
