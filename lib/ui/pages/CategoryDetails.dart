import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mokayada/ui/pages/ProductDetails.dart';

import '../../service/FirebaseService.dart';

class CategoryDetails extends StatefulWidget {


  final String category;
  CategoryDetails(this.category);
  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {

  dynamic data;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.category),
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(10, 30, 30, 0),
          child: ListView.separated(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(data[index]["name"]),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return ProductDetails(data[index]["id"].toString());
                  }));
                },
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                thickness: 5,
                endIndent: 50,
              );
            },
          ),
        ),
      ),
    );
  }


}
