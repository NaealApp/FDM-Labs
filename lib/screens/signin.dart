import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const LOGIN = "https://stayfitgymclub.com/api/xapilist.php";

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contratController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  late ScaffoldMessengerState scaffoldMessenger;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? contrat = prefs.getString("contrat");
    String? password = prefs.getString("password");
    String? code = prefs.getString("code");

    if (contrat != null && password != null && mounted) {
      Navigator.pushReplacementNamed(context, "/home", arguments: code);
    }
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  "assets/background.jpg",
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/logo.png",
                    height: 150,
                    width: 250,
                    alignment: Alignment.center,
                  ),
                  const SizedBox(height: 13),
                  Text(
                    "",
                    style: GoogleFonts.fjallaOne(
                      textStyle: const TextStyle(
                        fontSize: 29,
                        color: Color.fromARGB(255, 252, 253, 255),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "Connexion",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fjallaOne(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 238, 239, 243),
                        letterSpacing: 1,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 45),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _contratController,
                            decoration: InputDecoration(
                              hintText: "N° Contrat",
                              hintStyle: const TextStyle(
                                color: Color.fromARGB(179, 0, 12, 26),
                                fontSize: 18,
                              ),
                              fillColor:
                                  const Color.fromARGB(255, 243, 246, 247),
                              filled: true,
                              // Contour arrondi avec couleur de bordure
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    30), // Bordure arrondie
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(
                                      255, 0, 12, 26), // Bordure inactive
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    30), // Bordure arrondie
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(
                                      255, 41, 40, 40), // Bordure active
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              hintText: "Mot de passe",
                              hintStyle: const TextStyle(
                                color: Color.fromARGB(179, 0, 12, 26),
                                fontSize: 18,
                              ),
                              fillColor: const Color.fromRGBO(250, 250, 249, 1),
                              filled: true,
                              // Contour arrondi avec couleur de bordure
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    30), // Bordure arrondie
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(
                                      255, 0, 12, 26), // Bordure inactive
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    30), // Bordure arrondie
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(
                                      255, 41, 40, 40), // Bordure active
                                  width: 2.0,
                                ),
                              ),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 30),
                          GestureDetector(
                            onTap: () {
                              if (isLoading) return;
                              if (_contratController.text.isEmpty ||
                                  _passwordController.text.isEmpty) {
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Veuillez remplir tous les champs"),
                                  ),
                                );
                                return;
                              }
                              login(_contratController.text,
                                  _passwordController.text);
                              setState(() => isLoading = true);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromRGBO(241, 217, 44, 1.0),
                                    Color.fromRGBO(241, 217, 44, 1.0),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      "Se connecter",
                                      style: GoogleFonts.fjallaOne(
                                        textStyle: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 41, 40, 40),
                                          fontSize: 16,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login(String contrat, String password) async {
    final Map<String, String> data = {'contrat': contrat, 'password': password};

    try {
      final response = await http.post(
        Uri.parse(LOGIN),
        headers: {
          "Accept": "*/*",
          "Content-Type": 'application/json',
          "Authorization":
              "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMjMsInVzZXJuYW1lIjoiam9obl9kb2UiLCJpYXQiOjE3MzUzOTgzMjF9.SpzLXFXhvlGmS5rabSwxRdggPdKbmcNO3CxSUhcF6Cs",
        },
        body: jsonEncode(data),
      );

      if (!mounted) return;

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (!responseData['error']) {
          final user = responseData['data'];

          await savePref(password, user['contrat'], user['code']);

          if (mounted) {
            Navigator.pushReplacementNamed(
              context,
              "/home",
              arguments: user['code'],
            );
          }
        } else {
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text(responseData['message'])),
          );
        }
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
                "Erreur ${response.statusCode} : ${response.reasonPhrase}"),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("Erreur réseau : $e")),
      );
    }
  }

  Future<void> savePref(String? password, String? contrat, String? code) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    // Imprimer les valeurs pour le débogage
    print(password);
    print(contrat);
    print(code);

    // Sauvegarder les données si elles ne sont pas nulles
    if (password != null) await preferences.setString("password", password);
    if (contrat != null) await preferences.setString("contrat", contrat);
    if (code != null) await preferences.setString("code", code);

    // Vérifier si la date et l'heure de première connexion existent déjà
    if (!preferences.containsKey("firstConnectionDateTime")) {
      // Si non, sauvegarder la date et l'heure actuelles
      final String currentDateTime = DateTime.now().toIso8601String();
      await preferences.setString("firstConnectionDateTime", currentDateTime);
      print(
          "Date et heure de première connexion enregistrées : $currentDateTime");
    } else {
      print("Date et heure de première connexion déjà enregistrées.");
    }
  }
}
