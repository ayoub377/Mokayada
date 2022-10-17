import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../service/FirebaseService.dart';
import '../../widgets/BottomNavBar.dart';
import 'CategoryDetails.dart';


//TODO: make the categories list and icons on the side

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
          body: Container(
            padding: EdgeInsets.only(top: 50),
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                var doc = snapshot.data?.docs[index];
                return Card(
                  child: ListTile(
                    leading: doc?.get("image") != null
                        ? Image.network(doc?.get("image"))
                        : Container(),
                    title: Text(doc?.get('name')),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryDetails(
                            categoryname: doc?.get('name'),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
               itemCount: snapshot.data!.docs.length,
            ),
          ),
          bottomNavigationBar: BottomNavBar(),
        );
      },
    );
  }

}
