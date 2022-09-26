import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mokayada/ui/widgets/dialog_filter.dart';
import '../../service/FirebaseService.dart';
import '../widgets/CustomCard.dart';
import '../widgets/searchBar.dart';

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
   bool isMokayad = false;
   bool isAchat = false;
   late SearchBar searchBar;

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: new Text(widget.categoryname),
      actions: [searchBar.getSearchAction(context)],
    );
  }

  _CategoryDetailsState(){
    searchBar = SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: (String value) {},
        buildDefaultAppBar: buildAppBar
    );
  }




  void refresh() {
     setState(() {
       isFilter = !isFilter;
       data = [];
     });
   }

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
      setState((){
        data?.add(snapshot.data());
      });
    });
  }

  Future<void> GetProductsOfCategory_Achat()async {
    var result = await _firebaseService.Get_prods_achat(widget.categoryname);
    result?.docs.forEach((snapshot) {
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
        appBar: searchBar.build(context),
        body: SingleChildScrollView(
          child: Column(
               children: [
                 Padding(
                   padding: const EdgeInsets.all(20.0),
                   child: Container(
                     width: MediaQuery.of(context).size.width,
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                        children:[
                          InkWell(
                             onTap: (){
                                showDialog(context: context, builder: (context) => DialogFilter(method_achat: GetProductsOfCategory_Achat,method_mokayada: GetProductsOfCategory_Mokayada,notifyParent: refresh,));
                             } ,
                              child: Icon(Icons.filter_list_alt)),
                        ]
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
