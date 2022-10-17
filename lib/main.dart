import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mokayada/service/FirebaseService.dart';
import 'package:mokayada/features/listing/CategoryDetails.dart';
import 'package:mokayada/features/listing/ProductAddForm.dart';
import 'package:mokayada/features/listing/ProductDetails.dart';
import 'package:mokayada/features/listing/home.page.dart';
import 'package:mokayada/features/listing/categories.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/Account/Done.dart';
import 'features/Account/Login.dart';
import 'features/Account/Register.dart';
import 'features/Account/profile.dart';


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
        '/categories':(context) => const Categories(),
        '/register' :(context) => RegisterPage(),
        '/login' : (context) => LoginPage(),
        '/profile':(context) => const Profile(),
        '/done':(context) => Done(),
        '/productAddForm':(context) => const ProductAddForm(),
        '/productDetails':(context) => ProductDetails(),
        '/category_details':(context) => const CategoryDetails(categoryname: null,),
      },
      title: 'Aji tebadlo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: 'sans-serif'
      ),

    );

  }

}

