import 'package:flutter/material.dart';
import 'package:stayfitconnected/screens/home.dart';
import 'package:stayfitconnected/screens/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int? _loginStatus; // Nullable pour gérer l'état de chargement
  DateTime? _lastLoginDate;

  @override
  void initState() {
    super.initState();
    _loginStatus = null; // Assurez que l'état initial est null
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    if (_loginStatus == null) {
      // Affiche un écran de chargement pendant que _loginStatus est null
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return MaterialApp(
      home: (_loginStatus == 1) ? const Home() : const SignIn(),
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signin': (BuildContext context) => const SignIn(),
        '/home': (BuildContext context) => const Home(),
      },
    );
  }

  Future<void> getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    // Récupérer l'état de connexion
    _loginStatus = preferences.getInt("value") ?? 0;
    print("État initial de connexion : $_loginStatus");

    // Récupérer la dernière date de connexion
    String? lastLoginDateString = preferences.getString("lastLoginDate");

    if (lastLoginDateString != null) {
      try {
        _lastLoginDate = DateTime.parse(lastLoginDateString);
        print("Dernière date de connexion : $_lastLoginDate");
      } catch (e) {
        print("Erreur de parsing de la date : $e");
        _lastLoginDate = null;
      }
    }
    print("État initial deeeeeion : $_lastLoginDate");
    // Vérifier si la session est expirée
    if (_lastLoginDate != null) {
      DateTime currentDate = DateTime.now();
      Duration difference = currentDate.difference(_lastLoginDate!);

      print(
          "Durée depuis la dernière connexion : ${difference.inSeconds} secondes");

      if (difference.inSeconds > 10) {
        // Adapter la durée ici si nécessaire
        print("Session expirée. Déconnexion forcée.");
        await preferences.setInt("value", 0);
        setState(() {
          _loginStatus = 0;
        });
        return;
      } else {
        print("Session toujours valide.");
      }
    }

    // Mettre à jour la date si l'utilisateur est connecté
    if (_loginStatus == 1) {
      String now = DateTime.now().toIso8601String();
      await preferences.setString("lastLoginDate", now);
      print("Mise à jour de la date de connexion : $now");
    }

    setState(() {});
  }
}
