import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CustomCard extends StatelessWidget {
  const CustomCard({Key? key, required this.data}) : super(key: key);
  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Card(
        elevation: 5,
        child: Row(
          children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width/3,
                  child: (data['images'].length ==
                      0)
                      ? Image.asset(
                      'assets/images/empty.jpg')
                      : Image.network(
                    data['images'][0],
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
                  )
                ),
              ),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(data['name'],style: TextStyle(fontStyle: FontStyle.normal, fontSize: 22),),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: (data['isMokayada'] == false)?Text(data['price'].toString() + " Dhs",style: TextStyle(fontStyle: FontStyle.normal, fontSize: 18),)
                      :Text("Echanger",style: TextStyle(fontStyle: FontStyle.normal, fontSize: 18),),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
