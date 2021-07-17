import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/models/cart_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartPrice extends StatelessWidget {
  final VoidCallback buy;
  CartPrice(this.buy);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(16),
        child: ScopedModelDescendant<CartModel>(
          builder: (context, child, model) {
            double subtotal = model.getProductsPrice();
            double discount = model.getDiscount();
            double shipPrice = model.getShipPrice();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Resumo do pedido",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal'),
                    Text('R\$ ${subtotal.toStringAsFixed(2)}')
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Desconto'),
                    Text('R\$ ${discount.toStringAsFixed(2)}')
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Entrega'), Text('R\$ $shipPrice')],
                ),
                Divider(),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                        'R\$ ${(subtotal + shipPrice - discount).toStringAsFixed(2)} ',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16))
                  ],
                ),
                SizedBox(height: 16),
                RaisedButton(
                  child: Text('Finalizar pedido'),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onPressed: this.buy,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
