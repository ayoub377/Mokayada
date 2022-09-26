import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../service/FirebaseService.dart';
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
          appBar: AppBar(
              title:Text("Categories")),
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
          // body: SingleChildScrollView(
          //   child: Container(
          //     height: MediaQuery.of(context).size.height,
          //       margin: EdgeInsets.fromLTRB(60, 30, 30, 0),
          //         child: ListView.builder(
          //             itemCount:snapshot.data?.docs.length,
          //             itemBuilder: (BuildContext context, int index)
          //             {
          //               var doc = snapshot.data?.docs[index];
          //               return Container(
          //                 margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
          //                 child: InkWell(
          //                   onTap: () {
          //                     Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryDetails(categoryname: doc!.get('name'))));
          //                   },
          //                   child: Stack(
          //                     children: [
          //                         Container(
          //                           width: MediaQuery.of(context).size.width,
          //                           child: Card(
          //                                 child: Container(
          //                                   width: 200,
          //                                   height: 200,
          //                                   decoration: const BoxDecoration(
          //                                     borderRadius: BorderRadius.all(Radius.circular(20)),
          //                                       gradient: LinearGradient(
          //                                           colors: <Color>[
          //                                             Color(0xFF77A1D3),
          //                                             Color(0xFF79CBCA),
          //                                             Color(0xFFE684AE),
          //                                           ]
          //                                       )
          //
          //                                   ),
          //                                 ),
          //                             ),
          //                       ),
          //                       Padding(
          //                         padding: const EdgeInsets.fromLTRB(80, 100, 20, 20),
          //                           child: Text(doc?.get('name'),
          //                             style: TextStyle(
          //                               fontSize: 20,
          //                               fontWeight: FontWeight.bold,
          //                               color: Colors.white,
          //                             ),
          //                           ),
          //                         ),
          //                     ],
          //                   ),
          //                 ),
          //               );
          //
          //             }
          //         ),
          //       )
          //   ),
        );
      },
    );
  }

}
