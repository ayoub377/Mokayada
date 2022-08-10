import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../service/FirebaseService.dart';


class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  final FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: _firebaseService.categories.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
              title:Text("Categories")),
          body: Container(
              margin: EdgeInsets.fromLTRB(10, 30, 30, 0),
              child: SizedBox(
                height: 300,
                child: ListView.builder(
                    itemCount:snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var doc = snapshot.data?.docs[index];
                      return Card(
                          child:  ListTile(
                              leading: Image.network(doc!['image']),
                              title: Text(doc['name']),
                              onTap: () {

                              },
                            ),
                        );
                    }

                ),
              )
          ),

        );

      },
    );
  }

}
