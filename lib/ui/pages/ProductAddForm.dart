import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../service/FirebaseService.dart';
import 'dart:io';
import 'package:path/path.dart';

class ProductAddForm extends StatefulWidget {
  const ProductAddForm({Key? key}) : super(key: key);

  @override
  State<ProductAddForm> createState() => _ProductAddFormState();
}

class _ProductAddFormState extends State<ProductAddForm> {

  List <String> _images = [];
  List <XFile> list_images = [];
  final _picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  String _selectedCategory='Choisir la categorie';
  String date='';
  String user = '';
  String name_product = '';
  String price = '';
  String num_tel = '';
  String description = '';
  dynamic data_categories;
  bool isChecked = false;
  bool isMokayada = false;
  bool isLoading=false;

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

      void ImageSelect() async
      {

      XFile? image = (await _picker.pickImage(source: ImageSource.gallery));
      list_images.add(image!);
      setState(() {});
      }

      Future<void> UploadImages() async
      {
        setState((){
          isLoading=true;
        });
        if (formKey.currentState?.validate() != null) {
          if(list_images.length!=0)
            {
              for (var element in list_images) {
                Reference data =  _firebaseService.storageRef.child("product_images/${basename(element.path)}");
                UploadTask uploadTask = data.putFile(File(element.path));
                final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
                String url =  await taskSnapshot.ref.getDownloadURL();
                setState((){
                  _images.add(url);
                });
              }
            }
        }
          await _firebaseService.products.add(
                 {
                   "name": name_product,
                   "category": _selectedCategory,
                   "date": DateTime.now().toString().substring(0,10),
                   "user": _firebaseService.firebaseAuth.currentUser?.displayName,
                   "images": _images,
                   "price": price,
                   "num_tel": num_tel,
                   "description": description,
                   "isMokayada": isMokayada,
                 }
               ).then((value) => {
                 setState((() {
                   isLoading=false;
                 })),
                 showSnackBar("produit ajouter avec success"),
                  Navigator.pushNamed(this.context, '/')
               }).catchError((error) => showSnackBar("Erreur lors d'ajout produit"));
      }


      @override
      void initState() {
    // TODO: implement initState
    super.initState();
    _getCategoriesFromFirestore();
  }

  void showSnackBar(String message) {
    final snackbar = SnackBar(content: Text(message), duration:Duration(seconds: 5),);
    ScaffoldMessenger.of(this.context).showSnackBar(snackbar);
  }


  @override
  Widget build(BuildContext context) {
      if(data_categories == null){
        return Scaffold(
          appBar: AppBar(
            title: Text('Ajouter un produit'),
          ),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un produit'),
      ),
      body: ModalProgressHUD(
      inAsyncCall: isLoading,
          child:SingleChildScrollView(
            child :Container(
              //TODO: add MediaQuery
              width:300,
              height: 500,
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Expanded(
                      child:Form(
                        key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Center(
                        //  child: (isLoading == true)? CircularProgressIndicator():Container(),
                        // ),
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

                          (isMokayada==true)? TextFormField(
                              enabled: false,
                              decoration: const InputDecoration(
                                labelText: 'Prix du produit',

                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please enter some text';
                                }
                                setState(() {
                                  price = value;
                                });
                                return null;
                              },
                            ):TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Prix du produit',

                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please enter some text';
                                }
                                setState(() {
                                  price = value;
                                });
                                return null;
                              },
                            ),
                           TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Numero telephone',

                                ),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please enter some text';
                                  }
                                  setState(() {
                                     num_tel = value;
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
                           ElevatedButton(onPressed:(){
                             ImageSelect();
                           }, child: Icon(Icons.add_a_photo)),
                            Expanded(child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                                itemCount: list_images.length,
                                itemBuilder: (context, index) {
                                  return Image.file(File(list_images[index].path));
                                })
                            ),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            labelText: 'Description du produit',

                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter some text';
                            }
                            setState(() {
                              description = value;
                            });
                            return null;
                          },

                        ),
                          Row(
                            children: [
                              Text("utiliser mokayada?"),
                              Checkbox(
                                checkColor: Colors.white,
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value!;
                                    isMokayada = !isMokayada;
                                  });
                                },
                              ),
                            ],
                          ),
                            ElevatedButton( onPressed: () async {
                               UploadImages();
                              }, child: Text('Ajouter')),
                          ],
                        ),
                    ),
                  ),
          ),
        ),
        ),
    );
  }

}
