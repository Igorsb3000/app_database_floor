import 'package:flutter/material.dart';
import 'package:flutter_database_app/helpers/app_database.dart';
import 'package:flutter_database_app/widgets/custom_form_field.dart';
import 'package:flutter_database_app/widgets/custom_rating_bar.dart';

import '../domain/livro.dart';
import '../helpers/database_manager.dart';

class CadastroPage extends StatelessWidget {
  final DatabaseManager databaseManager;
  const CadastroPage({super.key, required this.databaseManager});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Meus livros"),
      ),
      body: FormLivroBody(databaseManager: databaseManager,),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}

class FormLivroBody extends StatefulWidget {
  final DatabaseManager databaseManager;
  const FormLivroBody({super.key, required this.databaseManager});

  @override
  State<FormLivroBody> createState() => _FormLivroBodyState();
}

class _FormLivroBodyState extends State<FormLivroBody> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController tituloController = TextEditingController();
  TextEditingController autorController = TextEditingController();
  TextEditingController anoController = TextEditingController();
  TextEditingController valiacaoController = TextEditingController();
  double rating = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    tituloController.dispose();
    autorController.dispose();
    anoController.dispose();
    valiacaoController.dispose();
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
                      "Cadastro de Livros",
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
                          Livro l = Livro (
                            id: null,
                            titulo: tituloController.text,
                            autor: autorController.text,
                            anoPublicacao: int.parse(anoController.text),
                            avaliacao: rating,
                          );
                          //livroHelper.saveLivro(l);
                          widget.databaseManager.database.livroDao.insertLivro(l);
                          Navigator.pop(context);
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text(
                        "Cadastrar",
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
