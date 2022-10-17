import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_whatsapp/open_whatsapp.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../widgets/BottomNavBar.dart';
import '../../widgets/dialog_image.dart';


class ProductDetails extends StatefulWidget {

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  var current = 0;
  CarouselController controller = CarouselController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = CarouselController();
  }
  void animateToPage(int index)=>controller.animateToPage(index);

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute
        .of(context)!
        .settings
        .arguments as Map<String, dynamic>;
    return Container(
        child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                        [
                             Text(data['name'], style: TextStyle(fontStyle: FontStyle.normal, fontSize: 22),),
                        ]
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: CarouselSlider(
                        carouselController: controller,
                        options: CarouselOptions(
                          initialPage: 0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              current = index;
                            });
                          },
                          height: MediaQuery
                              .of(context)
                              .size
                              .height / 4,
                          enableInfiniteScroll: false,),
                        items: (data['images'].length > 0) ? data['images'].map<
                            Widget>((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                      color: Colors.amber
                                  ),
                                  child: InkWell(
                                      onTap: (){
                                        showDialog(context: context, builder:(_)=>ImageDialog(i));
                                      },
                                      child: Image.network(i,fit: BoxFit.fill,))
                              );
                            },
                          );
                        }).toList() : [
                          Image.asset(
                            'assets/images/empty.jpg', fit: BoxFit.cover,),
                          Image.asset('assets/images/empty.jpg'),
                          Image.asset('assets/images/empty.jpg')
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AnimatedSmoothIndicator(
                          activeIndex: current, count: data['images'].length,onDotClicked: animateToPage,),
                    ),
                    (data['price']!='')? Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                        child: Text(data['price'].toString() + " DH", style: TextStyle(
                            fontStyle: FontStyle.normal, fontSize: 22),),
                      ):Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                      child: Text("Echange", style: TextStyle(
                          fontStyle: FontStyle.normal, fontSize: 22),),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * .2,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Card(
                          elevation: 5,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text(data['description'], style: TextStyle(
                                fontStyle: FontStyle.normal, fontSize: 18),),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(data['date'], style: TextStyle(
                              fontStyle: FontStyle.normal, fontSize: 18),),
                          Text(data['user'], style: TextStyle(
                              fontStyle: FontStyle.normal, fontSize: 18),),
                        ],
                      ),
                    ),]
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                FlutterOpenWhatsapp.sendSingleMessage(data['num_tel'], "Bonjour, je suis intéressé par votre annonce");
              },
              child: Icon(Icons.whatsapp),
              backgroundColor: Colors.green,
        ),
          bottomNavigationBar: BottomNavBar(),
    )
    );
  }

}

