import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/datas/cart_product.dart';
import 'package:loja_virtual_flutter/datas/product_data.dart';
import 'package:loja_virtual_flutter/models/cart_model.dart';
import 'package:loja_virtual_flutter/widgets/discount_card.dart';

class CartTile extends StatelessWidget {
  final CartProduct product;

  CartTile(this.product);
  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      CartModel.of(context).updatePrices();
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            width: 120,
            child: Image.network(product.productData.images[0]),
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(product.productData.title,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
                Text(
                  'Tamanho ${product.size}',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                Text(
                  "R\$ ${product.productData.price.toStringAsFixed(2)}",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.remove,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: product.quantity > 1
                            ? () {
                                CartModel.of(context)
                                    .addDecProduct(product, 'dec');
                              }
                            : null),
                    Text(product.quantity.toString()),
                    IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          CartModel.of(context).addDecProduct(product, 'add');
                        }),
                    FlatButton(
                      onPressed: () {
                        CartModel.of(context).removeCartItem(product);
                      },
                      child: Text('Remover'),
                      textColor: Colors.grey[500],
                    )
                  ],
                ),
              ],
            ),
          ))
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: product.productData == null
          ? FutureBuilder<DocumentSnapshot>(
              future: Firestore.instance
                  .collection('products')
                  .document(product.category)
                  .collection('items')
                  .document(product.pid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  product.productData = ProductData.fromDocment(snapshot.data);
                  return _buildContent();
                } else {
                  return Container(
                    height: 70.0,
                    child: CircularProgressIndicator(),
                    alignment: Alignment.center,
                  );
                }
              })
          : _buildContent(),
    );
  }
}
