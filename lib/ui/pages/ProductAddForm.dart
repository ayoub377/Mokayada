
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../service/FirebaseService.dart';

class ProductAddForm extends StatefulWidget {
  const ProductAddForm({Key? key}) : super(key: key);

  @override
  State<ProductAddForm> createState() => _ProductAddFormState();
}

class _ProductAddFormState extends State<ProductAddForm> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory='Choisir la categorie';
  String date='';
  String user = '';
  String name_product = '';
  dynamic data_categories;
  final FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();


    Future<void> _getCategoriesFromFirestore() async {
      Map categories = <String, String>{};
      _firebaseService.categories.get().then((querySnapshot) => {
      querySnapshot.docs.forEach((doc) => {
        categories[doc.id] = doc["name"]
      }),
      setState(() {
        data_categories = categories.values.toList();
      })
      });
      }

      @override
      void initState() {
    // TODO: implement initState
    super.initState();
    _getCategoriesFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
      if(data_categories == null){
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un produit'),
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nom du produit',

                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please enter some text';
                  }
                  setState(() {
                    name_product = value;
                  });
                  return null;
                },
              ),
              DropdownButton(
                  items:data_categories.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: Text(_selectedCategory),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value as String;
                    });
                  },
              ),
             ElevatedButton(onPressed:() async{
               final results = await FilePicker.platform.pickFiles(
                 type: FileType.custom, allowedExtensions: ['jpg', 'png']);
               if (results == null)
                 {
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('Aucun fichier Selectionner')));
                 }
               final path = results?.files.single.path;
               print(path);

             } , child: Icon(Icons.add_a_photo)),
              ElevatedButton(onPressed: (){
                if (_formKey.currentState!.validate()) {
                  _firebaseService.products.add({
                    'name': name_product,
                    'category': '${_selectedCategory}',
                    'date': DateTime.now().toString(),
                    'user': '${_firebaseService.firebaseAuth.currentUser?.displayName}'
                  });
                }
                showDialog(context: context, builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Produit ajouté'),
                    content: Text('Votre produit a été ajouté avec succès'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                      )
                    ],
                  );
                });
              }, child: Text("Ajouter le produit")),
            ],
          )
      ),
    );

  }

}
