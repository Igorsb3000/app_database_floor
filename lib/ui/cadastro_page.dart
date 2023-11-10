import 'package:flutter/material.dart';
import 'package:flutter_database_app/helpers/livro_helper.dart';
import 'package:flutter_database_app/widgets/custom_form_field.dart';
import 'package:flutter_database_app/widgets/custom_rating_bar.dart';

import '../domain/livro.dart';

class CadastroPage extends StatelessWidget {
  const CadastroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Meus livros"),
      ),
      body: FormLivroBody(),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}

class FormLivroBody extends StatefulWidget {
  const FormLivroBody({
    super.key,
  });

  @override
  State<FormLivroBody> createState() => _FormLivroBodyState();
}

class _FormLivroBodyState extends State<FormLivroBody> {
  final _formKey = GlobalKey<FormState>();

  final tituloController = TextEditingController();
  final autorController = TextEditingController();
  final anoController = TextEditingController();
  final avaliacaoController = TextEditingController();
  double rating = 0.0;

  final livroHelper = LivroHelper();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Cadastro de Livros",
              style: Theme.of(context).textTheme.displayLarge,
            ),
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
            CustomFormField(
              controller: autorController,
              labelText: "Autor",
              validate_function: (value) {
                if (value == null || value.isEmpty) {
                  return 'Adicione um autor';
                }
                return null;
              },
            ),
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
            CustomRatingBar(
              ratingFunction: (value) {
                rating = value;
              },
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Livro l = Livro(tituloController.text, autorController.text,
                      int.parse(anoController.text), rating);
                  livroHelper.saveLivro(l);
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
          ],
        ),
      ),
    );
  }
}
