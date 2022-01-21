import 'package:ajanda_flutter/model/Diary.dart';
import 'package:ajanda_flutter/pages/get_started_page.dart';
import 'package:ajanda_flutter/pages/login_page.dart';
import 'package:ajanda_flutter/pages/main_page.dart';
import 'package:ajanda_flutter/pages/page_not_found.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAKtPSPdlWstLGmVIfF9hNGMfHgpZFaYvw",
      appId: "1:116700765557:web:9a08954af7a089cba8873c",
      messagingSenderId: "116700765557",
      projectId: "ajanda-proje",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final userDiaryDataStream = FirebaseFirestore.instance
      .collection('ajandalar')
      .snapshots()
      .map((ajandalar) {
    return ajandalar.docs.map((diary) {
      return Diary.fromDocument(diary);
    }).toList();
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider(
            create: (context) => FirebaseAuth.instance.idTokenChanges(),
            initialData: null),
        StreamProvider<List<Diary>>(
            create: (context) => userDiaryDataStream, initialData: [])
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner:
            false, // anasayfasının köşesinde çıkan debug sembolü kaldırıldı.
        title: 'Make A Plan',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.deepPurple,
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              return RouteController(settingsName: settings.name!);
            },
          );
        },
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => PageNotFound(),
        ),
      ),
    );
  }
}

class RouteController extends StatelessWidget {
  final String settingsName;
  const RouteController({Key? key, required this.settingsName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final userSignedIn = Provider.of<User?>(context) != null;

    final SignedInGotoMain = userSignedIn && settingsName == '/main';
    final notSignedInGotoMain = !userSignedIn && settingsName == '/main';

    if (settingsName == '/') {
      return GettingStartedPage();
    } else if (settingsName == '/main' || notSignedInGotoMain) {
      return LoginPage();
    } else if (settingsName == '/login' || notSignedInGotoMain) {
      return LoginPage();
    } else if (SignedInGotoMain) {
      return MainPage();
    } else {
      return PageNotFound();
    }
  }
}
