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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
        setState(() {
          isLoading = true;
        });
        if (list_images.length != 0) {
          for (var element in list_images) {
            Reference data = _firebaseService.storageRef.child("product_images/${basename(element.path)}");
            UploadTask uploadTask = data.putFile(File(element.path));
            final TaskSnapshot taskSnapshot = await uploadTask
                .whenComplete(() {});
            String url = await taskSnapshot.ref.getDownloadURL();
            setState(() {
              _images.add(url);
            });
          }
        }
        if (formKey.currentState?.validate() == true) {
          await _firebaseService.products.add(
              {
                "name": name_product,
                "category": _selectedCategory,
                "date": DateTime.now().toString().substring(0, 10),
                "user": _firebaseService.firebaseAuth.currentUser?.displayName,
                "images": _images,
                "price": price,
                "num_tel": num_tel,
                "description": description,
                "isMokayada": isMokayada,
              }
          ).then((value) =>
          {
            setState((() {
              isLoading = false;
            })),
            showSnackBar("produit ajouter avec success"),
            Navigator.pushNamed(this.context, '/')
          }).catchError((error) => showSnackBar("Erreur lors d'ajout produit"));
          formKey.currentState?.save();
        }
        else{
          showSnackBar("Erreur dans le formulaire");
          setState((){
            isLoading = false;
          });
        }
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
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    return Scaffold(
      body: ModalProgressHUD(
      inAsyncCall: isLoading,
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child:Form(
                          key: formKey,
                          child: Column(
                                children: [
                                  TextFormField(
                                            decoration: InputDecoration(
                                              labelText: 'Nom du produit',
                                            ),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Veuiilez saisir le nom du produit';
                                              }
                                              setState(() {
                                                name_product = value;
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
                                        (isMokayada==true)? TextFormField(
                                            enabled: false,
                                            decoration: const InputDecoration(
                                              labelText: 'Prix du produit',

                                            ),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Veuillez saisir le prix du produit';
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
                                              if (value == null || value.isEmpty) {
                                                return 'Veuillez saisir le prix du produit';
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
                                                if (value == null || value.isEmpty) {
                                                  return 'Veuiilez saisir le numero de telephone';
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
                                      TextFormField(
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                          labelText: 'Description du produit',

                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Veuillez saisir la description du produit';
                                          }
                                          setState(() {
                                            description = value;
                                          });
                                          return null;
                                        },

                                      ),
                                         ElevatedButton(onPressed:(){
                                           ImageSelect();
                                         }, child: Icon(Icons.add_a_photo)),
                                           Container(
                                             height: 200,
                                             child: GridView.builder(
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3),
                                                itemCount: list_images.length,
                                                itemBuilder: (context, index) {
                                                  return Image.file(File(list_images[index].path));
                                                }),
                                           ),
                                          ElevatedButton( onPressed: () async {
                                             UploadImages();
                                            }, child: Text('Ajouter')),
                                ],
                              ),
                        )
                          ),
                      ]),

            ),
      ),
    );
  }

}
