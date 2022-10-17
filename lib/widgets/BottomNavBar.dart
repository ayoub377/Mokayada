import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  FirebaseAuth auth = FirebaseAuth.instance;
  static int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MoltenBottomNavigationBar(
      selectedIndex: _selectedIndex,
      tabs: [
        MoltenTab(
          icon: Icon(Icons.home),
        ),
        MoltenTab(
          icon: Icon(Icons.category),
        ),
        MoltenTab(
          icon: Icon(Icons.person),
        ),
      ],
      onTabChange: (clickedIndex) {
        setState(() {
          _selectedIndex = clickedIndex;
        });
        switch (clickedIndex) {
          case 0:
            Navigator.pushNamed(context, '/');
            break;
          case 1:
            Navigator.pushNamed(context, '/categories');
            break;
          case 2:
            (auth.currentUser == null)
                ? Navigator.pushNamed(context, '/login')
                : Navigator.pushNamed(context, '/profile');
            break;
        }
      },
    );
  }
}
