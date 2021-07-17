import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/models/cart_model.dart';

class DiscountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          'Cupom de desconto',
          textAlign: TextAlign.start,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Digite seu cupom'),
              initialValue: CartModel.of(context).couponCode ?? "",
              onFieldSubmitted: (text) {
                Firestore.instance
                    .collection('coupons')
                    .document(text)
                    .get()
                    .then((docSnap) {
                  if (docSnap.data != null) {
                    CartModel.of(context)
                        .setCoupon(text, docSnap.data['percent']);
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Desconto de ${docSnap.data['percent']}% aplicado com sucesso :)'),
                        backgroundColor: Theme.of(context).primaryColor));
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('O cupom inserido não existe :('),
                        backgroundColor: Colors.redAccent));
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
