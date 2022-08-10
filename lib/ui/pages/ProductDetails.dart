import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';




class ProductDetails extends StatefulWidget {

  final String id_prod;
  const ProductDetails(this.id_prod);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  dynamic data;
  dynamic data2_images;
  

  @override
  Widget build(BuildContext context) {
    _Fetch();
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Details produit"),
        ),
       body: ListView(
          children: <Widget>[

            Container(
              height: 100,
              width: 300,
                child: Column(
                  children: <Widget>[
                    Text(data["name"],style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Text(data["description"], style: TextStyle(fontSize: 20),),
                    ),
                  ],
                ),
            ),
            Container(
              height: 300,
              margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: CarouselSlider.builder(
                  unlimitedMode: true,
                  slideBuilder: (index) {
                    return Container(
                      alignment: Alignment.center,
                      child: Image.network(
                        data2_images[index],
                      ),
                    );
                  },
                  slideTransform: CubeTransform(),
                  slideIndicator: CircularSlideIndicator(
                    padding: EdgeInsets.only(bottom: 32),
                  ),
                  itemCount: data2_images.length),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Align(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 240, maxWidth: 600),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child:Column(
                children: <Widget>[
                  Text("annonce par:"),
                  Text(data["profile_name"][0], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  Text(DateTime.parse(data["created_on"]).toString(), style: TextStyle(fontSize: 20),),
                ],
              ),
              )
          ],
        ),





      ),
    );
  }

  void _Fetch() {
    String url = "http://10.0.2.2:8000/api/product/${widget.id_prod}";
    http.get(Uri.parse(url)).then((response) {
      setState(() {
        data = json.decode(response.body);
        data2_images = [data["image1"], data["image2"], data["image3"]];
      });
    });
  }

}
