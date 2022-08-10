import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mokayada/service/FirebaseService.dart';
import 'package:mokayada/ui/pages/Account/Done.dart';
import 'package:mokayada/ui/pages/Account/Login.dart';
import 'package:mokayada/ui/pages/Account/Register.dart';
import 'package:mokayada/ui/pages/ProductAddForm.dart';
import 'package:mokayada/ui/pages/home.page.dart';
import 'package:mokayada/ui/pages/topproduits.dart';
import 'package:mokayada/ui/pages/categories.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mokayada/ui/pages/Account/profile.dart';


GetIt locator = GetIt.instance;

void setupSingletons() async {
  locator.registerLazySingleton<FirebaseService>(() => FirebaseService());
}


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupSingletons();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const MyHomePage(),
        '/topproduits': (context) => const TopProduits(),
        '/categories':(context) => const Categories(),
        '/register' :(context) => RegisterPage(),
        '/login' : (context) => LoginPage(),
        '/profile':(context) => const Profile(),
        '/done':(context) => Done(),
        '/productAddForm':(context) => const ProductAddForm(),
      },
      title: 'Aji tebadlo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

    );

  }

}

