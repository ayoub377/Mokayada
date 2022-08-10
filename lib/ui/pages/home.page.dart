import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mokayada/ui/widgets/mydrawer.dart';
import 'package:mokayada/ui/widgets/searchBar.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late SearchBar searchBar;
  dynamic data;



  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        title: new Text('Aji Tebadlo'),
        actions: [searchBar.getSearchAction(context)],
    );
  }

  _MyHomePageState() {
    searchBar = SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: (String value) {
        },
        buildDefaultAppBar: buildAppBar
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: searchBar.build(context),
        drawer: new MyDrawer(),
        body: Container(

            child: Row(
              children: [
                Column(
                    children: [
                      Text("derniers produits ajoutes"),
                    ]
                ),
                Column(
                    children: [
                      ElevatedButton(onPressed: (){
                        if(auth.currentUser != null) {
                          Navigator.pushNamed(context, '/productAddForm');
                        } else {
                          Navigator.pushNamed(context, '/login');
                        }
                      }, child: Text("Ajouter un produit")),
                    ]
                ),
              ],
            ),
        )
    );
  }

}




