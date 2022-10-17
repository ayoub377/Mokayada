import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:mokayada/widgets/searchBar.dart';
import 'package:http/http.dart' as http;
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';
import 'dart:math' as math;
import '../../service/FirebaseService.dart';
import '../../widgets/BottomNavBar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();
  late SearchBar searchBar;
  dynamic data;
  bool ActiveConnection = false;
  String T = '';
  Map<String, List<Map<String, dynamic>>?> list_prods = {};

  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
      });
    }
  }

  @override
  initState() {
    super.initState();
    CheckUserConnection();
    get_prods();
  }


  Future<void> Get_categories() async {
    await _firebaseService.categories.get().then((QuerySnapshot querySnapshot) {
      data = querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> get_prods() async
  {

    //TODO: get all products from firebase with fast time
    await Get_categories();
    for (int i = 0; i < data.length; i++) {
      var result = await _firebaseService.Get_last_five_prods(data[i]['name']);
      if(result?.docs.length!=0) {
        setState((){
          list_prods.addAll(
              {data[i]['name']: result?.docs.map((doc) => doc.data()).toList()});
        });
      }
    }
  }

  String FetchIcon(String category_name)
  {
    for(int i=0;i<data.length;i++)
      {
        if(data[i]['name'] == category_name)
          {
            return data[i]['image'];
          }
      }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    if (ActiveConnection == false) {

      return Scaffold(
          body: Center(
            child: Dialog(
              child: Container(
                height: 100,
                child: Column(
                  children: [
                    Text("Pas de connexion internet"),
                    ElevatedButton(
                        onPressed: () {
                          CheckUserConnection();
                        },
                        child: Text("Réessayer"))
                  ],
                ),
              ),
            ),
          )
      );
    }
    else {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
                ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: list_prods.length,
                    itemBuilder: (context, int id) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: ListTile(
                                  leading: Image.network(FetchIcon(list_prods.keys.elementAt(id))),
                                  title: Text(list_prods.keys.elementAt(id)),
                                ),
                              ),
                            ),
                            CarouselSlider(
                              options: CarouselOptions(
                                viewportFraction: 1,
                              ),
                              items: list_prods.values.elementAt(id)?.map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/productDetails',
                                            arguments: i);
                                      },
                                      child: Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          // margin: const EdgeInsets.symmetric(
                                          //     horizontal: 5.0),
                                          decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  211, 211, 211, 1.0)
                                          ),
                                          child: Column(
                                            children: [
                                              Text(i['name'],
                                                style: const TextStyle(
                                                    fontSize: 22,
                                                    fontStyle: FontStyle
                                                        .italic),),
                                              const Padding(
                                                padding: EdgeInsets.all(
                                                    8.0),
                                              ),
                                              (i['images'].length == 0)
                                                  ? Expanded(
                                                  child: Container(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width,
                                                      child: Image.asset(
                                                        'assets/images/empty.jpg',
                                                        fit: BoxFit.fill,)))
                                                  : Expanded(
                                                child: Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width,
                                                  child: Image.network(
                                                    i['images'][0],
                                                    fit: BoxFit.fill,
                                                    frameBuilder: (context,
                                                        child, frame,
                                                        isSynchronouslyLoaded) {
                                                      return child;
                                                    },
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      else {
                                                        return const Center(
                                                          child: CircularProgressIndicator(),);
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ],);
                      //end If

                    }),]
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if(auth.currentUser != null)
              {
                Navigator.pushNamed(context, '/productAddForm');
              }
            else
              {

                Navigator.pushNamed(context, '/login');
              }
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar:BottomNavBar(),
      );
    }
  }
}





