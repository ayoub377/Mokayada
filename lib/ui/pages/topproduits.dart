import 'package:flutter/material.dart';

class TopProduits extends StatelessWidget {
  const TopProduits({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Produits'),
      ),
      body: Center(
        child: Text('Top Produits'),
      ),
    );
  }
}
