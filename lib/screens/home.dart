import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Initialisation d'un logger global
final Logger logger = Logger();

class Home extends StatelessWidget {
  const Home({super.key});

  // Function to fetch the last login date
  Future<String> _getLastLoginDate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String lastLoginDate = preferences.getString('lastLoginDate') ??
        'Aucune connexion'; // Default if not found
    return lastLoginDate;
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer l'ID passé en arguments
    final String userId = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Hauteur personnalisée
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(241, 217, 44, 1.0),
                  Color.fromRGBO(241, 217, 44, 1.0)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "StayFit",
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 32, 32, 32),
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 0),
                Text(
                  "Scanner votre code",
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(179, 26, 25, 25),
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          centerTitle: true,
          elevation: 6,
          actions: [
            // Bouton de déconnexion avec icône et texte
            IconButton(
              icon: const Row(
                children: [
                  Icon(Icons.exit_to_app,
                      color: Color.fromARGB(255, 32, 32, 32)),
                  SizedBox(width: 8), // Espacement entre l'icône et le texte
                  Text(
                    "Déconnecter",
                    style: TextStyle(
                      color: Color.fromARGB(255, 32, 32, 32),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear(); // Vider toutes les préférences
                logger.i("Preferences cleared. User logged out.");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Données effacées."),
                    duration: Duration(seconds: 2),
                  ),
                );
                // Optionnel : Naviguer vers l'écran de connexion
                Navigator.of(context).pushReplacementNamed('/signin');
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<String>(
        future: _getLastLoginDate(), // Retrieve last login date
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Display the last login date once it is fetched
          String lastLoginDate = snapshot.data ?? 'Aucune connexion';

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Titre principal
                  Text(
                    "Votre QR Code",
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2C),
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  // Conteneur pour le QR Code
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFFFFF), Color(0xFFEFEFEF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: PrettyQr(
                      data: userId, // Utiliser l'ID pour générer le QR Code
                      size: 350.0, // Taille agrandie du QR Code
                      roundEdges: true,
                      errorCorrectLevel: QrErrorCorrectLevel.H,
                      elementColor: const Color(0xFF1E1E2C),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Display the last login date
                  Text(
                    "Dernière connexion: $lastLoginDate",
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF1E1E2C),
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
