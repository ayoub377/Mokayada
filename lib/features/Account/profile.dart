import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mokayada/features/listing/home.page.dart';
import '../../../service/FirebaseService.dart';
import '../../widgets/BottomNavBar.dart';

class Profile extends StatefulWidget {

  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _picker = ImagePicker();
  bool isImageSelected = false;
  late XFile image;
  final FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();
  TextEditingController username_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  String username = '';
  String email = '';
  String? imageUrl;

  @override
  void initState() {
    User? user = _firebaseService.firebaseAuth.currentUser;
    username_controller.text = user!.displayName!;
    email_controller.text = user.email!;
    super.initState();
  }
  void ImageSelect() async
  {
    XFile? imagepicked = (await _picker.pickImage(source: ImageSource.gallery));
    setState(() {
      isImageSelected = !isImageSelected;
      image= imagepicked!;
    });
    
  }
  Future<void> UpdateProfile() async
  {
    await _firebaseService.updateProfile(username_controller.text, email_controller.text, image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Center(
                  child: Text('Profile',style:TextStyle(fontSize: 25)),
                ),
              ),
             Container(
               padding: EdgeInsets.only(top: 20),
               height: 150,
               width: 150,
               child: CircleAvatar(
                backgroundImage: (isImageSelected == false)?AssetImage('assets/images/empty.jpg'):Image.file(File(image.path)).image
               ),
             ),
              Padding(padding: EdgeInsets.only(top: 10),
              child: InkWell(
                  child: Text('ajouter photo de profil',style: TextStyle(fontSize: 16,color: Colors.orange,fontWeight: FontWeight.w500),),
                  onTap: (){
                    ImageSelect();
                  },
              ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child:TextField(
                  style: TextStyle(color: Colors.white),
                  controller: username_controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black38,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child:TextField(
                  style: TextStyle(color: Colors.white),
                  controller: email_controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black38,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),

                  ),
                ),),
              Padding(padding: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black38,
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(fontSize: 14),
                ),
                onPressed: () async {
                 await UpdateProfile();
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
                },
                child: Text("changer"),
              ),),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black38,
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(fontSize: 14),
                ),
                onPressed: () async {
                  await _firebaseService.SignOut();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
                },
                child: Text("Logout"),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
