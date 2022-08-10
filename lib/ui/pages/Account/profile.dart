
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../service/FirebaseService.dart';

class Profile extends StatefulWidget {

  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();
  String nom = '';

  void HandleProfile()
  {
    User? user = _firebaseService.GetProfileInfos();
    setState(
            () {
          if(user != null)
          {
            nom = user.displayName!;
          }
        });


  }

  @override
  Widget build(BuildContext context) {
    HandleProfile();
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: SizedBox(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text("Mon Profil",style: TextStyle(fontSize: 30,color: Colors.cyan),),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20,top: 40),
                  child: Text("Bonjour,",style: TextStyle(fontSize: 20),),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,top: 40),
                  child: Text(nom,style: TextStyle(fontSize: 20,color: Colors.brown),),
                ),

              ],
            ),
            Row(
              children:[
              Container(
                margin: EdgeInsets.only(left: 50,top: 100),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:MaterialStateProperty.all(Color(0xFF868585)),
                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                     RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(5),
                     ),
                   )
                  ),
                  onPressed: (){
                    _firebaseService.SignOut();
                    Navigator.pushNamed(context, '/');
                  },
                  child: Text("Se déconnecter",style: TextStyle(fontSize: 20),),
                ),
              ),
    ],
            )
          ],
        ),
      )
    );
  }
}
