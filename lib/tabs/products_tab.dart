import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/tiles/category_tile.dart';

class ProductsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection('products').getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor));
        } else {
          var dividedTiles = ListTile.divideTiles(
                  tiles: snapshot.data.documents.map((e) {
                    return CategoryTile(e);
                  }).toList(),
                  color: Colors.grey[500])
              .toList();
          return ListView(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              children: dividedTiles);
        }
      },
    );
  }
}
