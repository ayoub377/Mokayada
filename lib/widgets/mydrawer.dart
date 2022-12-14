import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDrawer extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
  MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient:LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.blueAccent],
              ),
            ),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/aji.png'),
              radius: 50,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: (){
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Categories'),
            onTap: (){
              Navigator.pushNamed(context, '/categories');
            },
          ),
            if(auth.currentUser != null)
            ListTile(
              leading:Icon(Icons.person),
              title: Text('Mon profil'),
              onTap: (){
                Navigator.pushNamed(context, '/profile');
              },
            ),
            if(auth.currentUser == null)
              ListTile(
              leading:Icon(Icons.person),
              title: Text('Login'),
              onTap: (){
                Navigator.pushNamed(context, '/register');
              },
            ),
        ],
      ),
    );
  }
}