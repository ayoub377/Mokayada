import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../service/FirebaseService.dart';
import '../widgets/CustomCard.dart';

class CategoryDetails extends StatefulWidget {
  final categoryname;

  const CategoryDetails({Key? key, required this.categoryname}) : super(key: key);
  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  final FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();
   List<Map<String,dynamic>>? data= [];
   bool isFilter = false;

  Future<void> GetProductsOfCategory()async {
    var result = await _firebaseService.Get_prods(widget.categoryname);
     result?.docs.forEach((snapshot) {
       setState((){
         data?.add(snapshot.data());
       });
     });
  }

  Future<void> GetProductsOfCategory_Mokayada()async {
    var result = await _firebaseService.Get_prods_mokayada(widget.categoryname);
    result?.docs.forEach((snapshot) {
      print(snapshot.data());
      setState((){
        data?.add(snapshot.data());
      });
    });
  }

  Future<void> GetProductsOfCategory_Achat()async {
    var result = await _firebaseService.Get_prods_achat(widget.categoryname);
    result?.docs.forEach((snapshot) {
      print(data);
      setState((){
        data?.add(snapshot.data());
      });
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(isFilter == false)
      {
        GetProductsOfCategory();
      }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.categoryname),
        ),
        body: SingleChildScrollView(
          child: Column(
               children: [
                 Padding(
                   padding: const EdgeInsets.all(20.0),
                   child: Container(
                     width: MediaQuery.of(context).size.width,
                     child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 100,
                            child: ElevatedButton(
                                onPressed: () async {
                                  setState((){
                                    isFilter = !isFilter;
                                    data = [];
                                  });
                                  await GetProductsOfCategory_Mokayada();
                                },
                                child: Text("Mokayada",style: TextStyle(color: Colors.white,fontSize: 12),),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.lightBlueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: ElevatedButton(onPressed: () async {
                              setState((){
                                isFilter = !isFilter;
                                data = [];
                              });
                              await GetProductsOfCategory_Achat();
                            }, child: Text("Achat",style: TextStyle(color: Colors.white,fontSize: 12),),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.lightBlueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),)),
                          ),
                        ],
                      ),
                     ),
                   ),
                 Container(
                            child: ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context,index){
                              return CustomCard(
                                data: data?[index],
                              );
                            },
                              itemCount: data?.length,
                            ),
            ),],
             ),
        ),
        ),
    );
  }


}
