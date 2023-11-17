import 'package:flutter/material.dart';
import 'package:flutter_database_app/ui/home_page.dart';

import 'helpers/database_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final DatabaseManager databaseManager = DatabaseManager();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppWrapper(databaseManager: databaseManager,);
  }
}

class AppWrapper extends StatefulWidget {
  final DatabaseManager databaseManager;

  const AppWrapper({Key? key, required this.databaseManager}) : super(key: key);

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    widget.databaseManager.closeDatabase();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // Chama o dispose() quando o aplicativo é pausado ou fechado
      dispose();
    }
    if (state == AppLifecycleState.resumed) {
      if(mounted){
        // Quando o aplicativo é retomado, reabra a conexão com o banco de dados
        widget.databaseManager.openDatabase();
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w300,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          labelLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      home: FutureBuilder(
        future: widget.databaseManager.openDatabase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return HomePage(databaseManager: widget.databaseManager);
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
